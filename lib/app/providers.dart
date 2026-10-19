import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota_plus/core/config/env.dart';
import 'package:rota_plus/core/services/accessibility_bridge.dart';
import 'package:rota_plus/core/services/navigation_launcher.dart';
import 'package:rota_plus/core/services/overlay_service.dart';
import 'package:rota_plus/core/services/tts_service.dart';
import 'package:rota_plus/core/sync/sync_engine.dart';
import 'package:rota_plus/core/sync/sync_scheduler.dart';
import 'package:rota_plus/data/local/database.dart';
import 'package:rota_plus/data/remote/supabase_sync_client.dart';
import 'package:rota_plus/features/auth/data/repositories/auth_repository.dart';
import 'package:rota_plus/features/expenses/data/repositories/expense_repository.dart';
import 'package:rota_plus/features/expenses/domain/entities/expense.dart';
import 'package:rota_plus/features/financial/data/repositories/financial_repository.dart';
import 'package:rota_plus/features/financial/data/repositories/work_session_repository.dart';
import 'package:rota_plus/features/financial/domain/entities/period_summary.dart';
import 'package:rota_plus/features/goals/domain/entities/work_goals.dart';
import 'package:rota_plus/features/history/data/repositories/ride_history_repository.dart';
import 'package:rota_plus/features/history/domain/entities/daily_totals.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_evaluation.dart';
import 'package:rota_plus/features/semaphore/domain/usecases/evaluate_ride.dart';
import 'package:rota_plus/features/settings/data/repositories/app_settings_repository.dart';
import 'package:rota_plus/features/vehicle/data/repositories/config_repository.dart';
import 'package:rota_plus/features/vehicle/domain/entities/cost_parameters.dart';
import 'package:rota_plus/features/vehicle/domain/entities/work_profile.dart';
import 'package:rota_plus/features/vehicle/domain/usecases/calculate_cost_per_km.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Perfil de trabalho em uso, lido do banco local.
///
/// `null` enquanto o motorista não criou nenhum — é o estado que leva o app ao
/// onboarding em vez de usar metas inventadas.
final activeProfileProvider = StreamProvider<WorkProfile?>((ref) {
  return ref.watch(configRepositoryProvider).watchActiveProfile();
});

/// Perfis de trabalho cadastrados.
final workProfilesProvider = StreamProvider<List<WorkProfile>>((ref) {
  return ref.watch(configRepositoryProvider).watchProfiles();
});

/// Veículos cadastrados.
final vehiclesProvider = StreamProvider<List<Vehicle>>((ref) {
  return ref.watch(configRepositoryProvider).watchVehicles();
});

/// Metas do perfil em uso.
///
/// Sem perfil cadastrado não há metas: o semáforo fica indisponível em vez de
/// dar veredicto com critério inventado.
final workGoalsProvider = Provider<WorkGoals?>((ref) {
  return ref.watch(activeProfileProvider).value?.goals;
});

/// Parâmetros de custo do veículo do perfil em uso.
final costParametersProvider = StreamProvider<CostParameters?>((ref) {
  final vehicleId = ref.watch(
    activeProfileProvider.select((p) => p.value?.vehicleClientId),
  );
  if (vehicleId == null) return Stream.value(null);
  return ref.watch(configRepositoryProvider).watchCostParameters(vehicleId);
});

/// Composição do custo por km do veículo em uso.
///
/// Derivado: recalcula só quando veículo ou custos mudam. O overlay lê o valor
/// já pronto, nunca recomputa no caminho crítico.
final costBreakdownProvider = Provider<CostBreakdown?>((ref) {
  final params = ref.watch(costParametersProvider).value;
  if (params == null) return null;
  const useCase = CalculateCostPerKm();
  return useCase(params);
});

/// Custo por quilômetro do veículo em uso. Zero quando o cadastro está incompleto.
final costPerKmProvider = Provider<Decimal>((ref) {
  return ref.watch(costBreakdownProvider)?.totalPerKm ?? Decimal.zero;
});

/// Indica se o motorista já concluiu a configuração mínima.
///
/// Sem veículo e perfil, o app não tem como avaliar corrida — e mandar o
/// usuário para o dashboard seria mostrar números sem significado.
final isConfiguredProvider = Provider<bool>((ref) {
  final profile = ref.watch(activeProfileProvider).value;
  return profile != null && profile.vehicleClientId != null;
});

/// Avaliador de corridas, configurado com o custo e as metas em uso.
///
/// `null` enquanto não há perfil cadastrado. Devolver um avaliador com metas
/// inventadas seria pior do que não avaliar: o motorista confiaria num
/// veredicto que não reflete o custo dele.
final evaluateRideProvider = Provider<EvaluateRide?>((ref) {
  final goals = ref.watch(workGoalsProvider);
  if (goals == null) return null;

  return EvaluateRide(costPerKm: ref.watch(costPerKmProvider), goals: goals);
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

/// Configuração do motorista: veículos, custos e perfis de trabalho.
final configRepositoryProvider = Provider<ConfigRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ConfigRepository(database: db, dao: db.configDao);
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
    sessionDao: db.sessionDao,
    client: ref.watch(remoteSyncClientProvider),
    isOnline: () => ref.read(isOnlineProvider),
  );
});

/// Agendador que decide quando o outbox é drenado.
///
/// Precisa ser mantido vivo por alguém — `RotaPlusApp` o inicia no `initState`.
/// Sem isso o `SyncEngine` existiria sem nunca ser chamado, e a fila só
/// cresceria.
final syncSchedulerProvider = Provider<SyncScheduler>((ref) {
  final scheduler = SyncScheduler(engine: ref.watch(syncEngineProvider));
  ref.onDispose(scheduler.dispose);
  return scheduler;
});

/// Conta do motorista.
///
/// Opcional por decisão de produto: o app funciona inteiro sem ela.
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

/// Usuário autenticado, ou `null` em modo local.
final currentUserProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).watchUser();
});

/// Indica se há sessão ativa.
final isSignedInProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider).value != null;
});

/// Preferências do aparelho.
final appSettingsRepositoryProvider = Provider<AppSettingsRepository>((ref) {
  return AppSettingsRepository(dao: ref.watch(appDatabaseProvider).settingsDao);
});

/// Preferências observadas.
final appSettingsProvider = StreamProvider<AppSettings>((ref) {
  return ref.watch(appSettingsRepositoryProvider).watch();
});

/// Tema escolhido pelo motorista.
final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(appSettingsProvider).value?.themeMode ?? ThemeMode.system;
});

/// Ponte com o serviço de captura nativo.
final accessibilityBridgeProvider = Provider<AccessibilityBridge>(
  (ref) => AccessibilityBridge(),
);

/// Controle do cartão flutuante.
final overlayServiceProvider = Provider<OverlayService>((ref) {
  final service = OverlayService();
  ref.onDispose(() => service.hide().ignore());
  return service;
});

/// Serviço de voz.
final ttsServiceProvider = Provider<TtsService>((ref) {
  final service = TtsService();
  ref.onDispose(service.stop);
  return service;
});

/// Abertura de rota no Waze ou Google Maps.
final navigationLauncherProvider = Provider<NavigationLauncher>(
  (ref) => const NavigationLauncher(),
);

/// Registro de expediente.
final workSessionRepositoryProvider = Provider<WorkSessionRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return WorkSessionRepository(
    database: db,
    sessionDao: db.sessionDao,
    outboxDao: db.outboxDao,
  );
});

/// Expediente aberto, se houver.
final openWorkSessionProvider = StreamProvider<WorkSession?>((ref) {
  return ref.watch(workSessionRepositoryProvider).watchOpen();
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

/// Apuração financeira a partir do banco local.
final financialRepositoryProvider = Provider<FinancialRepository>((ref) {
  return FinancialRepository(dao: ref.watch(appDatabaseProvider).reportDao);
});

/// Período selecionado no fechamento de caixa.
final cashPeriodProvider = StateProvider<CashPeriod>((ref) => CashPeriod.day);

/// Relatório do período selecionado.
final cashReportProvider = StreamProvider<CashReport>((ref) {
  final (from, to) = ref.watch(cashPeriodProvider).rangeFrom(DateTime.now());
  return ref.watch(financialRepositoryProvider).watchReport(from: from, to: to);
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
