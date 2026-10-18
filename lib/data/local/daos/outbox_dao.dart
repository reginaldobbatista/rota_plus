import 'package:drift/drift.dart';
import 'package:rota_plus/data/local/database.dart';
import 'package:rota_plus/data/local/tables.dart';

part 'outbox_dao.g.dart';

/// Acesso à fila de sincronização.
@DriftAccessor(tables: [OutboxEntries])
class OutboxDao extends DatabaseAccessor<AppDatabase> with _$OutboxDaoMixin {
  /// Cria o DAO.
  OutboxDao(super.db);

  /// Enfileira uma operação.
  ///
  /// Reenfileirar a mesma entidade não duplica a pendência: a restrição
  /// `UNIQUE (kind, entity_client_id)` faz a segunda chamada substituir a
  /// primeira. Isso importa quando o motorista edita a mesma despesa três
  /// vezes offline — sobe uma vez, com o estado final.
  Future<void> enqueue({
    required OutboxKind kind,
    required String entityClientId,
    DateTime? now,
  }) => into(outboxEntries).insert(
    OutboxEntriesCompanion.insert(
      kind: kind,
      entityClientId: entityClientId,
      createdAt: now ?? DateTime.now().toUtc(),
    ),
    onConflict: DoUpdate(
      (_) => OutboxEntriesCompanion(
        createdAt: Value(now ?? DateTime.now().toUtc()),
        attempts: const Value(0),
        lastError: const Value(null),
      ),
      target: [outboxEntries.kind, outboxEntries.entityClientId],
    ),
  );

  /// Lê o próximo lote a enviar, na ordem de enfileiramento.
  ///
  /// O lote é limitado porque `rpc_sync_rides` aceita no máximo 200 itens e
  /// porque uma requisição gigante num sinal ruim falha inteira.
  Future<List<OutboxEntry>> nextBatch({int limit = 100}) {
    final query = select(outboxEntries)
      ..orderBy([(t) => OrderingTerm.asc(t.id)])
      ..limit(limit);
    return query.get();
  }

  /// Lê o próximo lote de um tipo específico.
  Future<List<OutboxEntry>> nextBatchOfKind(
    OutboxKind kind, {
    int limit = 100,
  }) {
    final query = select(outboxEntries)
      ..where((t) => t.kind.equalsValue(kind))
      ..orderBy([(t) => OrderingTerm.asc(t.id)])
      ..limit(limit);
    return query.get();
  }

  /// Observa quantas operações estão pendentes.
  ///
  /// A UI usa isso para mostrar "3 registros aguardando conexão" em vez de
  /// deixar o motorista na dúvida se o dado foi salvo.
  Stream<int> watchPendingCount() {
    final count = outboxEntries.id.count();
    final query = selectOnly(outboxEntries)..addColumns([count]);
    return query.watchSingle().map((row) => row.read(count) ?? 0);
  }

  /// Remove as operações já confirmadas pelo servidor.
  Future<void> markDone(List<int> ids) =>
      (delete(outboxEntries)..where((t) => t.id.isIn(ids))).go();

  /// Registra a falha de uma tentativa, mantendo a operação na fila.
  Future<void> markFailed(List<int> ids, String error) => customUpdate(
    'UPDATE outbox_entries SET attempts = attempts + 1, last_error = ? '
    'WHERE id IN (${List.filled(ids.length, '?').join(', ')})',
    variables: [Variable<String>(error), ...ids.map(Variable<int>.new)],
    updates: {outboxEntries},
  );
}
