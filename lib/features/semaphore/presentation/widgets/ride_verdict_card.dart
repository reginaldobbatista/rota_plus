import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:rota_plus/app/theme/app_theme.dart';
import 'package:rota_plus/app/theme/breakpoints.dart';
import 'package:rota_plus/core/formatters/formatters.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_evaluation.dart';
import 'package:rota_plus/shared/widgets/metric_card.dart';
import 'package:rota_plus/shared/widgets/semaphore_badge.dart';

/// Cartão do semáforo: o produto.
///
/// É o mesmo widget usado no overlay sobre os apps de transporte e no
/// simulador dentro do app. Está envolvido em [RepaintBoundary] porque anima
/// independente do resto da árvore, e usa `const` onde possível: o orçamento
/// é de 120 ms entre o evento de acessibilidade e o primeiro frame.
class RideVerdictCard extends StatelessWidget {
  /// Cria o cartão.
  const RideVerdictCard({required this.evaluation, this.onDismiss, super.key});

  /// Avaliação a exibir.
  final RideEvaluation evaluation;

  /// Chamado quando o motorista descarta o cartão.
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = VerdictPalette.of(context, evaluation.verdict);
    final offer = evaluation.offer;

    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = math.min(
            constraints.maxWidth,
            Breakpoints.overlayCardWidth,
          );

          return SizedBox(
            width: width,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Barra lateral na cor do veredicto.
                  SizedBox(width: 8, child: ColoredBox(color: palette.accent)),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _Header(evaluation: evaluation, onDismiss: onDismiss),
                          const SizedBox(height: 14),
                          MetricGrid(
                            cells: [
                              MetricCell(
                                label: r'R$/km',
                                value: Fmt.perKm(evaluation.rsPerKm),
                                valueColor: palette.text,
                              ),
                              MetricCell(
                                label: r'R$/hora',
                                value: Fmt.perHour(evaluation.rsPerHour),
                              ),
                              MetricCell(
                                label: 'Lucro',
                                value: Fmt.money(evaluation.realProfit),
                                valueColor: evaluation.isLoss
                                    ? theme.semaphore.stopText
                                    : null,
                              ),
                              MetricCell(
                                label: 'Nota',
                                value: offer.passengerRating == null
                                    ? '—'
                                    : Fmt.rating(offer.passengerRating!),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _Footer(evaluation: evaluation),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.evaluation, this.onDismiss});

  final RideEvaluation evaluation;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SemaphoreBadge(verdict: evaluation.verdict),
              const SizedBox(height: 8),
              Text(
                Fmt.money(evaluation.offer.fare),
                style: theme.textTheme.headlineMedium,
                maxLines: 1,
              ),
            ],
          ),
        ),
        if (onDismiss != null)
          IconButton(
            onPressed: onDismiss,
            icon: const Icon(Icons.close_rounded),
            // 48 dp: mínimo de alvo de toque acessível.
            constraints: const BoxConstraints.tightFor(width: 48, height: 48),
            tooltip: 'Fechar',
          ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.evaluation});

  final RideEvaluation evaluation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final offer = evaluation.offer;
    final reason = evaluation.primaryReason;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            _Chip(icon: Icons.local_taxi_rounded, text: offer.platform.label),
            _Chip(icon: Icons.straighten_rounded, text: Fmt.km(offer.totalKm)),
            _Chip(
              icon: Icons.schedule_rounded,
              text: Fmt.minutes(offer.totalMinutes),
            ),
            if (offer.pickupRegion case final region?)
              _Chip(icon: Icons.place_rounded, text: region),
          ],
        ),
        // Explicar o veredicto é o que ensina o motorista a decidir melhor.
        if (reason != null) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 15,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(reason.label, style: theme.textTheme.bodySmall),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(text, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
