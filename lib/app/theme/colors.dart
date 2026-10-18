import 'package:flutter/material.dart';

/// Paleta do Rota Plus.
///
/// Os widgets consomem cor por `Theme.of(context).colorScheme` ou pelas
/// extensões de tema; hex literal dentro de widget não passa em revisão.
abstract final class AppColors {
  /// Cor principal da marca.
  static const Color primary = Color(0xFF009D68);

  /// Variação escura da marca.
  static const Color primaryDark = Color(0xFF007F54);

  /// Variação clara, para fundos suaves.
  static const Color primaryLight = Color(0xFFE5F6EF);

  /// Semáforo — ACEITAR.
  static const Color go = Color(0xFF1FB877);

  /// Semáforo — PENSE (barra e ícone).
  static const Color wait = Color(0xFFFF9F0A);

  /// Semáforo — PENSE (texto).
  ///
  /// O `wait` tem contraste de ~2:1 sobre branco e reprova em WCAG AA. Este
  /// tom escurecido passa de 4.5:1 mantendo a leitura de "amarelo".
  static const Color waitText = Color(0xFF8A5200);

  /// Semáforo — RECUSAR.
  static const Color stop = Color(0xFFFF3B30);

  /// Fundo do app (tema claro).
  static const Color background = Color(0xFFE2F0E7);

  /// Superfícies e cards (tema claro).
  static const Color surface = Color(0xFFFFFFFF);

  /// Texto principal (tema claro).
  static const Color ink = Color(0xFF0B1E19);

  /// Texto secundário (tema claro).
  static const Color ink2 = Color(0xFF52645D);

  /// Fundo do app (tema escuro).
  static const Color backgroundDark = Color(0xFF0A0F0D);

  /// Superfícies e cards (tema escuro).
  static const Color surfaceDark = Color(0xFF151C18);

  /// Texto principal (tema escuro).
  static const Color inkDark = Color(0xFFE8F2ED);

  /// Texto secundário (tema escuro).
  static const Color ink2Dark = Color(0xFF9DB0A8);
}

/// Cores do semáforo, resolvidas para o brilho do tema em uso.
@immutable
final class SemaphoreColors extends ThemeExtension<SemaphoreColors> {
  /// Cria o conjunto de cores do semáforo.
  const SemaphoreColors({
    required this.go,
    required this.goText,
    required this.wait,
    required this.waitText,
    required this.stop,
    required this.stopText,
  });

  /// Conjunto para o tema claro.
  factory SemaphoreColors.light() => const SemaphoreColors(
    go: AppColors.go,
    goText: AppColors.primaryDark,
    wait: AppColors.wait,
    waitText: AppColors.waitText,
    stop: AppColors.stop,
    stopText: Color(0xFFB3261E),
  );

  /// Conjunto para o tema escuro.
  ///
  /// No escuro os tons saturados já têm contraste suficiente, então texto e
  /// barra podem usar a mesma cor.
  factory SemaphoreColors.dark() => const SemaphoreColors(
    go: AppColors.go,
    goText: Color(0xFF4FD99B),
    wait: AppColors.wait,
    waitText: Color(0xFFFFC46B),
    stop: AppColors.stop,
    stopText: Color(0xFFFF8A80),
  );

  /// Cor de destaque do estado ACEITAR.
  final Color go;

  /// Cor de texto do estado ACEITAR.
  final Color goText;

  /// Cor de destaque do estado PENSE.
  final Color wait;

  /// Cor de texto do estado PENSE.
  final Color waitText;

  /// Cor de destaque do estado RECUSAR.
  final Color stop;

  /// Cor de texto do estado RECUSAR.
  final Color stopText;

  @override
  SemaphoreColors copyWith({
    Color? go,
    Color? goText,
    Color? wait,
    Color? waitText,
    Color? stop,
    Color? stopText,
  }) => SemaphoreColors(
    go: go ?? this.go,
    goText: goText ?? this.goText,
    wait: wait ?? this.wait,
    waitText: waitText ?? this.waitText,
    stop: stop ?? this.stop,
    stopText: stopText ?? this.stopText,
  );

  @override
  SemaphoreColors lerp(ThemeExtension<SemaphoreColors>? other, double t) {
    if (other is! SemaphoreColors) return this;
    return SemaphoreColors(
      go: Color.lerp(go, other.go, t)!,
      goText: Color.lerp(goText, other.goText, t)!,
      wait: Color.lerp(wait, other.wait, t)!,
      waitText: Color.lerp(waitText, other.waitText, t)!,
      stop: Color.lerp(stop, other.stop, t)!,
      stopText: Color.lerp(stopText, other.stopText, t)!,
    );
  }
}
