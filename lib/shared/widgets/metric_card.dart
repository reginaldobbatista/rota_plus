import 'package:flutter/material.dart';

/// Célula de métrica: rótulo pequeno em cima, valor destacado embaixo.
///
/// A altura do valor é reservada antes do dado chegar, para não haver
/// *layout shift* quando a métrica é recalculada.
class MetricCell extends StatelessWidget {
  /// Cria a célula.
  const MetricCell({
    required this.label,
    required this.value,
    this.valueColor,
    this.icon,
    super.key,
  });

  /// Rótulo da métrica, por exemplo `R$/km`.
  final String label;

  /// Valor já formatado.
  final String value;

  /// Cor do valor. Usa a cor de texto padrão quando omitida.
  final Color? valueColor;

  /// Ícone opcional ao lado do rótulo.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: '$label: $value',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 13, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Text(
                  label,
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Grade de métricas que vira 2×2 em espaço estreito e 1×4 em espaço largo.
///
/// Decide pela largura concedida pelo pai, não pelo tamanho do aparelho: o
/// mesmo widget serve o overlay (estreito) e o dashboard em tablet.
class MetricGrid extends StatelessWidget {
  /// Cria a grade.
  const MetricGrid({required this.cells, super.key});

  /// Células a exibir.
  final List<MetricCell> cells;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final singleRow = constraints.maxWidth >= 380;
        if (singleRow) {
          return Row(
            children: [for (final cell in cells) Expanded(child: cell)],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < cells.length; i += 2) ...[
              if (i > 0) const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: cells[i]),
                  if (i + 1 < cells.length) Expanded(child: cells[i + 1]),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}
