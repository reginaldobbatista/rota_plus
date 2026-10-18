import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rota_plus/app/providers.dart';
import 'package:rota_plus/app/router.dart';
import 'package:rota_plus/app/theme/breakpoints.dart';
import 'package:rota_plus/core/formatters/formatters.dart';
import 'package:rota_plus/features/history/domain/entities/daily_totals.dart';
import 'package:rota_plus/shared/widgets/metric_card.dart';

/// Tela principal.
///
/// Nesta fase mostra a composição do custo por km e as metas ativas — o que o
/// motorista precisa conferir antes de confiar no veredicto. Resumo do dia e
/// últimas corridas entram quando a camada local (Drift) estiver pronta.
class DashboardScreen extends ConsumerWidget {
  /// Cria a tela.
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breakdown = ref.watch(costBreakdownProvider);
    final goals = ref.watch(workGoalsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Rota Plus')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: Breakpoints.readableWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!ref.watch(isConfiguredProvider)) ...[
                    const _SetupCard(),
                    const SizedBox(height: 16),
                  ],
                  const _TodayCard(),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: 'Seu custo por quilômetro',
                    subtitle: breakdown == null
                        ? 'Complete o cadastro do veículo para calcular.'
                        : 'Abaixo deste valor, a corrida dá prejuízo.',
                    child: breakdown == null
                        ? const SizedBox.shrink()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                '${Fmt.perKm(breakdown.totalPerKm)} / km',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineLarge,
                              ),
                              const SizedBox(height: 16),
                              MetricGrid(
                                cells: [
                                  MetricCell(
                                    label: 'Combustível',
                                    value: Fmt.perKm(breakdown.fuelPerKm),
                                  ),
                                  MetricCell(
                                    label: 'Manutenção',
                                    value: Fmt.perKm(
                                      breakdown.maintenancePerKm,
                                    ),
                                  ),
                                  MetricCell(
                                    label: 'Depreciação',
                                    value: Fmt.perKm(
                                      breakdown.depreciationPerKm,
                                    ),
                                  ),
                                  MetricCell(
                                    label: 'Custos fixos',
                                    value: Fmt.perKm(breakdown.fixedPerKm),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 16),
                  if (goals != null)
                    _SectionCard(
                      title: 'Metas do perfil ativo',
                      subtitle:
                          'Tolerância de '
                          '${Fmt.percent(goals.thinkTolerancePercent)} '
                          'para o estado PENSE.',
                      child: MetricGrid(
                        cells: [
                          MetricCell(
                            label: r'Meta R$/km',
                            value: Fmt.perKm(goals.minRsPerKm),
                          ),
                          MetricCell(
                            label: r'Meta R$/hora',
                            value: Fmt.perHour(goals.minRsPerHour),
                          ),
                          MetricCell(
                            label: 'Nota mínima',
                            value: Fmt.rating(goals.minPassengerRating),
                          ),
                          MetricCell(
                            label: 'Embarque máx.',
                            value: Fmt.km(goals.maxPickupKm),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (breakdown != null)
                    _SectionCard(
                      title: 'Tarifa mínima recomendada',
                      subtitle:
                          'Custo mais 30% de margem — o piso para a corrida '
                          'valer a pena, não apenas empatar.',
                      child: Text(
                        '${Fmt.perKm(_minimumFare(breakdown.totalPerKm))} / km',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => context.push(AppRoute.simulator.path),
                    icon: const Icon(Icons.tune_rounded),
                    label: const Text('Abrir simulador'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => context.push(AppRoute.expenses.path),
                    icon: const Icon(Icons.receipt_long_rounded),
                    label: const Text('Registrar despesa'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Decimal _minimumFare(Decimal costPerKm) =>
      (costPerKm * Decimal.parse('1.30')).round(scale: 2);
}

/// Chamada para completar a configuração mínima.
///
/// Sem veículo cadastrado o custo por km não existe, e sem ele o semáforo não
/// tem piso para comparar. Deixar isso implícito faria o motorista achar que o
/// app está quebrado.
class _SetupCard extends StatelessWidget {
  const _SetupCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.primary.withValues(alpha: 0.10),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.directions_car_rounded,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Cadastre seu veículo',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Sem os custos do seu carro o app não sabe qual corrida dá '
              'prejuízo. Leva dois minutos e é o que faz o semáforo valer.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.push(AppRoute.vehicle.path),
              child: const Text('Começar'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Resumo do dia, lido do banco local.
///
/// Observa um stream do Drift: assim que uma corrida é registrada, este card
/// se atualiza sem nenhuma chamada de rede.
class _TodayCard extends ConsumerWidget {
  const _TodayCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totals = ref.watch(todayTotalsProvider);
    final pending = ref.watch(pendingSyncCountProvider).value ?? 0;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Hoje', style: theme.textTheme.titleMedium),
                ),
                if (pending > 0)
                  // O motorista precisa saber que o dado está salvo e só
                  // aguardando conexão. Silêncio aqui gera desconfiança.
                  Tooltip(
                    message: 'Salvo no aparelho, aguardando conexão',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 15,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text('$pending', style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            switch (totals) {
              AsyncValue(hasError: true) => Text(
                'Não foi possível ler o resumo.',
                style: theme.textTheme.bodyMedium,
              ),
              AsyncValue(:final value?) => _TodayMetrics(totals: value),
              _ => const _TodaySkeleton(),
            },
          ],
        ),
      ),
    );
  }
}

class _TodayMetrics extends StatelessWidget {
  const _TodayMetrics({required this.totals});

  final DailyTotals totals;

  @override
  Widget build(BuildContext context) {
    final rate = totals.acceptanceRate;

    return MetricGrid(
      cells: [
        MetricCell(label: 'Avaliadas', value: '${totals.evaluated}'),
        MetricCell(label: 'Aceitas', value: '${totals.accepted}'),
        MetricCell(
          label: 'Faturamento',
          value: Fmt.money(_toDecimal(totals.grossRevenue)),
        ),
        MetricCell(
          label: 'Aceitação',
          value: rate == null ? '—' : '${(rate * 100).round()}%',
        ),
      ],
    );
  }

  Decimal _toDecimal(double value) => Decimal.parse(value.toStringAsFixed(2));
}

/// Mantém a altura do bloco de métricas enquanto o banco responde.
///
/// Evita *layout shift*: a estrutura aparece primeiro, o número depois.
class _TodaySkeleton extends StatelessWidget {
  const _TodaySkeleton();

  @override
  Widget build(BuildContext context) {
    return const MetricGrid(
      cells: [
        MetricCell(label: 'Avaliadas', value: '—'),
        MetricCell(label: 'Aceitas', value: '—'),
        MetricCell(label: 'Faturamento', value: '—'),
        MetricCell(label: 'Aceitação', value: '—'),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
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
            const SizedBox(height: 4),
            Text(subtitle, style: theme.textTheme.bodySmall),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
