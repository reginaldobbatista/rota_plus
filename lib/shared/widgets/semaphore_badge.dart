import 'package:flutter/material.dart';
import 'package:rota_plus/app/theme/app_theme.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_evaluation.dart';

/// Par de cores (destaque e texto) de um veredicto, no tema em uso.
@immutable
final class VerdictPalette {
  /// Cria a paleta de um veredicto.
  const VerdictPalette({required this.accent, required this.text});

  /// Resolve a paleta de [verdict] no tema de [context].
  factory VerdictPalette.of(BuildContext context, RideVerdict verdict) {
    final c = Theme.of(context).semaphore;
    return switch (verdict) {
      RideVerdict.accept => VerdictPalette(accent: c.go, text: c.goText),
      RideVerdict.think => VerdictPalette(accent: c.wait, text: c.waitText),
      RideVerdict.reject => VerdictPalette(accent: c.stop, text: c.stopText),
    };
  }

  /// Cor de destaque: barra, ícone, borda.
  final Color accent;

  /// Cor de texto, com contraste garantido sobre a superfície.
  final Color text;
}

/// Ícone correspondente a um veredicto.
IconData verdictIcon(RideVerdict verdict) => switch (verdict) {
  RideVerdict.accept => Icons.check_circle_rounded,
  RideVerdict.think => Icons.warning_amber_rounded,
  RideVerdict.reject => Icons.do_not_disturb_on_rounded,
};

/// Badge do veredicto do semáforo: ícone + texto + cor.
///
/// O ícone e o texto não são decoração: cor como único significante exclui
/// quem tem daltonismo, e cerca de 8% dos homens têm alguma forma dele.
class SemaphoreBadge extends StatelessWidget {
  /// Cria o badge.
  const SemaphoreBadge({
    required this.verdict,
    this.compact = false,
    super.key,
  });

  /// Veredicto a exibir.
  final RideVerdict verdict;

  /// Versão reduzida, para listas.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = VerdictPalette.of(context, verdict);
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: 'Veredicto: ${verdict.label}',
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: palette.accent.withValues(alpha: 0.14),
          borderRadius: const BorderRadius.all(
            Radius.circular(AppTheme.radiusPill),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 10 : 14,
            vertical: compact ? 5 : 8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                verdictIcon(verdict),
                size: compact ? 16 : 20,
                color: palette.text,
              ),
              const SizedBox(width: 6),
              // Flexible porque o texto cresce com o textScaler do usuário.
              Flexible(
                child: Text(
                  verdict.label,
                  style:
                      (compact ? textTheme.labelMedium : textTheme.labelLarge)
                          ?.copyWith(
                            color: palette.text,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
