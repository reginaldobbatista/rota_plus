// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride_dao.dart';

// ignore_for_file: type=lint
mixin _$RideDaoMixin on DatabaseAccessor<AppDatabase> {
  $LocalRideEvaluationsTable get localRideEvaluations =>
      attachedDatabase.localRideEvaluations;
  RideDaoManager get managers => RideDaoManager(this);
}

class RideDaoManager {
  final _$RideDaoMixin _db;
  RideDaoManager(this._db);
  $$LocalRideEvaluationsTableTableManager get localRideEvaluations =>
      $$LocalRideEvaluationsTableTableManager(
        _db.attachedDatabase,
        _db.localRideEvaluations,
      );
}
