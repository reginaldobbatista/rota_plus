import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rota_plus/data/local/database.dart';
import 'package:rota_plus/data/local/tables.dart';
import 'package:rota_plus/features/expenses/data/repositories/expense_repository.dart';
import 'package:rota_plus/features/expenses/domain/entities/expense.dart';

import '../support/fixtures.dart';

void main() {
  late AppDatabase db;
  late ExpenseRepository repo;
  var now = DateTime.utc(2026, 10, 17, 12);

  setUp(() {
    now = DateTime.utc(2026, 10, 17, 12);
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = ExpenseRepository(
      database: db,
      expenseDao: db.expenseDao,
      outboxDao: db.outboxDao,
      clock: () => now,
    );
  });

  tearDown(() => db.close());

  Future<String> addFuel({String amount = '150.00', String liters = '25'}) =>
      repo.add(
        category: ExpenseCategory.fuel,
        amount: d(amount),
        liters: d(liters),
        odometerKm: d('84000'),
        occurredAt: DateTime.utc(2026, 10, 17, 10),
        description: 'Posto da BR-174',
      );

  group('ExpenseRepository · escrita local-first', () {
    test('grava a despesa e enfileira o envio', () async {
      final clientId = await addFuel();

      final saved = await repo.findByClientId(clientId);
      final pending = await db.outboxDao.nextBatch();

      expect(saved, isNotNull);
      expect(saved!.category, ExpenseCategory.fuel);
      expect(saved.amount, d('150.00'));
      expect(pending, hasLength(1));
      expect(pending.single.kind, OutboxKind.expenseUpsert);
    });

    test('preserva litros e odômetro do abastecimento', () async {
      final clientId = await addFuel();

      final saved = (await repo.findByClientId(clientId))!;

      expect(saved.liters, d('25'));
      expect(saved.odometerKm, d('84000'));
      // R$ 150 / 25 l = R$ 6,00/l — serve para comparar com o preço
      // configurado no veículo e avisar que o custo/km está defasado.
      expect(saved.pricePerLiter, d('6'));
    });

    test('editar substitui o registro sem criar outro', () async {
      final clientId = await addFuel();
      final original = (await repo.findByClientId(clientId))!;

      now = now.add(const Duration(minutes: 5));
      await repo.update(original.copyWith(amount: d('160.00')));

      final all = await repo
          .watchByPeriod(
            from: DateTime.utc(2026, 10, 17),
            to: DateTime.utc(2026, 10, 18),
          )
          .first;

      expect(all, hasLength(1));
      expect(all.single.amount, d('160.00'));
    });

    test('editar duas vezes offline gera uma única pendência', () async {
      // O motorista corrige o valor três vezes antes de pegar sinal: sobe uma
      // vez, com o estado final.
      final clientId = await addFuel();
      final original = (await repo.findByClientId(clientId))!;

      now = now.add(const Duration(minutes: 1));
      await repo.update(original.copyWith(amount: d('155.00')));
      now = now.add(const Duration(minutes: 1));
      await repo.update(original.copyWith(amount: d('158.00')));

      final pending = await db.outboxDao.nextBatch();

      expect(pending, hasLength(1));
      expect(pending.single.entityClientId, clientId);
    });
  });

  group('ExpenseRepository · exclusão', () {
    test('exclusão é lógica e a linha sobrevive para sincronizar', () async {
      final clientId = await addFuel();

      now = now.add(const Duration(minutes: 2));
      await repo.remove(clientId);

      final visible = await repo
          .watchByPeriod(
            from: DateTime.utc(2026, 10, 17),
            to: DateTime.utc(2026, 10, 18),
          )
          .first;
      final row = await db.expenseDao.findByClientId(clientId);

      // Fora das listas, mas presente no banco com deletedAt.
      expect(visible, isEmpty);
      expect(row, isNotNull);
      expect(row!.deletedAt, isNotNull);
    });

    test('a exclusão vai para a fila de envio', () async {
      final clientId = await addFuel();
      await db.outboxDao.markDone(
        (await db.outboxDao.nextBatch()).map((e) => e.id).toList(),
      );

      await repo.remove(clientId);

      final pending = await db.outboxDao.nextBatch();
      expect(pending, hasLength(1));
      expect(pending.single.entityClientId, clientId);
    });
  });

  group('ExpenseRepository · leitura', () {
    test('agrupa o total por categoria', () async {
      await addFuel();
      await repo.add(
        category: ExpenseCategory.food,
        amount: d('32.50'),
        occurredAt: DateTime.utc(2026, 10, 17, 13),
      );
      await repo.add(
        category: ExpenseCategory.food,
        amount: d('17.50'),
        occurredAt: DateTime.utc(2026, 10, 17, 19),
      );

      final totals = await repo
          .watchTotalsByCategory(
            from: DateTime.utc(2026, 10, 17),
            to: DateTime.utc(2026, 10, 18),
          )
          .first;

      expect(totals[ExpenseCategory.fuel], 150);
      expect(totals[ExpenseCategory.food], 50);
      expect(totals[ExpenseCategory.parking], isNull);
    });

    test('ordena da mais recente para a mais antiga', () async {
      await repo.add(
        category: ExpenseCategory.parking,
        amount: d('10.00'),
        occurredAt: DateTime.utc(2026, 10, 17, 8),
      );
      await repo.add(
        category: ExpenseCategory.carWash,
        amount: d('40.00'),
        occurredAt: DateTime.utc(2026, 10, 17, 18),
      );

      final list = await repo
          .watchByPeriod(
            from: DateTime.utc(2026, 10, 17),
            to: DateTime.utc(2026, 10, 18),
          )
          .first;

      expect(list.first.category, ExpenseCategory.carWash);
      expect(list.last.category, ExpenseCategory.parking);
    });

    test('ignora despesa excluída no total por categoria', () async {
      final clientId = await addFuel();
      await repo.remove(clientId);

      final totals = await repo
          .watchTotalsByCategory(
            from: DateTime.utc(2026, 10, 17),
            to: DateTime.utc(2026, 10, 18),
          )
          .first;

      expect(totals[ExpenseCategory.fuel], isNull);
    });

    test('filtra por período', () async {
      await repo.add(
        category: ExpenseCategory.toll,
        amount: d('12.00'),
        occurredAt: DateTime.utc(2026, 10, 10, 12),
      );
      await repo.add(
        category: ExpenseCategory.toll,
        amount: d('12.00'),
        occurredAt: DateTime.utc(2026, 10, 17, 12),
      );

      final list = await repo
          .watchByPeriod(
            from: DateTime.utc(2026, 10, 15),
            to: DateTime.utc(2026, 10, 18),
          )
          .first;

      expect(list, hasLength(1));
      expect(list.single.occurredAt.day, 17);
    });
  });

  group('Expense · regra de domínio', () {
    test('preço por litro é nulo sem litros informados', () {
      final expense = Expense(
        clientId: 'x',
        category: ExpenseCategory.food,
        amount: d('30.00'),
        occurredAt: DateTime.utc(2026, 10, 17),
      );

      expect(expense.pricePerLiter, isNull);
    });

    test('só abastecimento controla volume', () {
      expect(ExpenseCategory.fuel.tracksFuelVolume, isTrue);
      expect(ExpenseCategory.food.tracksFuelVolume, isFalse);
    });
  });
}
