import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rota_plus/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:rota_plus/features/expenses/presentation/screens/expenses_screen.dart';
import 'package:rota_plus/features/semaphore/presentation/screens/simulator_screen.dart';

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
  expenses('/despesas');

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
