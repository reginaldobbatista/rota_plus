// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_dao.dart';

// ignore_for_file: type=lint
mixin _$ReportDaoMixin on DatabaseAccessor<AppDatabase> {
  $LocalRideEvaluationsTable get localRideEvaluations =>
      attachedDatabase.localRideEvaluations;
  $LocalExpensesTable get localExpenses => attachedDatabase.localExpenses;
  ReportDaoManager get managers => ReportDaoManager(this);
}

class ReportDaoManager {
  final _$ReportDaoMixin _db;
  ReportDaoManager(this._db);
  $$LocalRideEvaluationsTableTableManager get localRideEvaluations =>
      $$LocalRideEvaluationsTableTableManager(
        _db.attachedDatabase,
        _db.localRideEvaluations,
      );
  $$LocalExpensesTableTableManager get localExpenses =>
      $$LocalExpensesTableTableManager(_db.attachedDatabase, _db.localExpenses);
}
