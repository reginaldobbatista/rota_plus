import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota_plus/app/providers.dart';
import 'package:rota_plus/app/theme/app_theme.dart';
import 'package:rota_plus/app/theme/breakpoints.dart';
import 'package:rota_plus/core/formatters/formatters.dart';
import 'package:rota_plus/features/expenses/domain/entities/expense.dart';
import 'package:rota_plus/features/financial/data/repositories/financial_repository.dart';
import 'package:rota_plus/features/financial/domain/entities/period_summary.dart';
import 'package:rota_plus/shared/widgets/metric_card.dart';

/// T10 — Fechamento de caixa.
class CashScreen extends ConsumerWidget {
  /// Cria a tela.
  const CashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(cashPeriodProvider);
    final report = ref.watch(cashReportProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Fechamento de caixa')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.readableWidth,
            ),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                SegmentedButton<CashPeriod>(
                  segments: [
                    for (final p in CashPeriod.values)
                      ButtonSegment(value: p, label: Text(p.label)),
                  ],
                  selected: {period},
                  onSelectionChanged: (s) =>
                      ref.read(cashPeriodProvider.notifier).state = s.first,
                  showSelectedIcon: false,
                ),
                const SizedBox(height: 16),
                switch (report) {
                  AsyncValue(hasError: true) => const _Message(
                    'Não foi possível apurar o período.',
                  ),
                  AsyncValue(:final value?) when value.isEmpty =>
                    const _Message('Nada registrado neste período.'),
                  AsyncValue(:final value?) => _Report(report: value),
                  _ => const Padding(
                    padding: EdgeInsets.all(48),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                },
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Report extends StatelessWidget {
  const _Report({required this.report});

  final CashReport report;

  @override
  Widget build(BuildContext context) {
    final s = report.summary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ResultCard(summary: s),
        const SizedBox(height: 16),
        _Card(
          title: 'Números do período',
          child: MetricGrid(
            cells: [
              MetricCell(label: 'Avaliadas', value: '${s.ridesEvaluated}'),
              MetricCell(label: 'Aceitas', value: '${s.ridesAccepted}'),
              MetricCell(label: 'Rodados', value: Fmt.km(s.kmDriven)),
              MetricCell(
                label: 'Em corrida',
                value: Fmt.minutes(s.minutesDriven),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _Card(
          title: 'Por hora em corrida',
          subtitle:
              'Considera só o tempo dentro das corridas. A jornada completa '
              'depende do registro de expediente, que ainda não existe.',
          child: MetricGrid(
            cells: [
              MetricCell(
                label: 'Receita/h',
                value: s.revenuePerHour == null
                    ? '—'
                    : Fmt.perHour(s.revenuePerHour!),
              ),
              MetricCell(
                label: 'Lucro/h',
                value: s.profitPerHour == null
                    ? '—'
                    : Fmt.perHour(s.profitPerHour!),
              ),
              MetricCell(
                label: 'Aceitação',
                value: s.acceptanceRate == null
                    ? '—'
                    : '${(s.acceptanceRate! * 100).round()}%',
              ),
              MetricCell(label: 'Despesas', value: Fmt.money(s.extraExpenses)),
            ],
          ),
        ),
        if (report.dailySeries.length > 1) ...[
          const SizedBox(height: 16),
          _Card(
            title: 'Evolução diária',
            child: SizedBox(
              height: 180,
              child: _DailyChart(points: report.dailySeries),
            ),
          ),
        ],
        if (report.expensesByCategory.isNotEmpty) ...[
          const SizedBox(height: 16),
          _Card(
            title: 'Despesas por categoria',
            child: _ExpensePie(totals: report.expensesByCategory),
          ),
        ],
      ],
    );
  }
}

/// Resultado do período, em destaque.
class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.summary});

  final PeriodSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = summary.isLoss
        ? theme.semaphore.stopText
        : theme.semaphore.goText;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              summary.isLoss ? 'Prejuízo no período' : 'Lucro líquido',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              Fmt.money(summary.netProfit),
              style: theme.textTheme.headlineLarge?.copyWith(color: color),
            ),
            const SizedBox(height: 16),
            _Line(label: 'Faturamento bruto', value: summary.grossRevenue),
            _Line(
              label: 'Custo de rodar',
              value: -summary.operatingCost,
              muted: true,
            ),
            _Line(
              label: 'Despesas lançadas',
              value: -summary.extraExpenses,
              muted: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value, this.muted = false});

  final String label;
  final Decimal value;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = muted
        ? theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          )
        : theme.textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(Fmt.money(value), style: style),
        ],
      ),
    );
  }
}

/// Evolução diária do faturamento e do lucro.
class _DailyChart extends StatelessWidget {
  const _DailyChart({required this.points});

  final List<DailyPoint> points;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= points.length) {
                  return const SizedBox.shrink();
                }
                // Rótulo só de dia: com uma semana inteira, data completa
                // vira sopa de letrinhas no eixo.
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '${points[index].day.day}',
                    style: theme.textTheme.bodySmall,
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < points.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: points[i].grossRevenue.toDouble(),
                  color: theme.colorScheme.primary,
                  width: 14,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              ],
            ),
        ],
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, _, rod, _) {
              final point = points[group.x];
              return BarTooltipItem(
                '${Fmt.money(point.grossRevenue)}\n'
                '${point.rides} corridas',
                theme.textTheme.bodySmall ?? const TextStyle(),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Distribuição das despesas por categoria.
class _ExpensePie extends StatelessWidget {
  const _ExpensePie({required this.totals});

  final Map<ExpenseCategory, Decimal> totals;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entries = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final sum = entries.fold(
      Decimal.zero,
      (total, entry) => total + entry.value,
    );

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 44,
              sections: [
                for (var i = 0; i < entries.length; i++)
                  PieChartSectionData(
                    value: entries[i].value.toDouble(),
                    color: _sliceColor(theme, i),
                    showTitle: false,
                    radius: 26,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Legenda com valor: a cor sozinha não diz quanto, e cor como único
        // significante exclui quem tem daltonismo.
        for (var i = 0; i < entries.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _sliceColor(theme, i),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    entries[i].key.label,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                Text(
                  '${Fmt.money(entries[i].value)}'
                  '${sum > Decimal.zero ? ' · ${_percent(entries[i].value, sum)}' : ''}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _percent(Decimal value, Decimal total) {
    final ratio = (value / total).toDouble() * 100;
    return '${ratio.round()}%';
  }

  Color _sliceColor(ThemeData theme, int index) {
    final palette = [
      theme.colorScheme.primary,
      theme.semaphore.wait,
      theme.semaphore.stop,
      theme.semaphore.go,
      theme.colorScheme.onSurfaceVariant,
    ];
    return palette[index % palette.length];
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.child, this.subtitle});

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            if (subtitle case final text?) ...[
              const SizedBox(height: 4),
              Text(text, style: theme.textTheme.bodySmall),
            ],
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
