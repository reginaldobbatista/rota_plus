import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota_plus/app/providers.dart';
import 'package:rota_plus/app/theme/breakpoints.dart';
import 'package:rota_plus/core/formatters/formatters.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_evaluation.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_offer.dart';
import 'package:rota_plus/features/semaphore/presentation/widgets/ride_verdict_card.dart';

/// Simulador do semáforo.
///
/// Serve dois propósitos: permite ao motorista calibrar metas vendo o efeito
/// imediato, e é o modo de contingência previsto no descritivo caso a
/// permissão de acessibilidade seja revogada pelo Google Play.
class SimulatorScreen extends ConsumerStatefulWidget {
  /// Cria a tela.
  const SimulatorScreen({super.key});

  @override
  ConsumerState<SimulatorScreen> createState() => _SimulatorScreenState();
}

class _SimulatorScreenState extends ConsumerState<SimulatorScreen> {
  RidePlatform _platform = RidePlatform.uber;
  double _fare = 20;
  double _pickupKm = 2;
  double _tripKm = 8;
  double _pickupMinutes = 6;
  double _tripMinutes = 18;
  double _rating = 4.8;

  RideOffer get _offer => RideOffer(
    platform: _platform,
    fare: Decimal.parse(_fare.toStringAsFixed(2)),
    pickupKm: Decimal.parse(_pickupKm.toStringAsFixed(1)),
    tripKm: Decimal.parse(_tripKm.toStringAsFixed(1)),
    pickupMinutes: _pickupMinutes,
    tripMinutes: _tripMinutes,
    passengerRating: _rating,
    pickupRegion: 'Centro',
    capturedAt: DateTime.now(),
  );

  /// Grava a avaliação no banco local e enfileira o envio.
  ///
  /// A escrita não espera a rede: o retorno é imediato e o outbox cuida do
  /// resto. É o mesmo caminho que o overlay vai usar.
  Future<void> _record(RideEvaluation evaluation, RideOutcome outcome) async {
    final messenger = ScaffoldMessenger.of(context);
    await ref
        .read(rideHistoryRepositoryProvider)
        .record(evaluation, outcome: outcome);

    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(content: Text('Corrida registrada como ${outcome.label}.')),
    );
  }

  /// Fala o veredicto, como o overlay fará quando existir.
  ///
  /// Aqui serve para o motorista conferir volume e velocidade antes de
  /// depender disso dirigindo.
  Future<void> _announce(RideEvaluation evaluation) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(ttsServiceProvider).announce(evaluation);
    } on Object {
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('A voz não está disponível no aparelho.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sem perfil cadastrado não há metas, e sem metas não há veredicto.
    final evaluation = ref.watch(evaluateRideProvider)?.call(_offer);
    final costPerKm = ref.watch(costPerKmProvider);

    final card = evaluation == null
        ? const _EmptyCard()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RideVerdictCard(evaluation: evaluation),
              const SizedBox(height: 12),
              _RecordActions(
                onRecord: (outcome) => _record(evaluation, outcome),
                onAnnounce: () => _announce(evaluation),
              ),
            ],
          );

    final controls = _Controls(
      platform: _platform,
      fare: _fare,
      pickupKm: _pickupKm,
      tripKm: _tripKm,
      pickupMinutes: _pickupMinutes,
      tripMinutes: _tripMinutes,
      rating: _rating,
      onPlatform: (v) => setState(() => _platform = v),
      onFare: (v) => setState(() => _fare = v),
      onPickupKm: (v) => setState(() => _pickupKm = v),
      onTripKm: (v) => setState(() => _tripKm = v),
      onPickupMinutes: (v) => setState(() => _pickupMinutes = v),
      onTripMinutes: (v) => setState(() => _tripMinutes = v),
      onRating: (v) => setState(() => _rating = v),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulador'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Custo ${Fmt.perKm(costPerKm)}/km',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Decide pelo espaço concedido, não pelo aparelho nem pela orientação.
            final wide = constraints.maxWidth >= Breakpoints.expanded;

            if (wide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: Breakpoints.readableWidth,
                        ),
                        child: controls,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Align(alignment: Alignment.topCenter, child: card),
                    ),
                  ),
                ],
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: Breakpoints.readableWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [card, const SizedBox(height: 24), controls],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Botões para registrar o desfecho da corrida simulada.
///
/// Registrar o desfecho é o que gera o dado mais valioso do produto: a
/// comparação entre o que o app recomendou e o que o motorista fez.
class _RecordActions extends StatelessWidget {
  const _RecordActions({required this.onRecord, required this.onAnnounce});

  final void Function(RideOutcome outcome) onRecord;
  final VoidCallback onAnnounce;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => onRecord(RideOutcome.accepted),
                icon: const Icon(Icons.check_rounded),
                label: const Text('Aceitei'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => onRecord(RideOutcome.rejected),
                icon: const Icon(Icons.close_rounded),
                label: const Text('Recusei'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: onAnnounce,
          icon: const Icon(Icons.volume_up_rounded),
          label: const Text('Ouvir o aviso'),
        ),
      ],
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Dados insuficientes para avaliar esta oferta.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({
    required this.platform,
    required this.fare,
    required this.pickupKm,
    required this.tripKm,
    required this.pickupMinutes,
    required this.tripMinutes,
    required this.rating,
    required this.onPlatform,
    required this.onFare,
    required this.onPickupKm,
    required this.onTripKm,
    required this.onPickupMinutes,
    required this.onTripMinutes,
    required this.onRating,
  });

  final RidePlatform platform;
  final double fare;
  final double pickupKm;
  final double tripKm;
  final double pickupMinutes;
  final double tripMinutes;
  final double rating;
  final ValueChanged<RidePlatform> onPlatform;
  final ValueChanged<double> onFare;
  final ValueChanged<double> onPickupKm;
  final ValueChanged<double> onTripKm;
  final ValueChanged<double> onPickupMinutes;
  final ValueChanged<double> onTripMinutes;
  final ValueChanged<double> onRating;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<RidePlatform>(
          segments: [
            for (final p in RidePlatform.values)
              if (p != RidePlatform.other)
                ButtonSegment(value: p, label: Text(p.label)),
          ],
          selected: {platform},
          onSelectionChanged: (s) => onPlatform(s.first),
          showSelectedIcon: false,
        ),
        const SizedBox(height: 8),
        _SliderRow(
          label: 'Valor da corrida',
          value: fare,
          min: 4,
          max: 200,
          display: Fmt.money(Decimal.parse(fare.toStringAsFixed(2))),
          onChanged: onFare,
        ),
        _SliderRow(
          label: 'Distância até o passageiro',
          value: pickupKm,
          min: 0,
          max: 20,
          display: '${pickupKm.toStringAsFixed(1)} km',
          onChanged: onPickupKm,
        ),
        _SliderRow(
          label: 'Distância da corrida',
          value: tripKm,
          min: 0.5,
          max: 60,
          display: '${tripKm.toStringAsFixed(1)} km',
          onChanged: onTripKm,
        ),
        _SliderRow(
          label: 'Tempo até o passageiro',
          value: pickupMinutes,
          min: 0,
          max: 40,
          display: Fmt.minutes(pickupMinutes),
          onChanged: onPickupMinutes,
        ),
        _SliderRow(
          label: 'Tempo da corrida',
          value: tripMinutes,
          min: 1,
          max: 120,
          display: Fmt.minutes(tripMinutes),
          onChanged: onTripMinutes,
        ),
        _SliderRow(
          label: 'Nota do passageiro',
          value: rating,
          min: 1,
          max: 5,
          divisions: 40,
          display: Fmt.rating(rating),
          onChanged: onRating,
        ),
      ],
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.display,
    required this.onChanged,
    this.divisions,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final String display;
  final ValueChanged<double> onChanged;
  final int? divisions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
            Text(
              display,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: divisions,
          label: display,
          onChanged: onChanged,
          semanticFormatterCallback: (v) => '$label: $display',
        ),
      ],
    );
  }
}
