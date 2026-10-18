import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rota_plus/data/local/database.dart';
import 'package:rota_plus/features/expenses/data/repositories/expense_repository.dart';
import 'package:rota_plus/features/expenses/domain/entities/expense.dart';
import 'package:rota_plus/features/financial/data/repositories/financial_repository.dart';
import 'package:rota_plus/features/financial/domain/entities/period_summary.dart';
import 'package:rota_plus/features/history/data/repositories/ride_history_repository.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_evaluation.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_offer.dart';

import '../support/fixtures.dart';

void main() {
  late AppDatabase db;
  late RideHistoryRepository rides;
  late ExpenseRepository expenses;
  late FinancialRepository financial;

  // Meio-dia local, para o agrupamento por dia não depender do fuso da máquina.
  final day1 = DateTime(2026, 10, 15, 12);
  final day2 = DateTime(2026, 10, 16, 12);
  final from = DateTime(2026, 10);
  final to = DateTime(2026, 11);

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    rides = RideHistoryRepository(
      database: db,
      rideDao: db.rideDao,
      outboxDao: db.outboxDao,
    );
    expenses = ExpenseRepository(
      database: db,
      expenseDao: db.expenseDao,
      outboxDao: db.outboxDao,
    );
    financial = FinancialRepository(dao: db.reportDao);
  });

  tearDown(() => db.close());

  Future<void> addRide({
    required String fare,
    required DateTime at,
    RideOutcome outcome = RideOutcome.accepted,
    RidePlatform platform = RidePlatform.uber,
  }) => rides.record(
    testEvaluation(fare: fare, platform: platform, capturedAt: at),
    outcome: outcome,
  );

  Future<CashReport> report() => financial.fetchReport(from: from, to: to);

  group('FinancialRepository · apuração', () {
    test('soma só as corridas aceitas no faturamento', () async {
      await addRide(fare: '20.00', at: day1);
      await addRide(fare: '50.00', at: day1, outcome: RideOutcome.rejected);

      final s = (await report()).summary;

      expect(s.ridesEvaluated, 2);
      expect(s.ridesAccepted, 1);
      expect(s.grossRevenue, d('20'));
      expect(s.acceptanceRate, 0.5);
    });

    test('desconta custo operacional e despesas do lucro', () async {
      await addRide(fare: '20.00', at: day1);
      await expenses.add(
        category: ExpenseCategory.food,
        amount: d('12.50'),
        occurredAt: day1,
      );

      final s = (await report()).summary;

      // Bruto 20,00 − custo 12,00 (10 km × R$ 1,20) − despesa 12,50
      expect(s.grossRevenue, d('20'));
      expect(s.operatingCost, d('12'));
      expect(s.extraExpenses, d('12.50'));
      expect(s.netProfit, d('-4.50'));
      expect(s.isLoss, isTrue);
    });

    test('soma em Decimal, sem erro de arredondamento', () async {
      // Três valores que em double acumulariam resto.
      for (var i = 0; i < 3; i++) {
        await addRide(
          fare: '10.10',
          at: day1.add(Duration(minutes: i)),
        );
      }

      final s = (await report()).summary;

      // A mesma soma em double não fecha: 10.10 três vezes dá
      // 30.299999999999997. É exatamente o erro que o Decimal evita.
      var naive = 0.0;
      for (var i = 0; i < 3; i++) {
        naive += 10.10;
      }
      expect(naive == 30.30, isFalse);

      expect(s.grossRevenue, d('30.30'));
      expect(s.grossRevenue.compareTo(d('30.3')), 0);
    });

    test('calcula receita e lucro por hora em corrida', () async {
      // 24 minutos por corrida; duas corridas = 0,8 h.
      await addRide(fare: '20.00', at: day1);
      await addRide(fare: '20.00', at: day1.add(const Duration(hours: 1)));

      final s = (await report()).summary;

      expect(s.minutesDriven, 48);
      // R$ 40 / 0,8 h = R$ 50,00/h
      expect(s.revenuePerHour, d('50'));
    });

    test('período sem dados devolve relatório vazio', () async {
      final empty = await financial.fetchReport(
        from: DateTime(2026),
        to: DateTime(2026, 2),
      );

      expect(empty.isEmpty, isTrue);
      expect(empty.summary.netProfit, d('0'));
      expect(empty.summary.revenuePerHour, isNull);
      expect(empty.summary.acceptanceRate, isNull);
    });
  });

  group('FinancialRepository · séries', () {
    test('agrupa por dia local e ordena cronologicamente', () async {
      await addRide(fare: '20.00', at: day2);
      await addRide(fare: '30.00', at: day1);
      await addRide(fare: '10.00', at: day1);

      final series = (await report()).dailySeries;

      expect(series, hasLength(2));
      expect(series.first.day.day, 15);
      expect(series.first.grossRevenue, d('40'));
      expect(series.first.rides, 2);
      expect(series.last.day.day, 16);
      expect(series.last.grossRevenue, d('20'));
    });

    test('a série ignora corridas recusadas', () async {
      await addRide(fare: '20.00', at: day1);
      await addRide(fare: '99.00', at: day1, outcome: RideOutcome.rejected);

      final series = (await report()).dailySeries;

      expect(series.single.grossRevenue, d('20'));
      expect(series.single.rides, 1);
    });

    test('agrupa despesas por categoria', () async {
      await expenses.add(
        category: ExpenseCategory.fuel,
        amount: d('150.00'),
        occurredAt: day1,
      );
      await expenses.add(
        category: ExpenseCategory.food,
        amount: d('20.00'),
        occurredAt: day1,
      );
      await expenses.add(
        category: ExpenseCategory.food,
        amount: d('30.00'),
        occurredAt: day2,
      );

      final totals = (await report()).expensesByCategory;

      expect(totals[ExpenseCategory.fuel], d('150'));
      expect(totals[ExpenseCategory.food], d('50'));
      expect(totals[ExpenseCategory.parking], isNull);
    });
  });

  group('FinancialRepository · estatísticas', () {
    test('compara plataformas e ordena por volume', () async {
      await addRide(fare: '20.00', at: day1);
      await addRide(fare: '25.00', at: day1);
      await addRide(
        fare: '30.00',
        at: day1,
        platform: RidePlatform.ninetyNine,
        outcome: RideOutcome.rejected,
      );

      final stats = (await report()).platformStats;

      expect(stats.first.platform, RidePlatform.uber);
      expect(stats.first.offers, 2);
      expect(stats.first.accepted, 2);
      expect(stats.first.acceptanceRate, 1.0);

      final noventaENove = stats.firstWhere(
        (s) => s.platform == RidePlatform.ninetyNine,
      );
      expect(noventaENove.accepted, 0);
      // Recusada não entra no lucro, mas entra na média de R$/km.
      expect(noventaENove.totalProfit, d('0'));
      expect(noventaENove.avgRsPerKm > d('0'), isTrue);
    });

    test('monta o mapa de calor por dia da semana e hora', () async {
      // 15/10/2026 é uma quinta-feira.
      await addRide(fare: '20.00', at: DateTime(2026, 10, 15, 14));
      await addRide(fare: '22.00', at: DateTime(2026, 10, 15, 14, 30));
      await addRide(fare: '18.00', at: DateTime(2026, 10, 15, 20));

      final heat = (await report()).hourStats;

      final tarde = heat.firstWhere((h) => h.hour == 14);
      expect(tarde.offers, 2);
      // weekday 4 = quinta, na convenção 0=domingo do Postgres.
      expect(tarde.weekday, 4);
      expect(heat.firstWhere((h) => h.hour == 20).offers, 1);
    });
  });

  group('CashPeriod', () {
    test('o dia cobre da meia-noite à meia-noite seguinte', () {
      final (from, to) = CashPeriod.day.rangeFrom(DateTime(2026, 10, 17, 15));

      expect(from, DateTime(2026, 10, 17));
      expect(to, DateTime(2026, 10, 18));
    });

    test('a semana cobre sete dias terminando hoje', () {
      final (from, to) = CashPeriod.week.rangeFrom(DateTime(2026, 10, 17, 15));

      expect(from, DateTime(2026, 10, 11));
      expect(to, DateTime(2026, 10, 18));
    });

    test('o mês cobre do primeiro dia ao primeiro do mês seguinte', () {
      final (from, to) = CashPeriod.month.rangeFrom(DateTime(2026, 10, 17));

      expect(from, DateTime(2026, 10));
      expect(to, DateTime(2026, 11));
    });

    test('vira o ano corretamente em dezembro', () {
      final (_, to) = CashPeriod.month.rangeFrom(DateTime(2026, 12, 20));

      expect(to, DateTime(2027));
    });
  });
}
