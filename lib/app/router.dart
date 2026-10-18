import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rota_plus/app/shell.dart';
import 'package:rota_plus/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:rota_plus/features/expenses/presentation/screens/expenses_screen.dart';
import 'package:rota_plus/features/financial/presentation/screens/cash_screen.dart';
import 'package:rota_plus/features/goals/presentation/screens/goals_screen.dart';
import 'package:rota_plus/features/history/presentation/screens/history_screen.dart';
import 'package:rota_plus/features/profiles/presentation/screens/profiles_screen.dart';
import 'package:rota_plus/features/semaphore/presentation/screens/simulator_screen.dart';
import 'package:rota_plus/features/settings/presentation/screens/settings_screen.dart';
import 'package:rota_plus/features/vehicle/presentation/screens/vehicle_screen.dart';

/// Rotas nomeadas do app.
///
/// Usar o enum em vez de string literal faz o analyzer apontar a rota
/// inexistente em tempo de compilação.
enum AppRoute {
  /// Tela principal (T04).
  dashboard('/'),

  /// Histórico de corridas (T09).
  history('/historico'),

  /// Fechamento de caixa (T10).
  cash('/caixa'),

  /// Ajustes (T13).
  settings('/ajustes'),

  /// Simulador do semáforo.
  simulator('/simulador'),

  /// Registro de despesas (T11).
  expenses('/despesas'),

  /// Configuração do veículo e dos custos (T06).
  vehicle('/veiculo'),

  /// Metas do perfil em uso (T07).
  goals('/metas'),

  /// Perfis de trabalho (T08).
  profiles('/perfis');

  const AppRoute(this.path);

  /// Caminho da rota.
  final String path;
}

final _rootKey = GlobalKey<NavigatorState>();

/// Configuração de navegação do app.
///
/// As quatro abas usam `StatefulShellRoute`, que preserva o estado de cada
/// uma: voltar para o histórico não perde a posição da rolagem nem os filtros.
///
/// Telas abertas por cima (veículo, metas, despesas) ficam no navegador raiz,
/// fora das abas — formulário não pertence a uma aba.
GoRouter buildRouter() => GoRouter(
  navigatorKey: _rootKey,
  initialLocation: AppRoute.dashboard.path,
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoute.dashboard.path,
              name: AppRoute.dashboard.name,
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoute.history.path,
              name: AppRoute.history.name,
              builder: (context, state) => const HistoryScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoute.cash.path,
              name: AppRoute.cash.name,
              builder: (context, state) => const CashScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoute.settings.path,
              name: AppRoute.settings.name,
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: _rootKey,
      path: AppRoute.simulator.path,
      name: AppRoute.simulator.name,
      builder: (context, state) => const SimulatorScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootKey,
      path: AppRoute.expenses.path,
      name: AppRoute.expenses.name,
      builder: (context, state) => const ExpensesScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootKey,
      path: AppRoute.vehicle.path,
      name: AppRoute.vehicle.name,
      builder: (context, state) =>
          VehicleScreen(vehicleClientId: state.uri.queryParameters['id']),
    ),
    GoRoute(
      parentNavigatorKey: _rootKey,
      path: AppRoute.goals.path,
      name: AppRoute.goals.name,
      builder: (context, state) => const GoalsScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootKey,
      path: AppRoute.profiles.path,
      name: AppRoute.profiles.name,
      builder: (context, state) => const ProfilesScreen(),
      routes: <RouteBase>[
        GoRoute(
          parentNavigatorKey: _rootKey,
          // Editar as metas de um perfil específico, e não só do ativo.
          path: ':id',
          builder: (context, state) =>
              GoalsScreen(profileClientId: state.pathParameters['id']),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text('Rota não encontrada: ${state.uri}'),
      ),
    ),
  ),
);
