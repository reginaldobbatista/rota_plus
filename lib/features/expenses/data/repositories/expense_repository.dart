import 'package:decimal/decimal.dart';
import 'package:rota_plus/data/local/daos/expense_dao.dart';
import 'package:rota_plus/data/local/daos/outbox_dao.dart';
import 'package:rota_plus/data/local/database.dart';
import 'package:rota_plus/data/local/mappers/expense_mapper.dart';
import 'package:rota_plus/data/local/tables.dart';
import 'package:rota_plus/features/expenses/domain/entities/expense.dart';
import 'package:uuid/uuid.dart';

/// Despesas do motorista, com escrita local-first.
///
/// Mesmo contrato do histórico de corridas: a UI escreve no banco local e o
/// outbox cuida do envio. A diferença é que despesa **muda** depois de criada —
/// o motorista corrige um valor digitado errado — então aqui a resolução de
/// conflito é last-write-wins por `updatedAt`, e a exclusão é lógica.
class ExpenseRepository {
  /// Cria o repositório.
  ExpenseRepository({
    required AppDatabase database,
    required ExpenseDao expenseDao,
    required OutboxDao outboxDao,
    Uuid uuid = const Uuid(),
    DateTime Function() clock = _utcNow,
  }) : _db = database,
       _expenses = expenseDao,
       _outbox = outboxDao,
       _uuid = uuid,
       _clock = clock;

  static DateTime _utcNow() => DateTime.now().toUtc();

  final AppDatabase _db;
  final ExpenseDao _expenses;
  final OutboxDao _outbox;
  final Uuid _uuid;
  final DateTime Function() _clock;

  /// Cria uma despesa e devolve o `clientId` atribuído.
  Future<String> add({
    required ExpenseCategory category,
    required Decimal amount,
    required DateTime occurredAt,
    Decimal? liters,
    Decimal? odometerKm,
    String? description,
    String? workSessionClientId,
  }) async {
    final expense = Expense(
      clientId: _uuid.v4(),
      category: category,
      amount: amount,
      occurredAt: occurredAt,
      liters: liters,
      odometerKm: odometerKm,
      description: description,
      workSessionClientId: workSessionClientId,
    );

    await _save(expense);
    return expense.clientId;
  }

  /// Substitui uma despesa existente, mantendo o `clientId`.
  Future<void> update(Expense expense) => _save(expense);

  Future<void> _save(Expense expense) async {
    final row = expense.toRow(updatedAt: _clock());

    await _db.transaction(() async {
      await _expenses.upsertExpense(row);
      await _outbox.enqueue(
        kind: OutboxKind.expenseUpsert,
        entityClientId: expense.clientId,
      );
    });
  }

  /// Exclui logicamente uma despesa.
  ///
  /// A linha permanece no banco com `deletedAt` preenchido: sem isso, o
  /// servidor nunca saberia que a despesa foi removida — o registro simplesmente
  /// deixaria de ser enviado e ressurgiria na próxima sincronização.
  Future<void> remove(String clientId) async {
    final now = _clock();

    await _db.transaction(() async {
      await _expenses.softDelete(clientId, now);
      await _outbox.enqueue(
        kind: OutboxKind.expenseUpsert,
        entityClientId: clientId,
      );
    });
  }

  /// Observa as despesas de um período, da mais recente para a mais antiga.
  Stream<List<Expense>> watchByPeriod({
    required DateTime from,
    required DateTime to,
  }) => _expenses
      .watchByPeriod(from: from, to: to)
      .map((rows) => rows.map((row) => row.toDomain()).toList());

  /// Observa as despesas de hoje.
  Stream<List<Expense>> watchToday() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    return watchByPeriod(from: start, to: start.add(const Duration(days: 1)));
  }

  /// Observa o total gasto por categoria num período.
  Stream<Map<ExpenseCategory, double>> watchTotalsByCategory({
    required DateTime from,
    required DateTime to,
  }) => _expenses.watchTotalsByCategory(from: from, to: to);

  /// Busca uma despesa pelo `clientId`.
  Future<Expense?> findByClientId(String clientId) async {
    final row = await _expenses.findByClientId(clientId);
    return row?.toDomain();
  }
}
