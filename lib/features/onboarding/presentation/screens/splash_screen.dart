import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rota_plus/app/providers.dart';
import 'package:rota_plus/app/router.dart';
import 'package:rota_plus/app/theme/app_theme.dart';

/// T01 — Splash.
///
/// Decide para onde o motorista vai: apresentação, cadastro do veículo ou
/// dashboard. A decisão depende de ler o banco local, então a tela existe para
/// cobrir essa leitura com algo melhor que um frame em branco.
class SplashScreen extends ConsumerStatefulWidget {
  /// Cria a tela.
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  /// Tempo mínimo em tela.
  ///
  /// Sem isso a splash pisca por dois frames quando o banco responde rápido,
  /// o que parece defeito. Com isso, parece intencional.
  static const Duration _minimumDisplay = Duration(milliseconds: 700);

  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _decide();
  }

  Future<void> _decide() async {
    final started = DateTime.now();

    final settings = await ref.read(appSettingsProvider.future);
    final profile = await ref.read(activeProfileProvider.future);

    final elapsed = DateTime.now().difference(started);
    if (elapsed < _minimumDisplay) {
      await Future<void>.delayed(_minimumDisplay - elapsed);
    }

    if (!mounted || _navigated) return;
    _navigated = true;

    final destination = switch ((settings.onboardingDone, profile)) {
      (false, _) => AppRoute.onboarding.path,
      (true, null) => AppRoute.vehicle.path,
      _ => AppRoute.dashboard.path,
    };

    if (!mounted) return;
    context.go(destination);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: AppTheme.motion,
          curve: AppTheme.motionCurve,
          builder: (context, value, child) =>
              Opacity(opacity: value, child: child),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.traffic_rounded,
                size: 72,
                color: theme.colorScheme.onPrimary,
              ),
              const SizedBox(height: 16),
              Text(
                'Rota Plus',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Saiba se a corrida vale a pena',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
