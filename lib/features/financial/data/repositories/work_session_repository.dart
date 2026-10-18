import 'package:meta/meta.dart';
import 'package:rota_plus/data/local/daos/outbox_dao.dart';
import 'package:rota_plus/data/local/daos/session_dao.dart';
import 'package:rota_plus/data/local/database.dart';
import 'package:rota_plus/data/local/tables.dart';
import 'package:uuid/uuid.dart';

/// Expediente do motorista.
@immutable
final class WorkSession {
  /// Cria a sessão.
  const WorkSession({
    required this.clientId,
    required this.startedAt,
    this.endedAt,
  });

  /// UUID gerado no dispositivo.
  final String clientId;

  /// Início do expediente.
  final DateTime startedAt;

  /// Fim do expediente. Nulo enquanto estiver aberto.
  final DateTime? endedAt;

  /// Indica se o expediente está em andamento.
  bool get isOpen => endedAt == null;

  /// Duração até agora, ou até o encerramento.
  Duration durationUntil(DateTime now) =>
      (endedAt ?? now).difference(startedAt);

  /// Minutos que a sessão cobre dentro de um intervalo.
  ///
  /// Recorta a sessão ao período para que uma madrugada que atravessa a
  /// meia-noite conte as horas certas em cada dia, em vez de inteiras nos dois.
  double minutesWithin({
    required DateTime from,
    required DateTime to,
    required DateTime now,
  }) {
    final start = startedAt.isAfter(from) ? startedAt : from;
    final rawEnd = endedAt ?? now;
    final end = rawEnd.isBefore(to) ? rawEnd : to;

    if (!end.isAfter(start)) return 0;
    return end.difference(start).inSeconds / 60;
  }
}

/// Registro de expediente, com escrita local-first.
class WorkSessionRepository {
  /// Cria o repositório.
  WorkSessionRepository({
    required AppDatabase database,
    required SessionDao sessionDao,
    required OutboxDao outboxDao,
    Uuid uuid = const Uuid(),
    DateTime Function() clock = _utcNow,
  }) : _db = database,
       _sessions = sessionDao,
       _outbox = outboxDao,
       _uuid = uuid,
       _clock = clock;

  static DateTime _utcNow() => DateTime.now().toUtc();

  final AppDatabase _db;
  final SessionDao _sessions;
  final OutboxDao _outbox;
  final Uuid _uuid;
  final DateTime Function() _clock;

  /// Observa o expediente aberto, se houver.
  Stream<WorkSession?> watchOpen() =>
      _sessions.watchOpen().map((row) => row == null ? null : _toDomain(row));

  /// Inicia um expediente.
  ///
  /// Se já houver um aberto, devolve o existente em vez de criar outro: dois
  /// expedientes simultâneos fariam a contagem de horas dobrar.
  Future<String> start() async {
    final open = await _sessions.getOpen();
    if (open != null) return open.clientId;

    final clientId = _uuid.v4();
    final now = _clock();

    await _db.transaction(() async {
      await _sessions.upsert(
        LocalWorkSession(clientId: clientId, startedAt: now),
      );
      await _outbox.enqueue(
        kind: OutboxKind.workSessionUpsert,
        entityClientId: clientId,
      );
    });

    return clientId;
  }

  /// Encerra o expediente aberto. Não faz nada se não houver nenhum.
  Future<void> stop() async {
    final open = await _sessions.getOpen();
    if (open == null) return;

    final now = _clock();
    await _db.transaction(() async {
      await _sessions.closeSession(open.clientId, now);
      await _outbox.enqueue(
        kind: OutboxKind.workSessionUpsert,
        entityClientId: open.clientId,
      );
    });
  }

  /// Minutos de expediente dentro de um período.
  Future<double> minutesWorked({
    required DateTime from,
    required DateTime to,
  }) async {
    final rows = await _sessions.getInPeriod(from: from, to: to);
    final now = _clock();

    return rows.fold<double>(
      0,
      (total, row) =>
          total + _toDomain(row).minutesWithin(from: from, to: to, now: now),
    );
  }

  WorkSession _toDomain(LocalWorkSession row) => WorkSession(
    clientId: row.clientId,
    startedAt: row.startedAt,
    endedAt: row.endedAt,
  );
}
