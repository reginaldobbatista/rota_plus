import 'package:decimal/decimal.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rota_plus/core/sync/sync_engine.dart';
import 'package:rota_plus/data/local/database.dart';
import 'package:rota_plus/data/local/tables.dart';
import 'package:rota_plus/features/expenses/data/repositories/expense_repository.dart';
import 'package:rota_plus/features/expenses/domain/entities/expense.dart';
import 'package:rota_plus/features/financial/data/repositories/work_session_repository.dart';
import 'package:rota_plus/features/history/data/repositories/ride_history_repository.dart';

import '../support/fixtures.dart';

/// Cliente de sincronização controlável, para exercitar a fila sem rede.
class FakeSyncClient implements RemoteSyncClient {
  FakeSyncClient({this.failWith, this.failExpensesWith});

  /// Erro a lançar no envio de corridas.
  final Exception? failWith;

  /// Erro a lançar no envio de despesas.
  final Exception? failExpensesWith;

  /// Chamadas de corrida, uma entrada por requisição.
  final List<List<Map<String, Object?>>> calls = [];

  /// Chamadas de despesa, uma entrada por requisição.
  final List<List<Map<String, Object?>>> expenseCalls = [];

  /// Chamadas de sessão de trabalho.
  final List<List<Map<String, Object?>>> sessionCalls = [];

  @override
  Future<void> pushRides(List<Map<String, Object?>> payload) async {
    calls.add(payload);
    final failure = failWith;
    if (failure != null) throw failure;
  }

  @override
  Future<void> pushExpenses(List<Map<String, Object?>> payload) async {
    expenseCalls.add(payload);
    final failure = failExpensesWith;
    if (failure != null) throw failure;
  }

  @override
  Future<void> pushWorkSessions(List<Map<String, Object?>> payload) async {
    sessionCalls.add(payload);
  }
}

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

  SyncEngine engineWith({
    RemoteSyncClient? client,
    bool online = true,
    int batchSize = 100,
  }) => SyncEngine(
    outboxDao: db.outboxDao,
    rideDao: db.rideDao,
    expenseDao: db.expenseDao,
    sessionDao: db.sessionDao,
    client: client,
    isOnline: () => online,
    batchSize: batchSize,
  );

  group('SyncEngine · caminho feliz', () {
    test('envia o lote e limpa a fila', () async {
      await repo.record(testEvaluation());
      await repo.record(testEvaluation(fare: '30.00'));
      final client = FakeSyncClient();

      final result = await engineWith(client: client).flush();

      expect(result.sent, 2);
      expect(result.failed, 0);
      expect(await db.outboxDao.nextBatch(), isEmpty);
    });

    test('envia tudo numa única chamada, não uma por corrida', () async {
      for (var i = 0; i < 5; i++) {
        await repo.record(testEvaluation(fare: '2$i.00'));
      }
      final client = FakeSyncClient();

      await engineWith(client: client).flush();

      // Cinco corridas, uma requisição: é o que economiza bateria e rádio.
      expect(client.calls, hasLength(1));
      expect(client.calls.single, hasLength(5));
    });

    test('monta o payload com as chaves que a RPC espera', () async {
      await repo.record(testEvaluation());
      final client = FakeSyncClient();

      await engineWith(client: client).flush();
      final payload = client.calls.single.single;

      expect(payload['client_id'], isNotNull);
      expect(payload['platform'], 'uber');
      expect(payload['verdict'], 'accept');
      // Decimal normaliza a escala ('20.00' vira '20'), e para o `numeric` do
      // Postgres é o mesmo valor — então a asserção é de valor, não de forma.
      expect(Decimal.parse(payload['fare']! as String), d('20.00'));
      expect(Decimal.parse(payload['rs_per_km']! as String), d('2'));
      // Vai como string, não como double: o Postgres recebe em numeric sem
      // passar por ponto flutuante no caminho.
      expect(payload['operating_cost'], isA<String>());
      expect(payload['occurred_at'], contains('Z'));
    });

    test('nada a fazer quando a fila está vazia', () async {
      final client = FakeSyncClient();

      final result = await engineWith(client: client).flush();

      expect(result.didWork, isFalse);
      expect(client.calls, isEmpty);
    });
  });

  group('SyncEngine · falha e resiliência', () {
    test('mantém a fila e conta a tentativa quando o envio falha', () async {
      await repo.record(testEvaluation());
      final client = FakeSyncClient(failWith: Exception('502 bad gateway'));

      final result = await engineWith(client: client).flush();

      expect(result.sent, 0);
      expect(result.failed, 1);
      expect(result.error, contains('502'));

      final pending = await db.outboxDao.nextBatch();
      expect(pending, hasLength(1));
      expect(pending.single.attempts, 1);
      expect(pending.single.lastError, contains('502'));
    });

    test('reenvia depois de uma falha e a fila esvazia', () async {
      await repo.record(testEvaluation());

      await engineWith(
        client: FakeSyncClient(failWith: Exception('timeout')),
      ).flush();
      final retry = await engineWith(client: FakeSyncClient()).flush();

      expect(retry.sent, 1);
      expect(await db.outboxDao.nextBatch(), isEmpty);
    });

    test('offline não tenta e preserva a fila', () async {
      await repo.record(testEvaluation());
      final client = FakeSyncClient();

      final result = await engineWith(client: client, online: false).flush();

      expect(result.skippedOffline, isTrue);
      expect(client.calls, isEmpty);
      expect(await db.outboxDao.nextBatch(), hasLength(1));
    });

    test('sem backend configurado não tenta e preserva a fila', () async {
      await repo.record(testEvaluation());

      final result = await engineWith().flush();

      expect(result.skippedOffline, isTrue);
      expect(await db.outboxDao.nextBatch(), hasLength(1));
    });

    test('descarta pendência cujo registro não existe mais', () async {
      // Sem isso a fila entraria em loop infinito de falhas.
      await db.outboxDao.enqueue(
        kind: OutboxKind.rideInsert,
        entityClientId: 'fantasma',
      );
      final client = FakeSyncClient();

      final result = await engineWith(client: client).flush();

      expect(client.calls, isEmpty);
      expect(result.didWork, isFalse);
      expect(await db.outboxDao.nextBatch(), isEmpty);
    });

    test('respeita o tamanho do lote', () async {
      for (var i = 0; i < 5; i++) {
        await repo.record(testEvaluation(fare: '2$i.00'));
      }
      final client = FakeSyncClient();

      final result = await engineWith(client: client, batchSize: 2).flush();

      expect(result.sent, 2);
      expect(await db.outboxDao.nextBatch(), hasLength(3));
    });
  });

  group('SyncEngine · despesas', () {
    late ExpenseRepository expenses;

    setUp(() {
      expenses = ExpenseRepository(
        database: db,
        expenseDao: db.expenseDao,
        outboxDao: db.outboxDao,
      );
    });

    Future<String> addExpense() => expenses.add(
      category: ExpenseCategory.fuel,
      amount: d('150.00'),
      liters: d('25'),
      occurredAt: DateTime.utc(2026, 10, 17, 10),
    );

    test('envia despesas na fila própria', () async {
      await addExpense();
      final client = FakeSyncClient();

      final result = await engineWith(client: client).flush();

      expect(result.sent, 1);
      expect(client.expenseCalls, hasLength(1));
      expect(await db.outboxDao.nextBatch(), isEmpty);
    });

    test('monta o payload com as chaves que a RPC espera', () async {
      await addExpense();
      final client = FakeSyncClient();

      await engineWith(client: client).flush();
      final payload = client.expenseCalls.single.single;

      expect(payload['client_id'], isNotNull);
      expect(payload['category'], 'fuel');
      expect(Decimal.parse(payload['amount']! as String), d('150.00'));
      expect(payload['liters'], isA<String>());
      // `updated_at` é o que o servidor usa para o last-write-wins.
      expect(payload['updated_at'], isNotNull);
      expect(payload['deleted_at'], isNull);
    });

    test('propaga a exclusão como deleted_at preenchido', () async {
      final clientId = await addExpense();
      await expenses.remove(clientId);
      final client = FakeSyncClient();

      await engineWith(client: client).flush();
      final payload = client.expenseCalls.single.single;

      // A exclusão precisa chegar como dado, não como ausência: sem isso o
      // servidor nunca saberia que a despesa foi removida.
      expect(payload['deleted_at'], isNotNull);
    });

    test('corridas sobem mesmo quando o lote de despesas falha', () async {
      await repo.record(testEvaluation());
      await addExpense();
      final client = FakeSyncClient(
        failExpensesWith: Exception('503 service unavailable'),
      );

      final result = await engineWith(client: client).flush();

      expect(result.sent, 1);
      expect(result.failed, 1);
      expect(client.calls, hasLength(1));

      // Só a despesa continua na fila.
      final pending = await db.outboxDao.nextBatch();
      expect(pending, hasLength(1));
      expect(pending.single.kind, OutboxKind.expenseUpsert);
    });

    test('drena corridas e despesas na mesma rodada', () async {
      await repo.record(testEvaluation());
      await addExpense();
      final client = FakeSyncClient();

      final result = await engineWith(client: client).flush();

      expect(result.sent, 2);
      expect(client.calls, hasLength(1));
      expect(client.expenseCalls, hasLength(1));
      expect(await db.outboxDao.nextBatch(), isEmpty);
    });
  });

  group('SyncEngine · sessões de trabalho', () {
    test('drena a fila de expediente', () async {
      // Antes desta fila existir, as sessões eram enfileiradas e nunca
      // enviadas: o outbox crescia para sempre no aparelho.
      final sessions = WorkSessionRepository(
        database: db,
        sessionDao: db.sessionDao,
        outboxDao: db.outboxDao,
      );
      await sessions.start();
      final client = FakeSyncClient();

      final result = await engineWith(client: client).flush();

      expect(result.sent, 1);
      expect(client.sessionCalls, hasLength(1));
      expect(await db.outboxDao.nextBatch(), isEmpty);
    });

    test('sessão aberta sobe com ended_at nulo', () async {
      // Esperar o encerramento perderia a sessão inteira se o aparelho fosse
      // trocado no meio do expediente.
      final sessions = WorkSessionRepository(
        database: db,
        sessionDao: db.sessionDao,
        outboxDao: db.outboxDao,
      );
      await sessions.start();
      final client = FakeSyncClient();

      await engineWith(client: client).flush();
      final payload = client.sessionCalls.single.single;

      expect(payload['client_id'], isNotNull);
      expect(payload['started_at'], isNotNull);
      expect(payload['ended_at'], isNull);
    });

    test('as três filas drenam na mesma rodada', () async {
      final sessions = WorkSessionRepository(
        database: db,
        sessionDao: db.sessionDao,
        outboxDao: db.outboxDao,
      );
      final expenses = ExpenseRepository(
        database: db,
        expenseDao: db.expenseDao,
        outboxDao: db.outboxDao,
      );

      await repo.record(testEvaluation());
      await expenses.add(
        category: ExpenseCategory.fuel,
        amount: d('150.00'),
        occurredAt: DateTime.utc(2026, 10, 17, 10),
      );
      await sessions.start();
      final client = FakeSyncClient();

      final result = await engineWith(client: client).flush();

      expect(result.sent, 3);
      expect(await db.outboxDao.nextBatch(), isEmpty);
    });
  });

  group('SyncEngine · contador de pendências', () {
    test('reflete o que falta sincronizar', () async {
      final engine = engineWith(client: FakeSyncClient());

      expect(await engine.watchPendingCount().first, 0);

      await repo.record(testEvaluation());
      expect(await engine.watchPendingCount().first, 1);

      await engine.flush();
      expect(await engine.watchPendingCount().first, 0);
    });
  });
}
