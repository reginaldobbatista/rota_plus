import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rota_plus/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:rota_plus/features/expenses/presentation/screens/expenses_screen.dart';
import 'package:rota_plus/features/goals/presentation/screens/goals_screen.dart';
import 'package:rota_plus/features/profiles/presentation/screens/profiles_screen.dart';
import 'package:rota_plus/features/semaphore/presentation/screens/simulator_screen.dart';
import 'package:rota_plus/features/vehicle/presentation/screens/vehicle_screen.dart';

/// Rotas nomeadas do app.
///
/// Usar o enum em vez de string literal faz o analyzer apontar a rota
/// inexistente em tempo de compilação.
enum AppRoute {
  /// Tela principal.
  dashboard('/'),

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

/// Configuração de navegação do app.
///
/// Os guards de autenticação e de entitlement entram no `redirect` quando o
/// Supabase Auth for ligado — por isso a navegação já nasce declarativa.
GoRouter buildRouter() => GoRouter(
  initialLocation: AppRoute.dashboard.path,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoute.dashboard.path,
      name: AppRoute.dashboard.name,
      builder: (context, state) => const DashboardScreen(),
      routes: <RouteBase>[
        GoRoute(
          path: 'simulador',
          name: AppRoute.simulator.name,
          builder: (context, state) => const SimulatorScreen(),
        ),
        GoRoute(
          path: 'despesas',
          name: AppRoute.expenses.name,
          builder: (context, state) => const ExpensesScreen(),
        ),
        GoRoute(
          path: 'veiculo',
          name: AppRoute.vehicle.name,
          builder: (context, state) =>
              VehicleScreen(vehicleClientId: state.uri.queryParameters['id']),
        ),
        GoRoute(
          path: 'metas',
          name: AppRoute.goals.name,
          builder: (context, state) => const GoalsScreen(),
        ),
        GoRoute(
          path: 'perfis',
          name: AppRoute.profiles.name,
          builder: (context, state) => const ProfilesScreen(),
          routes: <RouteBase>[
            GoRoute(
              // Editar as metas de um perfil específico, e não só do ativo.
              path: ':id',
              builder: (context, state) =>
                  GoalsScreen(profileClientId: state.pathParameters['id']),
            ),
          ],
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
