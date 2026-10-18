import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rota_plus/app/router.dart';
import 'package:rota_plus/app/theme/app_theme.dart';

/// Raiz do aplicativo.
class RotaPlusApp extends ConsumerStatefulWidget {
  /// Cria a raiz do app.
  const RotaPlusApp({super.key});

  @override
  ConsumerState<RotaPlusApp> createState() => _RotaPlusAppState();
}

class _RotaPlusAppState extends ConsumerState<RotaPlusApp> {
  // Criado uma única vez: recriar o router a cada build descartaria a pilha
  // de navegação.
  late final GoRouter _router = buildRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Rota Plus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: _router,
    );
  }
}
