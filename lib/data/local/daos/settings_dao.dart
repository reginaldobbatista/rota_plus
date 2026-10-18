import 'package:drift/drift.dart';
import 'package:rota_plus/data/local/database.dart';
import 'package:rota_plus/data/local/tables_config.dart';

part 'settings_dao.g.dart';

/// Preferências do app, guardadas como pares chave-valor.
///
/// Uma tabela genérica em vez de uma coluna por preferência: estas são
/// configurações de aparelho, não de domínio, e cada nova delas não deveria
/// exigir migração de schema.
@DriftAccessor(tables: [LocalSettings])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  /// Cria o DAO.
  SettingsDao(super.db);

  /// Observa todas as preferências.
  Stream<Map<String, String>> watchAll() {
    return select(
      localSettings,
    ).watch().map((rows) => {for (final row in rows) row.key: row.value});
  }

  /// Lê uma preferência.
  Future<String?> read(String key) async {
    final row = await (select(
      localSettings,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  /// Grava uma preferência.
  Future<void> write(String key, String value) => into(
    localSettings,
  ).insertOnConflictUpdate(LocalSetting(key: key, value: value));

  /// Remove uma preferência.
  Future<void> remove(String key) =>
      (delete(localSettings)..where((t) => t.key.equals(key))).go();
}
