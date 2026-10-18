// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_dao.dart';

// ignore_for_file: type=lint
mixin _$ConfigDaoMixin on DatabaseAccessor<AppDatabase> {
  $LocalVehiclesTable get localVehicles => attachedDatabase.localVehicles;
  $LocalMaintenanceItemsTable get localMaintenanceItems =>
      attachedDatabase.localMaintenanceItems;
  $LocalFixedCostsTable get localFixedCosts => attachedDatabase.localFixedCosts;
  $LocalWorkProfilesTable get localWorkProfiles =>
      attachedDatabase.localWorkProfiles;
  ConfigDaoManager get managers => ConfigDaoManager(this);
}

class ConfigDaoManager {
  final _$ConfigDaoMixin _db;
  ConfigDaoManager(this._db);
  $$LocalVehiclesTableTableManager get localVehicles =>
      $$LocalVehiclesTableTableManager(_db.attachedDatabase, _db.localVehicles);
  $$LocalMaintenanceItemsTableTableManager get localMaintenanceItems =>
      $$LocalMaintenanceItemsTableTableManager(
        _db.attachedDatabase,
        _db.localMaintenanceItems,
      );
  $$LocalFixedCostsTableTableManager get localFixedCosts =>
      $$LocalFixedCostsTableTableManager(
        _db.attachedDatabase,
        _db.localFixedCosts,
      );
  $$LocalWorkProfilesTableTableManager get localWorkProfiles =>
      $$LocalWorkProfilesTableTableManager(
        _db.attachedDatabase,
        _db.localWorkProfiles,
      );
}
