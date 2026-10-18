// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_dao.dart';

// ignore_for_file: type=lint
mixin _$ExpenseDaoMixin on DatabaseAccessor<AppDatabase> {
  $LocalExpensesTable get localExpenses => attachedDatabase.localExpenses;
  ExpenseDaoManager get managers => ExpenseDaoManager(this);
}

class ExpenseDaoManager {
  final _$ExpenseDaoMixin _db;
  ExpenseDaoManager(this._db);
  $$LocalExpensesTableTableManager get localExpenses =>
      $$LocalExpensesTableTableManager(_db.attachedDatabase, _db.localExpenses);
}
