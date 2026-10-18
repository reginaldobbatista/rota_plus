// `database.g.dart` é uma `part` desta biblioteca e herda estes imports. Os
// tipos usados nas colunas com conversor (Decimal e os enums de domínio)
// precisam estar aqui, senão o código gerado não compila — e o analyzer não
// aponta isso de forma confiável.
import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:rota_plus/data/local/converters/decimal_converter.dart';
import 'package:rota_plus/data/local/daos/config_dao.dart';
import 'package:rota_plus/data/local/daos/expense_dao.dart';
import 'package:rota_plus/data/local/daos/outbox_dao.dart';
import 'package:rota_plus/data/local/daos/ride_dao.dart';
import 'package:rota_plus/data/local/tables.dart';
import 'package:rota_plus/data/local/tables_config.dart';
import 'package:rota_plus/features/expenses/domain/entities/expense.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_evaluation.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_offer.dart';
import 'package:rota_plus/features/vehicle/domain/entities/cost_parameters.dart';

part 'database.g.dart';

/// Banco local do app.
///
/// É a **fonte de verdade de leitura**: toda tela observa o Drift, nunca a
/// rede. O Supabase é camada de sincronização. Isso é o que permite ao app
/// funcionar em estacionamento de subsolo, que é onde o motorista está quando
/// mais precisa dele.
@DriftDatabase(
  tables: [
    LocalRideEvaluations,
    LocalExpenses,
    LocalWorkSessions,
    OutboxEntries,
    LocalVehicles,
    LocalMaintenanceItems,
    LocalFixedCosts,
    LocalWorkProfiles,
  ],
  daos: [RideDao, ExpenseDao, OutboxDao, ConfigDao],
)
class AppDatabase extends _$AppDatabase {
  /// Abre o banco no armazenamento do app.
  AppDatabase() : super(_open());

  /// Cria um banco em memória, para teste.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  /// Guarda `DateTime` como texto ISO-8601 em UTC.
  ///
  /// O padrão do Drift é epoch em segundos, que preserva o instante mas devolve
  /// `DateTime` em horário local — e aí o fuso vaza para dentro do domínio. A
  /// convenção do projeto é UTC no armazenamento e conversão para
  /// `America/Boa_Vista` só na borda de apresentação. Texto ISO também torna o
  /// banco legível em inspeção manual.
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      // v2: veículo, custos e perfis de trabalho deixam de viver em memória.
      if (from < 2) {
        await m.createTable(localVehicles);
        await m.createTable(localMaintenanceItems);
        await m.createTable(localFixedCosts);
        await m.createTable(localWorkProfiles);
      }
    },
    beforeOpen: (details) async {
      // Chave estrangeira não é ativada por padrão no SQLite. Precisa vir
      // antes de qualquer migration que crie tabela com `references`.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  static QueryExecutor _open() => driftDatabase(name: 'rota_plus');
}
