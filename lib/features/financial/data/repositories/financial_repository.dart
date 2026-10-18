import 'package:decimal/decimal.dart';
import 'package:rota_plus/core/money/decimal_x.dart';
import 'package:rota_plus/data/local/daos/report_dao.dart';
import 'package:rota_plus/data/local/database.dart';
import 'package:rota_plus/features/expenses/domain/entities/expense.dart';
import 'package:rota_plus/features/financial/data/repositories/work_session_repository.dart';
import 'package:rota_plus/features/financial/domain/entities/period_summary.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_evaluation.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_offer.dart';

/// Relatório consolidado de um período.
class CashReport {
  /// Cria o relatório.
  const CashReport({
    required this.summary,
    required this.dailySeries,
    required this.expensesByCategory,
    required this.platformStats,
    required this.hourStats,
  });

  /// Relatório vazio.
  static CashReport get empty => CashReport(
    summary: PeriodSummary.empty,
    dailySeries: const [],
    expensesByCategory: const {},
    platformStats: const [],
    hourStats: const [],
  );

  /// Apuração do período.
  final PeriodSummary summary;

  /// Série diária, para o gráfico de evolução.
  final List<DailyPoint> dailySeries;

  /// Despesas agrupadas por categoria.
  final Map<ExpenseCategory, Decimal> expensesByCategory;

  /// Desempenho por plataforma.
  final List<PlatformStat> platformStats;

  /// Mapa de calor por dia da semana e hora.
  final List<HourStat> hourStats;

  /// Indica se há algo para mostrar.
  bool get isEmpty => summary.ridesEvaluated == 0 && expensesByCategory.isEmpty;
}

/// Apuração financeira a partir do banco local.
///
/// Soma em `Decimal`, não em `double`: este é o número que o motorista usa
/// para saber se a semana fechou no azul.
class FinancialRepository {
  /// Cria o repositório.
  FinancialRepository({required ReportDao dao}) : _dao = dao;

  final ReportDao _dao;

  /// Observa o relatório de um período.
  Stream<CashReport> watchReport({
    required DateTime from,
    required DateTime to,
  }) => _dao
      .watchPeriod(from: from, to: to)
      .map((rows) => _build(rows, from: from, to: to));

  /// Lê o relatório de um período uma única vez.
  Future<CashReport> fetchReport({
    required DateTime from,
    required DateTime to,
  }) async => _build(
    await _dao.fetchPeriod(from: from, to: to),
    from: from,
    to: to,
  );

  CashReport _build(
    PeriodRows rows, {
    required DateTime from,
    required DateTime to,
  }) {
    final accepted = rows.rides
        .where((r) => r.outcome == RideOutcome.accepted)
        .toList();

    final now = DateTime.now().toUtc();
    final minutesWorked = rows.sessions.fold<double>(
      0,
      (total, row) =>
          total +
          WorkSession(
            clientId: row.clientId,
            startedAt: row.startedAt,
            endedAt: row.endedAt,
          ).minutesWithin(from: from, to: to, now: now),
    );

    final summary = PeriodSummary(
      minutesWorked: minutesWorked,
      ridesEvaluated: rows.rides.length,
      ridesAccepted: accepted.length,
      grossRevenue: _sum(accepted.map((r) => r.fare)),
      operatingCost: _sum(accepted.map((r) => r.operatingCost)),
      extraExpenses: _sum(rows.expenses.map((e) => e.amount)),
      kmDriven: _sum(accepted.map((r) => r.pickupKm + r.tripKm)),
      minutesDriven: accepted.fold<double>(
        0,
        (total, r) => total + r.pickupMinutes + r.tripMinutes,
      ),
    );

    return CashReport(
      summary: summary,
      dailySeries: _dailySeries(accepted),
      expensesByCategory: _expensesByCategory(rows.expenses),
      platformStats: _platformStats(rows.rides),
      hourStats: _hourStats(rows.rides),
    );
  }

  static Decimal _sum(Iterable<Decimal> values) =>
      values.fold(Decimal.zero, (total, value) => total + value);

  /// Agrupa por dia **local**.
  ///
  /// As datas são gravadas em UTC; converter antes de agrupar é o que faz a
  /// corrida das 22h aparecer no dia certo para o motorista.
  List<DailyPoint> _dailySeries(List<LocalRide> accepted) {
    final byDay = <DateTime, List<LocalRide>>{};

    for (final ride in accepted) {
      final local = ride.occurredAt.toLocal();
      final day = DateTime(local.year, local.month, local.day);
      byDay.putIfAbsent(day, () => []).add(ride);
    }

    final days = byDay.keys.toList()..sort();
    return [
      for (final day in days)
        DailyPoint(
          day: day,
          grossRevenue: _sum(byDay[day]!.map((r) => r.fare)),
          netProfit: _sum(byDay[day]!.map((r) => r.realProfit)),
          rides: byDay[day]!.length,
        ),
    ];
  }

  Map<ExpenseCategory, Decimal> _expensesByCategory(
    List<LocalExpense> expenses,
  ) {
    final totals = <ExpenseCategory, Decimal>{};
    for (final expense in expenses) {
      totals[expense.category] =
          (totals[expense.category] ?? Decimal.zero) + expense.amount;
    }
    return totals;
  }

  List<PlatformStat> _platformStats(List<LocalRide> rides) {
    final byPlatform = <RidePlatform, List<LocalRide>>{};
    for (final ride in rides) {
      byPlatform.putIfAbsent(ride.platform, () => []).add(ride);
    }

    final stats = [
      for (final entry in byPlatform.entries)
        PlatformStat(
          platform: entry.key,
          offers: entry.value.length,
          accepted: entry.value
              .where((r) => r.outcome == RideOutcome.accepted)
              .length,
          avgRsPerKm: _average(entry.value.map((r) => r.rsPerKm)),
          avgRsPerHour: _average(entry.value.map((r) => r.rsPerHour)),
          totalProfit: _sum(
            entry.value
                .where((r) => r.outcome == RideOutcome.accepted)
                .map((r) => r.realProfit),
          ),
        ),
    ];

    stats.sort((a, b) => b.offers.compareTo(a.offers));
    return stats;
  }

  List<HourStat> _hourStats(List<LocalRide> rides) {
    final buckets = <(int, int), List<LocalRide>>{};

    for (final ride in rides) {
      final local = ride.occurredAt.toLocal();
      // `DateTime.weekday` vai de 1 (segunda) a 7 (domingo); o heatmap usa
      // 0 (domingo) a 6 (sábado), como o `extract(dow)` do Postgres.
      final weekday = local.weekday % 7;
      buckets.putIfAbsent((weekday, local.hour), () => []).add(ride);
    }

    return [
      for (final entry in buckets.entries)
        HourStat(
          weekday: entry.key.$1,
          hour: entry.key.$2,
          offers: entry.value.length,
          avgRsPerKm: _average(entry.value.map((r) => r.rsPerKm)),
        ),
    ];
  }

  static Decimal _average(Iterable<Decimal> values) {
    final list = values.toList();
    if (list.isEmpty) return Decimal.zero;
    return _sum(list).divideBy(Decimal.fromInt(list.length));
  }
}
