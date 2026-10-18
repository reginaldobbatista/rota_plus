import 'package:drift/drift.dart';
import 'package:rota_plus/data/local/database.dart';
import 'package:rota_plus/data/local/tables.dart';
import 'package:rota_plus/features/expenses/domain/entities/expense.dart';

part 'expense_dao.g.dart';

/// Acesso às despesas no banco local.
@DriftAccessor(tables: [LocalExpenses])
class ExpenseDao extends DatabaseAccessor<AppDatabase> with _$ExpenseDaoMixin {
  /// Cria o DAO.
  ExpenseDao(super.db);

  /// Insere ou atualiza uma despesa pelo `clientId`.
  Future<void> upsertExpense(LocalExpense row) =>
      into(localExpenses).insertOnConflictUpdate(row);

  /// Observa as despesas de um período, ignorando as excluídas.
  Stream<List<LocalExpense>> watchByPeriod({
    required DateTime from,
    required DateTime to,
  }) {
    final query = select(localExpenses)
      ..where((t) => t.deletedAt.isNull())
      ..where((t) => t.occurredAt.isBiggerOrEqualValue(from))
      ..where((t) => t.occurredAt.isSmallerThanValue(to))
      ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)]);
    return query.watch();
  }

  /// Observa o total gasto num período, por categoria.
  Stream<Map<ExpenseCategory, double>> watchTotalsByCategory({
    required DateTime from,
    required DateTime to,
  }) {
    final total = localExpenses.amount.cast<double>().sum();
    final query = selectOnly(localExpenses)
      ..addColumns([localExpenses.category, total])
      ..where(
        localExpenses.deletedAt.isNull() &
            localExpenses.occurredAt.isBiggerOrEqualValue(from) &
            localExpenses.occurredAt.isSmallerThanValue(to),
      )
      ..groupBy([localExpenses.category]);

    return query.watch().map((rows) {
      return <ExpenseCategory, double>{
        for (final row in rows)
          // `readWithConverter` em vez de `read`: a coluna é TEXT no banco e
          // enum em Dart, e é o conversor que faz a ponte.
          row.readWithConverter(localExpenses.category)!: row.read(total) ?? 0,
      };
    });
  }

  /// Marca uma despesa como excluída.
  ///
  /// Exclusão lógica, não física: a linha precisa sobreviver até a
  /// sincronização propagar a remoção ao servidor.
  Future<void> softDelete(String clientId, DateTime when) =>
      (update(localExpenses)..where((t) => t.clientId.equals(clientId))).write(
        LocalExpensesCompanion(deletedAt: Value(when), updatedAt: Value(when)),
      );

  /// Busca uma despesa pelo `clientId`.
  Future<LocalExpense?> findByClientId(String clientId) => (select(
    localExpenses,
  )..where((t) => t.clientId.equals(clientId))).getSingleOrNull();

  /// Lê várias despesas de uma vez, para montar o lote de sincronização.
  Future<List<LocalExpense>> findManyByClientId(List<String> clientIds) =>
      (select(localExpenses)..where((t) => t.clientId.isIn(clientIds))).get();
}
