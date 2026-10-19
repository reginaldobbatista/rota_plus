import 'package:drift/drift.dart';
import 'package:rota_plus/data/local/database.dart';
import 'package:rota_plus/data/local/tables.dart';

part 'session_dao.g.dart';

/// Acesso às sessões de trabalho no banco local.
@DriftAccessor(tables: [LocalWorkSessions])
class SessionDao extends DatabaseAccessor<AppDatabase> with _$SessionDaoMixin {
  /// Cria o DAO.
  SessionDao(super.db);

  /// Insere ou atualiza uma sessão.
  Future<void> upsert(LocalWorkSession row) =>
      into(localWorkSessions).insertOnConflictUpdate(row);

  /// Observa a sessão aberta, se houver.
  ///
  /// Sessão aberta é a que não tem fim registrado. Só pode haver uma.
  Stream<LocalWorkSession?> watchOpen() {
    final query = select(localWorkSessions)
      ..where((t) => t.endedAt.isNull())
      ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
      ..limit(1);
    return query.watchSingleOrNull();
  }

  /// Lê a sessão aberta uma única vez.
  Future<LocalWorkSession?> getOpen() {
    final query = select(localWorkSessions)
      ..where((t) => t.endedAt.isNull())
      ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
      ..limit(1);
    return query.getSingleOrNull();
  }

  /// Lê as sessões que tocam um período.
  ///
  /// Inclui sessão que começou antes do período e ainda estava aberta — uma
  /// madrugada que atravessa a meia-noite pertence aos dois dias.
  Future<List<LocalWorkSession>> getInPeriod({
    required DateTime from,
    required DateTime to,
  }) {
    final query = select(localWorkSessions)
      ..where((t) => t.startedAt.isSmallerThanValue(to))
      ..where((t) => t.endedAt.isNull() | t.endedAt.isBiggerThanValue(from))
      ..orderBy([(t) => OrderingTerm.asc(t.startedAt)]);
    return query.get();
  }

  /// Lê várias sessões de uma vez, para montar o lote de sincronização.
  Future<List<LocalWorkSession>> findManyByClientId(List<String> clientIds) =>
      (select(
        localWorkSessions,
      )..where((t) => t.clientId.isIn(clientIds))).get();

  /// Encerra uma sessão.
  Future<void> closeSession(String clientId, DateTime endedAt) =>
      (update(localWorkSessions)..where((t) => t.clientId.equals(clientId)))
          .write(LocalWorkSessionsCompanion(endedAt: Value(endedAt)));
}
