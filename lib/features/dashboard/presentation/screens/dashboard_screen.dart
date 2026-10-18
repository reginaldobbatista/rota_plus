import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rota_plus/app/providers.dart';
import 'package:rota_plus/app/router.dart';
import 'package:rota_plus/app/theme/app_theme.dart';
import 'package:rota_plus/app/theme/breakpoints.dart';
import 'package:rota_plus/core/formatters/formatters.dart';
import 'package:rota_plus/features/history/domain/entities/daily_totals.dart';
import 'package:rota_plus/features/semaphore/presentation/controllers/monitoring_controller.dart';
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
                  const _MonitoringCard(),
                  const SizedBox(height: 16),
                  const _WorkSessionCard(),
                  const SizedBox(height: 16),
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

/// Liga e desliga o semáforo sobre os apps de transporte.
///
/// É o botão que entrega o produto. Quando falta permissão, leva direto para
/// a tela que resolve — ligar um serviço que não capturaria nada seria pior
/// do que recusar.
class _MonitoringCard extends ConsumerStatefulWidget {
  const _MonitoringCard();

  @override
  ConsumerState<_MonitoringCard> createState() => _MonitoringCardState();
}

class _MonitoringCardState extends ConsumerState<_MonitoringCard>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // O motorista concede a permissão nos Ajustes e volta. Sem reconsultar
    // aqui, o cartão continuaria dizendo que falta permissão.
    if (state == AppLifecycleState.resumed) _refresh();
  }

  void _refresh() {
    ref.read(monitoringControllerProvider.notifier).refreshPermissions();
  }

  Future<void> _toggle({required bool running}) async {
    final controller = ref.read(monitoringControllerProvider.notifier);

    if (running) {
      await controller.stop();
      return;
    }

    final started = await controller.start();
    if (started || !mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Falta uma permissão'),
        content: const Text(
          'Para mostrar o semáforo sobre o Uber, 99 e inDrive, o app precisa '
          'da permissão de acessibilidade e de sobreposição.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Agora não'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.push(AppRoute.permissions.path);
            },
            child: const Text('Configurar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(monitoringControllerProvider);
    final configured = ref.watch(isConfiguredProvider);

    return Card(
      color: state.isRunning
          ? theme.semaphore.go.withValues(alpha: 0.12)
          : null,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  state.isRunning
                      ? Icons.traffic_rounded
                      : Icons.traffic_outlined,
                  size: 32,
                  color: state.isRunning
                      ? theme.semaphore.goText
                      : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.isRunning
                            ? 'Semáforo ligado'
                            : 'Semáforo desligado',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        state.isRunning
                            ? 'Avaliando as ofertas que aparecerem'
                            : 'Ligue antes de começar a rodar',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: configured
                  ? () => _toggle(running: state.isRunning)
                  : null,
              icon: Icon(
                state.isRunning ? Icons.stop_rounded : Icons.play_arrow_rounded,
              ),
              label: Text(
                state.isRunning ? 'Parar monitoramento' : 'Iniciar trabalho',
              ),
            ),
            if (state.missingPermissions && !state.isRunning) ...[
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
                    child: Text(
                      'Falta conceder acessibilidade ou sobreposição.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Controle de expediente.
///
/// Sem ele o app só sabe o tempo dentro das corridas, e o R$/hora sai
/// otimista: ignora justamente as horas paradas esperando chamada, que é onde
/// a conta do motorista costuma não fechar.
class _WorkSessionCard extends ConsumerWidget {
  const _WorkSessionCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final session = ref.watch(openWorkSessionProvider).value;
    final repo = ref.read(workSessionRepositoryProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              session == null
                  ? Icons.play_circle_outline_rounded
                  : Icons.timer_rounded,
              color: session == null
                  ? theme.colorScheme.onSurfaceVariant
                  : theme.colorScheme.primary,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session == null ? 'Fora do expediente' : 'Em expediente',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    session == null
                        ? 'Inicie para contar suas horas de verdade.'
                        : 'Desde ${_formatTime(session.startedAt)}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            session == null
                ? FilledButton(
                    onPressed: repo.start,
                    child: const Text('Iniciar'),
                  )
                : OutlinedButton(
                    onPressed: repo.stop,
                    child: const Text('Encerrar'),
                  ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime value) {
    final local = value.toLocal();
    return '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }
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
