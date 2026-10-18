import 'package:flutter/material.dart';
import 'package:rota_plus/app/theme/colors.dart';

/// Temas claro e escuro do Rota Plus.
abstract final class AppTheme {
  /// Raio padrão de cards.
  static const double radiusCard = 20;

  /// Raio de cards grandes.
  static const double radiusLarge = 28;

  /// Raio de pills e badges.
  static const double radiusPill = 999;

  /// Duração padrão de transição.
  ///
  /// Acima de 300 ms o app passa a parecer lento; abaixo de 120 ms a transição
  /// não é percebida como movimento.
  static const Duration motion = Duration(milliseconds: 200);

  /// Curva padrão de transição.
  static const Curve motionCurve = Curves.easeOutCubic;

  /// Tema claro.
  static ThemeData light() => _build(Brightness.light);

  /// Tema escuro.
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
      primary: AppColors.primary,
      surface: isDark ? AppColors.surfaceDark : AppColors.surface,
      error: AppColors.stop,
    );

    final onSurface = isDark ? AppColors.inkDark : AppColors.ink;
    final onSurfaceVariant = isDark ? AppColors.ink2Dark : AppColors.ink2;

    final base = isDark ? ThemeData.dark() : ThemeData.light();

    return base.copyWith(
      colorScheme: scheme.copyWith(
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
      ),
      scaffoldBackgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.background,
      textTheme: _textTheme(base.textTheme, onSurface, onSurfaceVariant),
      cardTheme: CardThemeData(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radiusCard)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          // 48 dp é o mínimo de alvo de toque acessível.
          minimumSize: const Size.fromHeight(52),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radiusPill)),
          ),
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: isDark
            ? AppColors.backgroundDark
            : AppColors.primaryLight.withValues(alpha: 0.6),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      // Sem pageTransitionsTheme customizado: o padrão do Material 3 nesta
      // versão do Flutter já usa fade-forwards no Android e a transição
      // nativa no iOS.
      extensions: <ThemeExtension<dynamic>>[
        isDark ? SemaphoreColors.dark() : SemaphoreColors.light(),
      ],
    );
  }

  /// Hierarquia tipográfica do projeto.
  ///
  /// `Display` e `H1` do design system existem para a landing page; no app a
  /// hierarquia começa em `H2`, senão o título engole a tela em `compact`.
  static TextTheme _textTheme(
    TextTheme base,
    Color onSurface,
    Color onSurfaceVariant,
  ) => base
      .copyWith(
        headlineLarge: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        titleMedium: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
        bodyLarge: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
        bodyMedium: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
        labelLarge: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        labelMedium: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      )
      .apply(bodyColor: onSurface, displayColor: onSurface)
      .copyWith(
        bodySmall: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: onSurfaceVariant,
        ),
      );
}

/// Acesso tipado às cores do semáforo.
extension SemaphoreTheme on ThemeData {
  /// Cores do semáforo deste tema.
  SemaphoreColors get semaphore => extension<SemaphoreColors>()!;
}
