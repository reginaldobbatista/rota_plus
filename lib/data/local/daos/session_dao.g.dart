// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_dao.dart';

// ignore_for_file: type=lint
mixin _$SessionDaoMixin on DatabaseAccessor<AppDatabase> {
  $LocalWorkSessionsTable get localWorkSessions =>
      attachedDatabase.localWorkSessions;
  SessionDaoManager get managers => SessionDaoManager(this);
}

class SessionDaoManager {
  final _$SessionDaoMixin _db;
  SessionDaoManager(this._db);
  $$LocalWorkSessionsTableTableManager get localWorkSessions =>
      $$LocalWorkSessionsTableTableManager(
        _db.attachedDatabase,
        _db.localWorkSessions,
      );
}
