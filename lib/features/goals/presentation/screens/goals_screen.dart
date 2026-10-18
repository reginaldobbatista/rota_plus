import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota_plus/app/providers.dart';
import 'package:rota_plus/app/theme/breakpoints.dart';
import 'package:rota_plus/core/formatters/formatters.dart';
import 'package:rota_plus/features/goals/domain/entities/work_goals.dart';
import 'package:rota_plus/features/vehicle/data/repositories/config_repository.dart';
import 'package:rota_plus/features/vehicle/domain/entities/work_profile.dart';
import 'package:rota_plus/shared/widgets/decimal_field.dart';

/// T07 — Metas do perfil de trabalho.
///
/// São os critérios que o semáforo usa para dizer aceitar, pensar ou recusar.
class GoalsScreen extends ConsumerStatefulWidget {
  /// Cria a tela.
  const GoalsScreen({this.profileClientId, super.key});

  /// Perfil a editar. Nulo edita o perfil em uso.
  final String? profileClientId;

  @override
  ConsumerState<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends ConsumerState<GoalsScreen> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _rsPerKm = TextEditingController();
  final _rsPerHour = TextEditingController();
  final _maxPickupKm = TextEditingController();
  final _dailyGoal = TextEditingController();
  final _monthlyGoal = TextEditingController();

  double _minRating = 4.5;
  double _tolerance = 15;
  double _margin = 30;

  WorkProfile? _profile;
  bool _loaded = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(configRepositoryProvider);
    final profiles = await repo.listProfiles();

    final target = widget.profileClientId == null
        ? profiles.where((p) => p.isActive).firstOrNull
        : profiles
              .where((p) => p.clientId == widget.profileClientId)
              .firstOrNull;

    if (!mounted) return;

    if (target == null) {
      setState(() => _loaded = true);
      return;
    }

    setState(() {
      _profile = target;
      _name.text = target.name;
      _rsPerKm.text = target.goals.minRsPerKm.toString();
      _rsPerHour.text = target.goals.minRsPerHour.toString();
      _maxPickupKm.text = target.goals.maxPickupKm.toString();
      _dailyGoal.text = target.dailyRevenueGoal.toString();
      _monthlyGoal.text = target.monthlyRevenueGoal.toString();
      _minRating = target.goals.minPassengerRating;
      _tolerance = target.goals.thinkTolerancePercent.toDouble();
      _margin = target.targetMarginPercent.toDouble();
      _loaded = true;
    });
  }

  @override
  void dispose() {
    for (final c in [
      _name,
      _rsPerKm,
      _rsPerHour,
      _maxPickupKm,
      _dailyGoal,
      _monthlyGoal,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final base = _profile;
    if (base == null) return;

    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);

    try {
      await ref
          .read(configRepositoryProvider)
          .saveProfile(
            base.copyWith(
              name: _name.text.trim(),
              goals: WorkGoals(
                minRsPerKm: DecimalField.read(_rsPerKm)!,
                minRsPerHour: DecimalField.read(_rsPerHour)!,
                minPassengerRating: _minRating,
                maxPickupKm: DecimalField.read(_maxPickupKm)!,
                thinkTolerancePercent: Decimal.parse(
                  _tolerance.toStringAsFixed(0),
                ),
              ),
              dailyRevenueGoal: DecimalField.read(_dailyGoal) ?? Decimal.zero,
              monthlyRevenueGoal:
                  DecimalField.read(_monthlyGoal) ?? Decimal.zero,
              targetMarginPercent: Decimal.parse(_margin.toStringAsFixed(0)),
            ),
          );

      if (!mounted) return;
      messenger.showSnackBar(const SnackBar(content: Text('Metas salvas.')));
      Navigator.of(context).maybePop();
    } on ConfigFailure catch (failure) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(failure.message)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_profile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Metas')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Text(
              'Cadastre um veículo primeiro. As metas pertencem a um perfil '
              'de trabalho, e o perfil precisa de um veículo para calcular o '
              'custo.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final costPerKm = ref.watch(costPerKmProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Metas')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 32 + MediaQuery.viewInsetsOf(context).bottom,
            ),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: Breakpoints.readableWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (costPerKm > Decimal.zero)
                        _FloorHint(costPerKm: costPerKm, margin: _margin),

                      const FormSectionHeader(title: 'Perfil'),
                      LabeledField(
                        controller: _name,
                        label: 'Nome do perfil',
                        required: true,
                        maxLength: 60,
                      ),

                      const FormSectionHeader(
                        title: 'Critérios do semáforo',
                        subtitle:
                            'Acima das duas metas o cartão fica verde. Abaixo '
                            'do seu custo, vermelho.',
                      ),
                      DecimalField(
                        controller: _rsPerKm,
                        label: r'Meta de R$ por km',
                        prefix: r'R$ ',
                        suffix: '/ km',
                      ),
                      const SizedBox(height: 12),
                      DecimalField(
                        controller: _rsPerHour,
                        label: r'Meta de R$ por hora',
                        prefix: r'R$ ',
                        suffix: '/ h',
                      ),
                      const SizedBox(height: 12),
                      DecimalField(
                        controller: _maxPickupKm,
                        label: 'Distância máxima até o embarque',
                        suffix: 'km',
                      ),

                      const FormSectionHeader(
                        title: 'Critérios eliminatórios',
                        subtitle:
                            'Não admitem tolerância: violou, o cartão é '
                            'vermelho mesmo com métricas boas.',
                      ),
                      _SliderTile(
                        label: 'Nota mínima do passageiro',
                        value: _minRating,
                        min: 1,
                        max: 5,
                        divisions: 40,
                        display: Fmt.rating(_minRating),
                        onChanged: (v) => setState(() => _minRating = v),
                      ),

                      const FormSectionHeader(
                        title: 'Zona amarela',
                        subtitle:
                            'Quanto a corrida pode ficar abaixo da meta e '
                            'ainda valer a pena avaliar.',
                      ),
                      _SliderTile(
                        label: 'Tolerância do PENSE',
                        value: _tolerance,
                        min: 0,
                        max: 40,
                        divisions: 40,
                        display: '${_tolerance.round()}%',
                        onChanged: (v) => setState(() => _tolerance = v),
                      ),
                      _SliderTile(
                        label: 'Margem desejada sobre o custo',
                        value: _margin,
                        min: 0,
                        max: 100,
                        divisions: 20,
                        display: '${_margin.round()}%',
                        onChanged: (v) => setState(() => _margin = v),
                      ),

                      const FormSectionHeader(
                        title: 'Metas de faturamento',
                        subtitle: 'Acompanhadas no dashboard e no fechamento.',
                      ),
                      DecimalField(
                        controller: _dailyGoal,
                        label: 'Meta diária',
                        prefix: r'R$ ',
                        required: false,
                        allowZero: true,
                      ),
                      const SizedBox(height: 12),
                      DecimalField(
                        controller: _monthlyGoal,
                        label: 'Meta mensal',
                        prefix: r'R$ ',
                        required: false,
                        allowZero: true,
                      ),

                      const SizedBox(height: 32),
                      FilledButton.icon(
                        onPressed: _saving ? null : _save,
                        icon: const Icon(Icons.check_rounded),
                        label: Text(_saving ? 'Salvando…' : 'Salvar metas'),
                      ),
                    ],
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

/// Lembra ao motorista qual é o piso real, dado o custo do veículo dele.
class _FloorHint extends StatelessWidget {
  const _FloorHint({required this.costPerKm, required this.margin});

  final Decimal costPerKm;
  final double margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final suggested = const CalculateCostPerKmFloor().suggest(
      costPerKm: costPerKm,
      marginPercent: margin,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seu custo é ${Fmt.perKm(costPerKm)} por km',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              'Com ${margin.round()}% de margem, a meta deveria ser pelo menos '
              '${Fmt.perKm(suggested)} por km. Abaixo do custo, a corrida dá '
              'prejuízo mesmo que o valor pareça bom.',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

/// Calcula a tarifa mínima sugerida a partir do custo e da margem.
class CalculateCostPerKmFloor {
  /// Cria o utilitário.
  const CalculateCostPerKmFloor();

  /// Retorna o piso sugerido de R$/km.
  Decimal suggest({required Decimal costPerKm, required double marginPercent}) {
    final multiplier =
        Decimal.one +
        (Decimal.parse(marginPercent.toStringAsFixed(0)) / Decimal.fromInt(100))
            .toDecimal(scaleOnInfinitePrecision: 4);
    return (costPerKm * multiplier).round(scale: 2);
  }
}

class _SliderTile extends StatelessWidget {
  const _SliderTile({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.display,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String display;
  final ValueChanged<double> onChanged;

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
          semanticFormatterCallback: (_) => '$label: $display',
        ),
      ],
    );
  }
}
