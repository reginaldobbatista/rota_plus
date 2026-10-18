import 'package:drift/drift.dart';
import 'package:rota_plus/data/local/database.dart';
import 'package:rota_plus/data/local/tables.dart';
import 'package:rota_plus/features/history/domain/entities/daily_totals.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_evaluation.dart';

part 'ride_dao.g.dart';

/// Acesso às corridas avaliadas no banco local.
@DriftAccessor(tables: [LocalRideEvaluations])
class RideDao extends DatabaseAccessor<AppDatabase> with _$RideDaoMixin {
  /// Cria o DAO.
  RideDao(super.db);

  /// Insere uma corrida avaliada, ignorando reinserção do mesmo `clientId`.
  ///
  /// A tabela é insert-only e idempotente: reprocessar a mesma oferta — porque
  /// o AccessibilityService disparou o evento duas vezes — não duplica a linha.
  Future<void> insertRide(LocalRide row) =>
      into(localRideEvaluations).insert(row, mode: InsertMode.insertOrIgnore);

  /// Observa as corridas mais recentes, da mais nova para a mais antiga.
  Stream<List<LocalRide>> watchRecent({int limit = 50}) {
    final query = select(localRideEvaluations)
      ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)])
      ..limit(limit);
    return query.watch();
  }

  /// Observa as corridas de um período, paginando.
  Stream<List<LocalRide>> watchByPeriod({
    required DateTime from,
    required DateTime to,
    int limit = 50,
    int offset = 0,
  }) {
    final query = select(localRideEvaluations)
      ..where((t) => t.occurredAt.isBiggerOrEqualValue(from))
      ..where((t) => t.occurredAt.isSmallerThanValue(to))
      ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)])
      ..limit(limit, offset: offset);
    return query.watch();
  }

  /// Observa o resumo de um dia.
  Stream<DailyTotals> watchDailyTotals(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));

    final accepted = localRideEvaluations.outcome.equalsValue(
      RideOutcome.accepted,
    );

    final evaluatedCount = localRideEvaluations.clientId.count();
    final acceptedCount = localRideEvaluations.clientId.count(filter: accepted);
    final rejectedCount = localRideEvaluations.clientId.count(
      filter: localRideEvaluations.outcome.equalsValue(RideOutcome.rejected),
    );
    // `fare` e `realProfit` são TEXT por causa do Decimal; `CAST` permite somar
    // em SQL. A perda de precisão é aceitável num indicador de tela — o
    // fechamento de caixa oficial soma em Decimal.
    final grossSum = localRideEvaluations.fare.cast<double>().sum(
      filter: accepted,
    );
    final profitSum = localRideEvaluations.realProfit.cast<double>().sum(
      filter: accepted,
    );

    final query = selectOnly(localRideEvaluations)
      ..addColumns([
        evaluatedCount,
        acceptedCount,
        rejectedCount,
        grossSum,
        profitSum,
      ])
      ..where(
        localRideEvaluations.occurredAt.isBiggerOrEqualValue(start) &
            localRideEvaluations.occurredAt.isSmallerThanValue(end),
      );

    return query.watchSingleOrNull().map((row) {
      if (row == null) return DailyTotals.empty;
      return DailyTotals(
        evaluated: row.read(evaluatedCount) ?? 0,
        accepted: row.read(acceptedCount) ?? 0,
        rejected: row.read(rejectedCount) ?? 0,
        grossRevenue: row.read(grossSum) ?? 0,
        netProfit: row.read(profitSum) ?? 0,
      );
    });
  }

  /// Registra o desfecho de uma corrida já avaliada.
  Future<void> setOutcome(String clientId, RideOutcome outcome) =>
      (update(localRideEvaluations)..where((t) => t.clientId.equals(clientId)))
          .write(LocalRideEvaluationsCompanion(outcome: Value(outcome)));

  /// Busca uma corrida pelo `clientId`.
  Future<LocalRide?> findByClientId(String clientId) => (select(
    localRideEvaluations,
  )..where((t) => t.clientId.equals(clientId))).getSingleOrNull();

  /// Lê as corridas de um conjunto de `clientId`, para montar o lote de sync.
  Future<List<LocalRide>> findManyByClientId(List<String> clientIds) => (select(
    localRideEvaluations,
  )..where((t) => t.clientId.isIn(clientIds))).get();
}
