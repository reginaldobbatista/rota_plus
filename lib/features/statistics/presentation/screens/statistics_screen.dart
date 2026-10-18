import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota_plus/app/providers.dart';
import 'package:rota_plus/app/theme/app_theme.dart';
import 'package:rota_plus/app/theme/breakpoints.dart';
import 'package:rota_plus/core/formatters/formatters.dart';
import 'package:rota_plus/features/financial/data/repositories/financial_repository.dart';
import 'package:rota_plus/features/financial/domain/entities/period_summary.dart';

/// T12 — Estatísticas de desempenho.
///
/// Responde às duas perguntas que mudam a rotina do motorista: **quando**
/// compensa rodar e **em qual plataforma**.
class StatisticsScreen extends ConsumerWidget {
  /// Cria a tela.
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(cashReportProvider);
    final period = ref.watch(cashPeriodProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Estatísticas')),
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
                    'Não foi possível calcular as estatísticas.',
                  ),
                  AsyncValue(:final value?)
                      when value.summary.ridesEvaluated == 0 =>
                    const _Message(
                      'Nenhuma corrida avaliada neste período.\n'
                      'As estatísticas aparecem a partir da primeira.',
                    ),
                  AsyncValue(:final value?) => _Content(report: value),
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

class _Content extends StatelessWidget {
  const _Content({required this.report});

  final CashReport report;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BestHoursCard(stats: report.hourStats),
        const SizedBox(height: 16),
        _HeatmapCard(stats: report.hourStats),
        const SizedBox(height: 16),
        _PlatformCard(stats: report.platformStats),
      ],
    );
  }
}

/// Destaca as melhores faixas de horário.
///
/// O mapa de calor mostra tudo; este cartão responde direto: "rode nestas
/// horas". É o que cabe num olhar rápido antes de sair.
class _BestHoursCard extends StatelessWidget {
  const _BestHoursCard({required this.stats});

  final List<HourStat> stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Só considera faixas com amostra mínima: uma corrida isolada de R$/km
    // alto não é um padrão, é sorte.
    final relevant = stats.where((s) => s.offers >= 2).toList()
      ..sort((a, b) => b.avgRsPerKm.compareTo(a.avgRsPerKm));
    final best = relevant.take(3).toList();

    return _Card(
      title: 'Melhores horários',
      subtitle: best.isEmpty
          ? 'Ainda sem repetição suficiente para identificar um padrão.'
          : 'Faixas com o melhor R\$/km médio no período.',
      child: best.isEmpty
          ? const SizedBox.shrink()
          : Column(
              children: [
                for (final s in best)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${_weekdayName(s.weekday)}, '
                            '${s.hour.toString().padLeft(2, '0')}h',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                        Text(
                          '${Fmt.perKm(s.avgRsPerKm)}/km',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${s.offers} ofertas',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}

/// Mapa de calor por dia da semana e faixa de três horas.
class _HeatmapCard extends StatelessWidget {
  const _HeatmapCard({required this.stats});

  final List<HourStat> stats;

  static const List<int> _slots = [0, 3, 6, 9, 12, 15, 18, 21];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Agrupa em faixas de três horas: 24 colunas não cabem em tela de celular
    // e cada célula ficaria com amostra pequena demais para significar algo.
    final buckets = <(int, int), List<HourStat>>{};
    for (final s in stats) {
      final slot = (s.hour ~/ 3) * 3;
      buckets.putIfAbsent((s.weekday, slot), () => []).add(s);
    }

    final maxOffers = buckets.values
        .map((list) => list.fold(0, (sum, s) => sum + s.offers))
        .fold(0, (a, b) => a > b ? a : b);

    return _Card(
      title: 'Quando você recebe oferta',
      subtitle: 'Mais escuro significa mais ofertas na faixa.',
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 36),
              for (final slot in _slots)
                Expanded(
                  child: Text(
                    slot.toString().padLeft(2, '0'),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          for (var weekday = 0; weekday < 7; weekday++)
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Row(
                children: [
                  SizedBox(
                    width: 36,
                    child: Text(
                      _weekdayShort(weekday),
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  for (final slot in _slots)
                    Expanded(
                      child: _HeatCell(
                        offers: (buckets[(weekday, slot)] ?? []).fold(
                          0,
                          (sum, s) => sum + s.offers,
                        ),
                        maxOffers: maxOffers,
                        label:
                            '${_weekdayName(weekday)}, '
                            '${slot.toString().padLeft(2, '0')}h',
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _HeatCell extends StatelessWidget {
  const _HeatCell({
    required this.offers,
    required this.maxOffers,
    required this.label,
  });

  final int offers;
  final int maxOffers;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ratio = maxOffers == 0 ? 0.0 : offers / maxOffers;

    return Tooltip(
      // A cor sozinha não informa a quantidade, e cor como único significante
      // exclui quem tem daltonismo. O número fica acessível no toque.
      message: '$label: $offers ${offers == 1 ? 'oferta' : 'ofertas'}',
      child: Container(
        height: 26,
        margin: const EdgeInsets.symmetric(horizontal: 1.5),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(
            alpha: offers == 0 ? 0.05 : 0.15 + ratio * 0.75,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: offers == 0
            ? null
            : Text(
                '$offers',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: ratio > 0.55
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                  fontSize: 11,
                ),
              ),
      ),
    );
  }
}

/// Comparativo entre plataformas.
class _PlatformCard extends StatelessWidget {
  const _PlatformCard({required this.stats});

  final List<PlatformStat> stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _Card(
      title: 'Comparativo de plataformas',
      subtitle: 'Média de R\$/km das ofertas e o que de fato rendeu.',
      child: Column(
        children: [
          for (final s in stats)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          s.platform.label,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      Text(
                        '${Fmt.perKm(s.avgRsPerKm)}/km',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${s.offers} ofertas · ${s.accepted} aceitas · '
                    'lucro ${Fmt.money(s.totalProfit)}',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: s.acceptanceRate ?? 0,
                      minHeight: 6,
                      backgroundColor: theme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.15),
                      color: _barColor(theme, s.totalProfit),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _barColor(ThemeData theme, Decimal profit) =>
      profit < Decimal.zero ? theme.semaphore.stop : theme.colorScheme.primary;
}

String _weekdayName(int weekday) => const [
  'Domingo',
  'Segunda',
  'Terça',
  'Quarta',
  'Quinta',
  'Sexta',
  'Sábado',
][weekday];

String _weekdayShort(int weekday) =>
    const ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'][weekday];

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
