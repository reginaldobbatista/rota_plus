import 'package:rota_plus/data/local/database.dart';
import 'package:rota_plus/features/expenses/domain/entities/expense.dart';

/// Conversão da despesa de domínio para a linha do banco local.
extension ExpenseToRow on Expense {
  /// Monta a linha a persistir.
  LocalExpense toRow({required DateTime updatedAt, DateTime? deletedAt}) =>
      LocalExpense(
        clientId: clientId,
        category: category,
        amount: amount,
        liters: liters,
        odometerKm: odometerKm,
        description: description,
        occurredAt: occurredAt,
        updatedAt: updatedAt,
        deletedAt: deletedAt,
        workSessionClientId: workSessionClientId,
      );
}

/// Conversão da linha do banco local de volta para o domínio.
extension RowToExpense on LocalExpense {
  /// Reconstrói a despesa a partir da linha persistida.
  Expense toDomain() => Expense(
    clientId: clientId,
    category: category,
    amount: amount,
    liters: liters,
    odometerKm: odometerKm,
    description: description,
    occurredAt: occurredAt,
    workSessionClientId: workSessionClientId,
  );

  /// Monta o payload para `rpc_sync_expenses`.
  ///
  /// `updated_at` vai no payload porque a resolução de conflito de despesa é
  /// last-write-wins: o servidor compara com o que já tem e mantém o mais
  /// recente. Corrida não precisa disso — é insert-only.
  Map<String, Object?> toSyncPayload() => <String, Object?>{
    'client_id': clientId,
    'category': _categoryToSql(category),
    'amount': amount.toString(),
    'liters': liters?.toString(),
    'odometer_km': odometerKm?.toString(),
    'description': description,
    'occurred_at': occurredAt.toUtc().toIso8601String(),
    'updated_at': updatedAt.toUtc().toIso8601String(),
    'deleted_at': deletedAt?.toUtc().toIso8601String(),
    'work_session_id': workSessionClientId,
  };
}

/// Nomes do enum `public.expense_category` no Postgres.
///
/// O Dart usa `carWash` e o SQL usa `car_wash`: o mapa explícito evita
/// depender de conversão automática de case, que falharia silenciosamente.
String _categoryToSql(ExpenseCategory category) => switch (category) {
  ExpenseCategory.fuel => 'fuel',
  ExpenseCategory.food => 'food',
  ExpenseCategory.carWash => 'car_wash',
  ExpenseCategory.parking => 'parking',
  ExpenseCategory.maintenance => 'maintenance',
  ExpenseCategory.toll => 'toll',
  ExpenseCategory.fine => 'fine',
  ExpenseCategory.rent => 'rent',
  ExpenseCategory.other => 'other',
};
