import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota_plus/core/config/env.dart';
import 'package:rota_plus/core/sync/sync_engine.dart';
import 'package:rota_plus/data/local/database.dart';
import 'package:rota_plus/data/remote/supabase_sync_client.dart';
import 'package:rota_plus/features/expenses/data/repositories/expense_repository.dart';
import 'package:rota_plus/features/expenses/domain/entities/expense.dart';
import 'package:rota_plus/features/goals/domain/entities/work_goals.dart';
import 'package:rota_plus/features/history/data/repositories/ride_history_repository.dart';
import 'package:rota_plus/features/history/domain/entities/daily_totals.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_evaluation.dart';
import 'package:rota_plus/features/semaphore/domain/usecases/evaluate_ride.dart';
import 'package:rota_plus/features/vehicle/domain/entities/cost_parameters.dart';
import 'package:rota_plus/features/vehicle/domain/usecases/calculate_cost_per_km.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Parâmetros de custo do veículo ativo.
///
/// Hoje começa com um padrão plausível e vive em memória. Quando a camada
/// Drift entrar, este notifier passa a ler e escrever no banco local — a
/// assinatura que a UI consome não muda.
final class CostParametersNotifier extends Notifier<CostParameters> {
  @override
  CostParameters build() => CostParameters(
    fuelType: FuelType.flex,
    fuelPrice: Decimal.parse('6.09'),
    consumption: Decimal.parse('11'),
    depreciationPerKm: Decimal.parse('0.12'),
    genericMaintenancePerKm: Decimal.parse('0.08'),
    workDaysPerMonth: 24,
    kmPerDay: Decimal.parse('180'),
    fixedCosts: [
      FixedCost.annual(label: 'IPVA', amount: Decimal.parse('1200')),
      FixedCost.annual(label: 'Seguro', amount: Decimal.parse('2800')),
    ],
  );

  /// Substitui os parâmetros de custo.
  void update(CostParameters params) => state = params;
}

/// Parâmetros de custo do veículo ativo.
final costParametersProvider =
    NotifierProvider<CostParametersNotifier, CostParameters>(
      CostParametersNotifier.new,
    );

/// Metas do perfil de trabalho ativo.
final class WorkGoalsNotifier extends Notifier<WorkGoals> {
  @override
  WorkGoals build() => WorkGoals(
    minRsPerKm: Decimal.parse('2.00'),
    minRsPerHour: Decimal.parse('35.00'),
    maxPickupKm: Decimal.parse('5'),
  );

  /// Substitui as metas.
  void update(WorkGoals goals) => state = goals;
}

/// Metas do perfil de trabalho ativo.
final workGoalsProvider = NotifierProvider<WorkGoalsNotifier, WorkGoals>(
  WorkGoalsNotifier.new,
);

/// Composição do custo por km do veículo ativo.
///
/// Derivado dos parâmetros: recalcula só quando eles mudam. O overlay lê o
/// valor já pronto, nunca recomputa no caminho crítico.
final costBreakdownProvider = Provider<CostBreakdown?>((ref) {
  const useCase = CalculateCostPerKm();
  return useCase(ref.watch(costParametersProvider));
});

/// Custo por quilômetro do veículo ativo. Zero quando o cadastro está incompleto.
final costPerKmProvider = Provider<Decimal>((ref) {
  return ref.watch(costBreakdownProvider)?.totalPerKm ?? Decimal.zero;
});

/// Avaliador de corridas configurado com o custo e as metas ativos.
final evaluateRideProvider = Provider<EvaluateRide>((ref) {
  return EvaluateRide(
    costPerKm: ref.watch(costPerKmProvider),
    goals: ref.watch(workGoalsProvider),
  );
});

// ---------------------------------------------------------------------------
// Camada de dados
// ---------------------------------------------------------------------------

/// Banco local. É a fonte de verdade de leitura do app.
///
/// Sobrescrito nos testes por `AppDatabase.forTesting` com SQLite em memória.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Histórico de corridas.
final rideHistoryRepositoryProvider = Provider<RideHistoryRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return RideHistoryRepository(
    database: db,
    rideDao: db.rideDao,
    outboxDao: db.outboxDao,
  );
});

/// Despesas do motorista.
final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ExpenseRepository(
    database: db,
    expenseDao: db.expenseDao,
    outboxDao: db.outboxDao,
  );
});

/// Cliente de sincronização. Nulo quando não há backend configurado.
final remoteSyncClientProvider = Provider<RemoteSyncClient?>((ref) {
  if (!Env.hasSupabase) return null;
  return SupabaseSyncClient(Supabase.instance.client);
});

/// Indica se há conexão utilizável.
///
/// Placeholder honesto: hoje responde pela presença de backend. Quando o
/// `ConnectivityService` entrar, passa a refletir a conexão real — e o
/// [SyncEngine] não muda.
final isOnlineProvider = Provider<bool>((ref) => Env.hasSupabase);

/// Motor de sincronização do outbox.
final syncEngineProvider = Provider<SyncEngine>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return SyncEngine(
    outboxDao: db.outboxDao,
    rideDao: db.rideDao,
    expenseDao: db.expenseDao,
    client: ref.watch(remoteSyncClientProvider),
    isOnline: () => ref.read(isOnlineProvider),
  );
});

/// Quantidade de registros aguardando sincronização.
///
/// A UI mostra isso para o motorista saber que o dado está salvo e só
/// aguardando conexão — silêncio nessa situação gera desconfiança no app.
final pendingSyncCountProvider = StreamProvider<int>((ref) {
  return ref.watch(syncEngineProvider).watchPendingCount();
});

/// Resumo de hoje, direto do banco local.
final todayTotalsProvider = StreamProvider<DailyTotals>((ref) {
  return ref.watch(rideHistoryRepositoryProvider).watchToday();
});

/// Despesas de hoje, direto do banco local.
final todayExpensesProvider = StreamProvider<List<Expense>>((ref) {
  return ref.watch(expenseRepositoryProvider).watchToday();
});

/// Total gasto hoje, por categoria.
final todayExpenseTotalsProvider = StreamProvider<Map<ExpenseCategory, double>>(
  (ref) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    return ref
        .watch(expenseRepositoryProvider)
        .watchTotalsByCategory(
          from: start,
          to: start.add(const Duration(days: 1)),
        );
  },
);

/// Últimas corridas avaliadas.
final recentRidesProvider = StreamProvider<List<RideEvaluation>>((ref) {
  return ref.watch(rideHistoryRepositoryProvider).watchRecent(limit: 20);
});
