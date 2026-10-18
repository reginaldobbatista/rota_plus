import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rota_plus/data/local/database.dart';
import 'package:rota_plus/data/local/tables.dart';
import 'package:rota_plus/features/financial/data/repositories/financial_repository.dart';
import 'package:rota_plus/features/financial/data/repositories/work_session_repository.dart';
import 'package:rota_plus/features/history/data/repositories/ride_history_repository.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_evaluation.dart';

import '../support/fixtures.dart';

void main() {
  late AppDatabase db;
  late WorkSessionRepository sessions;
  var now = DateTime.utc(2026, 10, 17, 8);

  setUp(() {
    now = DateTime.utc(2026, 10, 17, 8);
    db = AppDatabase.forTesting(NativeDatabase.memory());
    sessions = WorkSessionRepository(
      database: db,
      sessionDao: db.sessionDao,
      outboxDao: db.outboxDao,
      clock: () => now,
    );
  });

  tearDown(() => db.close());

  group('WorkSessionRepository', () {
    test('iniciar abre uma sessão e enfileira o envio', () async {
      final id = await sessions.start();

      final open = await sessions.watchOpen().first;
      final pending = await db.outboxDao.nextBatch();

      expect(open, isNotNull);
      expect(open!.clientId, id);
      expect(open.isOpen, isTrue);
      expect(pending.single.kind, OutboxKind.workSessionUpsert);
    });

    test('iniciar duas vezes não cria duas sessões', () async {
      // Dois expedientes simultâneos fariam a contagem de horas dobrar.
      final first = await sessions.start();
      now = now.add(const Duration(minutes: 5));
      final second = await sessions.start();

      expect(second, first);
    });

    test('encerrar fecha a sessão aberta', () async {
      await sessions.start();
      now = now.add(const Duration(hours: 6));
      await sessions.stop();

      expect(await sessions.watchOpen().first, isNull);
    });

    test('encerrar sem sessão aberta não falha', () async {
      await expectLater(sessions.stop(), completes);
    });

    test('conta os minutos de uma sessão encerrada', () async {
      await sessions.start();
      now = now.add(const Duration(hours: 6));
      await sessions.stop();

      final minutes = await sessions.minutesWorked(
        from: DateTime.utc(2026, 10, 17),
        to: DateTime.utc(2026, 10, 18),
      );

      expect(minutes, 360);
    });

    test('conta a sessão ainda aberta até agora', () async {
      await sessions.start();
      now = now.add(const Duration(hours: 2));

      final minutes = await sessions.minutesWorked(
        from: DateTime.utc(2026, 10, 17),
        to: DateTime.utc(2026, 10, 18),
      );

      expect(minutes, 120);
    });

    test('recorta a sessão que atravessa a meia-noite', () async {
      // Entra às 22h, sai às 2h: quatro horas divididas entre dois dias.
      now = DateTime.utc(2026, 10, 17, 22);
      await sessions.start();
      now = DateTime.utc(2026, 10, 18, 2);
      await sessions.stop();

      final dia17 = await sessions.minutesWorked(
        from: DateTime.utc(2026, 10, 17),
        to: DateTime.utc(2026, 10, 18),
      );
      final dia18 = await sessions.minutesWorked(
        from: DateTime.utc(2026, 10, 18),
        to: DateTime.utc(2026, 10, 19),
      );

      expect(dia17, 120);
      expect(dia18, 120);
    });

    test('ignora sessão fora do período', () async {
      await sessions.start();
      now = now.add(const Duration(hours: 4));
      await sessions.stop();

      final outroDia = await sessions.minutesWorked(
        from: DateTime.utc(2026, 10, 20),
        to: DateTime.utc(2026, 10, 21),
      );

      expect(outroDia, 0);
    });
  });

  group('Fechamento com expediente', () {
    test('o R\$/hora de expediente é menor que o de corrida', () async {
      final rides = RideHistoryRepository(
        database: db,
        rideDao: db.rideDao,
        outboxDao: db.outboxDao,
      );
      final financial = FinancialRepository(dao: db.reportDao);

      // Seis horas de expediente para apenas 24 minutos de corrida.
      now = DateTime.utc(2026, 10, 17, 8);
      await sessions.start();
      await rides.record(
        testEvaluation(capturedAt: DateTime(2026, 10, 17, 9)),
        outcome: RideOutcome.accepted,
      );
      now = now.add(const Duration(hours: 6));
      await sessions.stop();

      final report = await financial.fetchReport(
        from: DateTime(2026, 10, 17),
        to: DateTime(2026, 10, 18),
      );
      final s = report.summary;

      expect(s.hasWorkSessions, isTrue);
      expect(s.minutesDriven, 24);

      // R$ 20 em 0,4 h de corrida = R$ 50/h; em ~6 h de expediente, ~R$ 3/h.
      // É esta diferença que o motorista precisa enxergar.
      expect(s.revenuePerHour! > s.revenuePerWorkedHour!, isTrue);
      expect(s.occupancyRate! < 0.1, isTrue);
    });

    test('sem expediente registrado, a jornada fica indisponível', () async {
      final financial = FinancialRepository(dao: db.reportDao);

      final report = await financial.fetchReport(
        from: DateTime(2026, 10, 17),
        to: DateTime(2026, 10, 18),
      );

      expect(report.summary.hasWorkSessions, isFalse);
      expect(report.summary.revenuePerWorkedHour, isNull);
      expect(report.summary.occupancyRate, isNull);
    });
  });
}
