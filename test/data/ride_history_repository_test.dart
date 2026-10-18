import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rota_plus/data/local/database.dart';
import 'package:rota_plus/data/local/tables.dart';
import 'package:rota_plus/features/history/data/repositories/ride_history_repository.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_evaluation.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_offer.dart';

import '../support/fixtures.dart';

void main() {
  late AppDatabase db;
  late RideHistoryRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = RideHistoryRepository(
      database: db,
      rideDao: db.rideDao,
      outboxDao: db.outboxDao,
    );
  });

  tearDown(() => db.close());

  group('RideHistoryRepository · escrita local-first', () {
    test('grava a corrida e enfileira o envio na mesma transação', () async {
      final clientId = await repo.record(testEvaluation());

      final rides = await db.rideDao.findManyByClientId([clientId]);
      final pending = await db.outboxDao.nextBatch();

      expect(rides, hasLength(1));
      expect(pending, hasLength(1));
      expect(pending.single.kind, OutboxKind.rideInsert);
      expect(pending.single.entityClientId, clientId);
    });

    test('preserva o Decimal sem perda de precisão', () async {
      // 33,33 / 10 km = 3,333 — um valor que em double viraria 3.3329999...
      final clientId = await repo.record(testEvaluation(fare: '33.33'));
      final row = (await db.rideDao.findByClientId(clientId))!;

      expect(row.fare.toString(), '33.33');
      expect(row.rsPerKm.toString(), '3.333');
    });

    test('reinserir o mesmo clientId não duplica a linha', () async {
      // Cenário real: o AccessibilityService dispara o evento duas vezes
      // durante a animação do card da Uber.
      final evaluation = testEvaluation();
      final first = await repo.record(evaluation);
      final second = await repo.record(evaluation.copyWith(clientId: first));

      final all = await db.rideDao.findManyByClientId([first, second]);

      expect(second, first);
      expect(all, hasLength(1));
    });

    test('reenfileirar a mesma corrida não duplica a pendência', () async {
      final clientId = await repo.record(testEvaluation());
      await repo.setOutcome(clientId, RideOutcome.accepted);

      final pending = await db.outboxDao.nextBatch();

      expect(pending, hasLength(1));
      expect(pending.single.attempts, 0);
    });

    test('registra o desfecho escolhido pelo motorista', () async {
      final clientId = await repo.record(testEvaluation());
      await repo.setOutcome(clientId, RideOutcome.accepted);

      final row = (await db.rideDao.findByClientId(clientId))!;

      expect(row.outcome, RideOutcome.accepted);
      // O veredicto do app não muda com o desfecho: um é recomendação, o
      // outro é o que aconteceu.
      expect(row.verdict, RideVerdict.accept);
    });
  });

  group('RideHistoryRepository · leitura', () {
    test('observa as corridas da mais nova para a mais antiga', () async {
      await repo.record(
        testEvaluation(capturedAt: DateTime.utc(2026, 10, 17, 8)),
      );
      await repo.record(
        testEvaluation(capturedAt: DateTime.utc(2026, 10, 17, 20)),
      );

      final rides = await repo.watchRecent().first;

      expect(rides, hasLength(2));
      expect(rides.first.offer.capturedAt.hour, 20);
      expect(rides.last.offer.capturedAt.hour, 8);
    });

    test('reconstrói a avaliação a partir da linha persistida', () async {
      await repo.record(testEvaluation());

      final ride = (await repo.watchRecent().first).single;

      expect(ride.offer.platform, RidePlatform.uber);
      expect(ride.offer.pickupRegion, 'Centro');
      expect(ride.rsPerKm, d('2'));
      expect(ride.rsPerHour, d('50'));
      expect(ride.realProfit, d('8'));
      expect(ride.verdict, RideVerdict.accept);
    });

    test('filtra por período', () async {
      await repo.record(
        testEvaluation(capturedAt: DateTime.utc(2026, 10, 10, 12)),
      );
      await repo.record(
        testEvaluation(capturedAt: DateTime.utc(2026, 10, 17, 12)),
      );

      final rides = await repo
          .watchByPeriod(
            from: DateTime.utc(2026, 10, 15),
            to: DateTime.utc(2026, 10, 18),
          )
          .first;

      expect(rides, hasLength(1));
      expect(rides.single.offer.capturedAt.day, 17);
    });
  });

  group('RideHistoryRepository · resumo do dia', () {
    test('soma só as corridas aceitas', () async {
      final today = DateTime.now();
      final accepted = await repo.record(
        testEvaluation(capturedAt: today),
        outcome: RideOutcome.accepted,
      );
      await repo.record(
        testEvaluation(fare: '30.00', capturedAt: today),
        outcome: RideOutcome.rejected,
      );

      final totals = await repo.watchToday().first;

      expect(accepted, isNotEmpty);
      expect(totals.evaluated, 2);
      expect(totals.accepted, 1);
      expect(totals.rejected, 1);
      // Só a aceita entra no faturamento: R$ 20,00 com lucro de R$ 8,00.
      expect(totals.grossRevenue, 20);
      expect(totals.netProfit, 8);
      expect(totals.acceptanceRate, 0.5);
    });

    test('devolve resumo vazio quando não há corridas', () async {
      final totals = await repo.watchToday().first;

      expect(totals.evaluated, 0);
      expect(totals.acceptanceRate, isNull);
    });
  });
}
