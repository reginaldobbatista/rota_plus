import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota_plus/app/providers.dart';
import 'package:rota_plus/app/theme/app_theme.dart';
import 'package:rota_plus/data/local/database.dart';

/// Ambiente de teste com banco em memória.
///
/// Sobrescreve `appDatabaseProvider` para que as telas exercitem a camada de
/// dados real — Drift, repositórios e providers — sem tocar no disco. Testar
/// contra mocks aqui esconderia justamente os erros de integração entre eles.
class AppHarness {
  /// Cria o ambiente e abre o banco.
  AppHarness() : database = AppDatabase.forTesting(NativeDatabase.memory());

  /// Banco em memória usado pelos providers.
  final AppDatabase database;

  /// Overrides a aplicar no `ProviderScope`.
  List<Override> get overrides => [
    appDatabaseProvider.overrideWithValue(database),
  ];

  /// Fecha o banco.
  Future<void> dispose() => database.close();

  /// Envolve [child] com tema, Riverpod e um `Scaffold` navegável.
  Widget wrap(Widget child, {double textScale = 1}) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: AppTheme.light(),
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
          child: child,
        ),
      ),
    );
  }
}
