import 'dart:async';

import 'package:rota_plus/data/local/daos/expense_dao.dart';
import 'package:rota_plus/data/local/daos/outbox_dao.dart';
import 'package:rota_plus/data/local/daos/ride_dao.dart';
import 'package:rota_plus/data/local/daos/session_dao.dart';
import 'package:rota_plus/data/local/mappers/expense_mapper.dart';
import 'package:rota_plus/data/local/mappers/ride_mapper.dart';
import 'package:rota_plus/data/local/tables.dart';

/// Envia lotes ao servidor.
///
/// Abstraído para que o motor de sincronização não dependa do
/// `supabase_flutter` — o que mantém a camada testável sem rede e permite
/// trocar o backend sem reescrever a lógica de fila.
abstract interface class RemoteSyncClient {
  /// Sobe corridas. Deve ser idempotente por `client_id`.
  Future<void> pushRides(List<Map<String, Object?>> payload);

  /// Sobe despesas. Deve resolver conflito por `updated_at`.
  Future<void> pushExpenses(List<Map<String, Object?>> payload);

  /// Sobe sessões de trabalho. Deve ser idempotente por `client_id`.
  Future<void> pushWorkSessions(List<Map<String, Object?>> payload);
}

/// Resultado de uma rodada de sincronização.
final class SyncResult {
  /// Cria o resultado.
  const SyncResult({
    required this.sent,
    required this.failed,
    this.skippedOffline = false,
    this.error,
  });

  /// Rodada que não aconteceu por falta de backend ou de conexão.
  static const SyncResult offline = SyncResult(
    sent: 0,
    failed: 0,
    skippedOffline: true,
  );

  /// Rodada sem nada pendente.
  static const SyncResult idle = SyncResult(sent: 0, failed: 0);

  /// Operações confirmadas pelo servidor.
  final int sent;

  /// Operações que falharam e continuam na fila.
  final int failed;

  /// Indica que nem se tentou, por estar offline.
  final bool skippedOffline;

  /// Erro da primeira falha da rodada, quando houve.
  final String? error;

  /// Indica se houve alguma alteração.
  bool get didWork => sent > 0 || failed > 0;

  /// Combina duas rodadas parciais numa só.
  SyncResult merge(SyncResult other) => SyncResult(
    sent: sent + other.sent,
    failed: failed + other.failed,
    skippedOffline: skippedOffline && other.skippedOffline,
    error: error ?? other.error,
  );
}

/// Drena a fila do outbox para o servidor.
///
/// Envia **em lote**, não um registro por requisição: 50 corridas numa chamada
/// significam um handshake TLS em vez de 50, e menos tempo de rádio ligado —
/// que é bateria do motorista.
///
/// Cada tipo de entidade é drenado separadamente: a falha de um lote de
/// despesas não impede as corridas de subirem.
class SyncEngine {
  /// Cria o motor de sincronização.
  SyncEngine({
    required OutboxDao outboxDao,
    required RideDao rideDao,
    required ExpenseDao expenseDao,
    required SessionDao sessionDao,
    required bool Function() isOnline,
    RemoteSyncClient? client,
    int batchSize = 100,
  }) : _outbox = outboxDao,
       _rides = rideDao,
       _expenses = expenseDao,
       _sessions = sessionDao,
       _isOnline = isOnline,
       _client = client,
       _batchSize = batchSize;

  final OutboxDao _outbox;
  final RideDao _rides;
  final ExpenseDao _expenses;
  final SessionDao _sessions;
  final bool Function() _isOnline;
  final RemoteSyncClient? _client;
  final int _batchSize;

  /// Evita duas rodadas concorrentes enviando o mesmo lote duas vezes.
  bool _running = false;

  /// Observa quantas operações aguardam envio.
  Stream<int> watchPendingCount() => _outbox.watchPendingCount();

  /// Executa uma rodada de sincronização.
  ///
  /// Sem backend configurado ou sem conexão, não falha: devolve
  /// [SyncResult.offline] e deixa a fila intacta. A fila é o mecanismo de
  /// resiliência, não um estado de erro.
  Future<SyncResult> flush() async {
    final client = _client;
    if (client == null || !_isOnline()) return SyncResult.offline;
    if (_running) return SyncResult.idle;

    _running = true;
    try {
      final rides = await _flushKind(
        kind: OutboxKind.rideInsert,
        loadPayloads: _ridePayloads,
        push: client.pushRides,
      );
      final expenses = await _flushKind(
        kind: OutboxKind.expenseUpsert,
        loadPayloads: _expensePayloads,
        push: client.pushExpenses,
      );
      final sessions = await _flushKind(
        kind: OutboxKind.workSessionUpsert,
        loadPayloads: _sessionPayloads,
        push: client.pushWorkSessions,
      );
      return rides.merge(expenses).merge(sessions);
    } finally {
      _running = false;
    }
  }

  /// Drena uma fila específica.
  ///
  /// [loadPayloads] devolve o payload de cada `clientId` encontrado; os que
  /// faltarem são tratados como órfãos e removidos da fila.
  Future<SyncResult> _flushKind({
    required OutboxKind kind,
    required Future<Map<String, Map<String, Object?>>> Function(List<String>)
    loadPayloads,
    required Future<void> Function(List<Map<String, Object?>>) push,
  }) async {
    final pending = await _outbox.nextBatchOfKind(kind, limit: _batchSize);
    if (pending.isEmpty) return SyncResult.idle;

    final payloads = await loadPayloads(
      pending.map((e) => e.entityClientId).toList(),
    );

    // Pendência cujo registro desapareceu do banco não tem o que enviar.
    // Mantê-la na fila seria um loop infinito de falhas.
    final orphans = pending
        .where((e) => !payloads.containsKey(e.entityClientId))
        .map((e) => e.id)
        .toList();
    if (orphans.isNotEmpty) await _outbox.markDone(orphans);

    final sendable = pending
        .where((e) => payloads.containsKey(e.entityClientId))
        .toList();
    if (sendable.isEmpty) return SyncResult.idle;

    try {
      await push(sendable.map((e) => payloads[e.entityClientId]!).toList());
      await _outbox.markDone(sendable.map((e) => e.id).toList());
      return SyncResult(sent: sendable.length, failed: 0);
    } on Object catch (error) {
      // A fila sobrevive ao erro: a próxima rodada tenta de novo. O servidor
      // é idempotente por client_id, então reenviar é seguro.
      await _outbox.markFailed(
        sendable.map((e) => e.id).toList(),
        error.toString(),
      );
      return SyncResult(
        sent: 0,
        failed: sendable.length,
        error: error.toString(),
      );
    }
  }

  Future<Map<String, Map<String, Object?>>> _ridePayloads(
    List<String> clientIds,
  ) async {
    final rows = await _rides.findManyByClientId(clientIds);
    return {for (final row in rows) row.clientId: row.toSyncPayload()};
  }

  Future<Map<String, Map<String, Object?>>> _expensePayloads(
    List<String> clientIds,
  ) async {
    final rows = await _expenses.findManyByClientId(clientIds);
    return {for (final row in rows) row.clientId: row.toSyncPayload()};
  }

  Future<Map<String, Map<String, Object?>>> _sessionPayloads(
    List<String> clientIds,
  ) async {
    final rows = await _sessions.findManyByClientId(clientIds);
    return {for (final row in rows) row.clientId: row.toSyncPayload()};
  }
}
