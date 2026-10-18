import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota_plus/app/providers.dart';
import 'package:rota_plus/app/theme/app_theme.dart';
import 'package:rota_plus/app/theme/breakpoints.dart';
import 'package:rota_plus/core/formatters/formatters.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_evaluation.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_offer.dart';
import 'package:rota_plus/shared/widgets/semaphore_badge.dart';

/// Filtros aplicáveis ao histórico.
@immutable
final class HistoryFilter {
  /// Cria o filtro.
  const HistoryFilter({this.platform, this.verdict});

  /// Plataforma, ou `null` para todas.
  final RidePlatform? platform;

  /// Veredicto, ou `null` para todos.
  final RideVerdict? verdict;

  /// Indica se algum filtro está ativo.
  bool get isActive => platform != null || verdict != null;

  /// Aplica o filtro a uma avaliação.
  bool matches(RideEvaluation ride) {
    if (platform != null && ride.offer.platform != platform) return false;
    if (verdict != null && ride.verdict != verdict) return false;
    return true;
  }

  /// Retorna uma cópia com os campos informados substituídos.
  HistoryFilter copyWith({
    Object? platform = _unset,
    Object? verdict = _unset,
  }) => HistoryFilter(
    platform: platform == _unset ? this.platform : platform as RidePlatform?,
    verdict: verdict == _unset ? this.verdict : verdict as RideVerdict?,
  );
}

const Object _unset = Object();

/// T09 — Histórico de corridas avaliadas.
class HistoryScreen extends ConsumerStatefulWidget {
  /// Cria a tela.
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  HistoryFilter _filter = const HistoryFilter();

  @override
  Widget build(BuildContext context) {
    final rides = ref.watch(recentRidesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        actions: [
          if (_filter.isActive)
            IconButton(
              onPressed: () => setState(() => _filter = const HistoryFilter()),
              icon: const Icon(Icons.filter_alt_off_rounded),
              tooltip: 'Limpar filtros',
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.readableWidth,
            ),
            child: Column(
              children: [
                _Filters(
                  filter: _filter,
                  onChanged: (f) => setState(() => _filter = f),
                ),
                Expanded(
                  child: switch (rides) {
                    AsyncValue(hasError: true) => const _Message(
                      icon: Icons.error_outline_rounded,
                      text: 'Não foi possível ler o histórico.',
                    ),
                    AsyncValue(:final value?) => _RideList(
                      rides: value.where(_filter.matches).toList(),
                      filtered: _filter.isActive,
                      total: value.length,
                    ),
                    _ => const Center(child: CircularProgressIndicator()),
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({required this.filter, required this.onChanged});

  final HistoryFilter filter;
  final ValueChanged<HistoryFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          for (final p in RidePlatform.values)
            if (p != RidePlatform.other)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(p.label),
                  selected: filter.platform == p,
                  onSelected: (selected) =>
                      onChanged(filter.copyWith(platform: selected ? p : null)),
                ),
              ),
          const SizedBox(width: 8),
          for (final v in RideVerdict.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                avatar: Icon(verdictIcon(v), size: 18),
                label: Text(v.label),
                selected: filter.verdict == v,
                onSelected: (selected) =>
                    onChanged(filter.copyWith(verdict: selected ? v : null)),
              ),
            ),
        ],
      ),
    );
  }
}

class _RideList extends StatelessWidget {
  const _RideList({
    required this.rides,
    required this.filtered,
    required this.total,
  });

  final List<RideEvaluation> rides;
  final bool filtered;
  final int total;

  @override
  Widget build(BuildContext context) {
    if (rides.isEmpty) {
      return _Message(
        icon: filtered ? Icons.filter_alt_off_rounded : Icons.route_outlined,
        text: filtered
            ? 'Nenhuma corrida com esses filtros.\n'
                  '$total no total do período.'
            : 'Nenhuma corrida avaliada ainda.\n'
                  'Use o simulador para registrar a primeira.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      itemCount: rides.length,
      itemBuilder: (context, index) => _RideTile(ride: rides[index]),
    );
  }
}

class _RideTile extends StatelessWidget {
  const _RideTile({required this.ride});

  final RideEvaluation ride;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final offer = ride.offer;
    final palette = VerdictPalette.of(context, ride.verdict);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      Fmt.money(offer.fare),
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  SemaphoreBadge(verdict: ride.verdict, compact: true),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${_formatDateTime(offer.capturedAt)} · '
                '${offer.platform.label} · '
                '${Fmt.km(offer.totalKm)} · '
                '${Fmt.minutes(offer.totalMinutes)}',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _Metric(
                    label: r'R$/km',
                    value: Fmt.perKm(ride.rsPerKm),
                    color: palette.text,
                  ),
                  _Metric(label: r'R$/h', value: Fmt.perHour(ride.rsPerHour)),
                  _Metric(
                    label: 'Lucro',
                    value: Fmt.money(ride.realProfit),
                    color: ride.isLoss ? theme.semaphore.stopText : null,
                  ),
                  _Metric(label: 'Desfecho', value: ride.outcome.label),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime value) {
    final local = value.toLocal();
    return '${local.day.toString().padLeft(2, '0')}/'
        '${local.month.toString().padLeft(2, '0')} '
        '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodySmall),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.labelLarge?.copyWith(color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
