import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota_plus/app/providers.dart';
import 'package:rota_plus/app/theme/breakpoints.dart';
import 'package:rota_plus/core/formatters/formatters.dart';
import 'package:rota_plus/core/money/money_input.dart';
import 'package:rota_plus/features/vehicle/data/repositories/config_repository.dart';
import 'package:rota_plus/features/vehicle/domain/entities/cost_parameters.dart';
import 'package:rota_plus/features/vehicle/domain/entities/work_profile.dart';
import 'package:rota_plus/features/vehicle/domain/usecases/calculate_cost_per_km.dart';
import 'package:rota_plus/shared/widgets/decimal_field.dart';
import 'package:rota_plus/shared/widgets/metric_card.dart';

/// T06 — Configuração do veículo e dos custos.
///
/// É a tela que torna o veredicto do semáforo confiável: tudo aqui alimenta o
/// custo por km, que é o piso abaixo do qual a corrida dá prejuízo.
class VehicleScreen extends ConsumerStatefulWidget {
  /// Cria a tela.
  const VehicleScreen({this.vehicleClientId, super.key});

  /// Veículo a editar. Nulo para cadastrar o primeiro.
  final String? vehicleClientId;

  @override
  ConsumerState<VehicleScreen> createState() => _VehicleScreenState();
}

class _VehicleScreenState extends ConsumerState<VehicleScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nickname = TextEditingController(text: 'Meu carro');
  final _make = TextEditingController();
  final _model = TextEditingController();
  final _year = TextEditingController();
  final _plateSuffix = TextEditingController();
  final _consumption = TextEditingController();
  final _fuelPrice = TextEditingController();
  final _marketValue = TextEditingController();
  final _depreciation = TextEditingController();
  final _genericMaintenance = TextEditingController();
  final _workDays = TextEditingController();
  final _kmPerDay = TextEditingController();

  FuelType _fuel = FuelType.flex;
  final List<_CostRow> _maintenance = [];
  final List<_CostRow> _fixedCosts = [];

  String? _clientId;
  bool _loaded = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _applyDefaults();
    _loadExisting();
  }

  void _applyDefaults() {
    _consumption.text = VehicleDefaults.consumption.toString();
    _fuelPrice.text = VehicleDefaults.fuelPrice.toString();
    _depreciation.text = VehicleDefaults.depreciationPerKm.toString();
    _genericMaintenance.text = VehicleDefaults.genericMaintenancePerKm
        .toString();
    _workDays.text = '${VehicleDefaults.workDaysPerMonth}';
    _kmPerDay.text = VehicleDefaults.kmPerDay.toString();
  }

  Future<void> _loadExisting() async {
    final id = widget.vehicleClientId;
    if (id == null) {
      setState(() => _loaded = true);
      return;
    }

    final repo = ref.read(configRepositoryProvider);
    final vehicles = await repo.listVehicles();
    final existing = vehicles.where((v) => v.clientId == id).firstOrNull;
    final params = await repo.findCostParameters(id);

    if (!mounted || existing == null || params == null) {
      if (mounted) setState(() => _loaded = true);
      return;
    }

    setState(() {
      _clientId = id;
      _nickname.text = existing.nickname;
      _make.text = existing.make ?? '';
      _model.text = existing.model ?? '';
      _year.text = existing.modelYear?.toString() ?? '';
      _plateSuffix.text = existing.plateSuffix ?? '';
      _fuel = existing.fuel;
      _consumption.text = existing.consumption.toString();
      _fuelPrice.text = existing.fuelPrice.toString();
      _marketValue.text = existing.marketValue?.toString() ?? '';
      _depreciation.text = existing.depreciationPerKm.toString();
      _genericMaintenance.text = existing.genericMaintenancePerKm.toString();
      _workDays.text = '${existing.workDaysPerMonth}';
      _kmPerDay.text = existing.kmPerDay.toString();
      _maintenance
        ..clear()
        ..addAll(
          params.maintenanceItems.map(
            (i) => _CostRow.maintenance(
              label: i.label,
              amount: i.cost,
              interval: i.intervalKm,
            ),
          ),
        );
      _fixedCosts
        ..clear()
        ..addAll(
          params.fixedCosts.map(
            (c) => _CostRow.fixed(label: c.label, amount: c.monthlyAmount),
          ),
        );
      _loaded = true;
    });
  }

  @override
  void dispose() {
    for (final c in [
      _nickname,
      _make,
      _model,
      _year,
      _plateSuffix,
      _consumption,
      _fuelPrice,
      _marketValue,
      _depreciation,
      _genericMaintenance,
      _workDays,
      _kmPerDay,
    ]) {
      c.dispose();
    }
    for (final row in [..._maintenance, ..._fixedCosts]) {
      row.dispose();
    }
    super.dispose();
  }

  /// Monta os parâmetros a partir do que está digitado agora.
  ///
  /// Serve tanto para o preview ao vivo quanto para salvar, o que garante que
  /// o número mostrado é exatamente o que será gravado.
  CostParameters? _currentParameters() {
    final consumption = DecimalField.read(_consumption);
    final fuelPrice = DecimalField.read(_fuelPrice);
    final kmPerDay = DecimalField.read(_kmPerDay);
    final workDays = int.tryParse(_workDays.text.trim());

    if (consumption == null ||
        fuelPrice == null ||
        kmPerDay == null ||
        workDays == null ||
        consumption == Decimal.zero ||
        kmPerDay == Decimal.zero ||
        workDays == 0) {
      return null;
    }

    return CostParameters(
      fuelType: _fuel,
      fuelPrice: fuelPrice,
      consumption: consumption,
      depreciationPerKm: DecimalField.read(_depreciation),
      genericMaintenancePerKm: DecimalField.read(_genericMaintenance),
      workDaysPerMonth: workDays,
      kmPerDay: kmPerDay,
      maintenanceItems: [for (final row in _maintenance) ?row.toMaintenance()],
      fixedCosts: [for (final row in _fixedCosts) ?row.toFixedCost()],
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final params = _currentParameters();
    if (params == null) return;

    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final repo = ref.read(configRepositoryProvider);

    try {
      final savedId = await repo.saveVehicle(
        vehicle: Vehicle(
          clientId: _clientId,
          nickname: _nickname.text.trim(),
          make: _emptyToNull(_make.text),
          model: _emptyToNull(_model.text),
          modelYear: int.tryParse(_year.text.trim()),
          plateSuffix: _emptyToNull(_plateSuffix.text)?.toUpperCase(),
          fuel: _fuel,
          consumption: params.consumption,
          fuelPrice: params.fuelPrice,
          marketValue: DecimalField.read(_marketValue),
          depreciationPerKm: params.depreciationPerKm,
          genericMaintenancePerKm: params.genericMaintenancePerKm,
          workDaysPerMonth: params.workDaysPerMonth,
          kmPerDay: params.kmPerDay,
        ),
        maintenance: params.maintenanceItems,
        fixedCosts: params.fixedCosts,
      );

      // Primeiro veículo do motorista: cria o perfil inicial e o associa,
      // senão o app teria custo cadastrado mas continuaria sem metas.
      final profiles = await repo.listProfiles();
      if (profiles.isEmpty) {
        await repo.saveProfile(
          WorkProfile.initial(name: 'Padrão', vehicleClientId: savedId),
        );
      } else if (profiles.every((p) => p.vehicleClientId == null)) {
        await repo.saveProfile(
          profiles.first.copyWith(vehicleClientId: savedId),
        );
      }

      if (!mounted) return;
      messenger.showSnackBar(const SnackBar(content: Text('Veículo salvo.')));
      Navigator.of(context).maybePop();
    } on ConfigFailure catch (failure) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(failure.message)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  static String? _emptyToNull(String value) =>
      value.trim().isEmpty ? null : value.trim();

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final params = _currentParameters();
    final breakdown = params == null
        ? null
        : const CalculateCostPerKm()(params);

    return Scaffold(
      appBar: AppBar(
        title: Text(_clientId == null ? 'Cadastrar veículo' : 'Meu veículo'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          onChanged: () => setState(() {}),
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
                      _CostPreview(breakdown: breakdown),

                      const FormSectionHeader(
                        title: 'Identificação',
                        subtitle: 'Só para você reconhecer o veículo na lista.',
                      ),
                      LabeledField(
                        controller: _nickname,
                        label: 'Apelido',
                        required: true,
                        maxLength: 60,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: LabeledField(
                              controller: _make,
                              label: 'Marca',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: LabeledField(
                              controller: _model,
                              label: 'Modelo',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: LabeledField(
                              controller: _year,
                              label: 'Ano',
                              maxLength: 4,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: LabeledField(
                              controller: _plateSuffix,
                              label: 'Final da placa',
                              maxLength: 4,
                            ),
                          ),
                        ],
                      ),

                      const FormSectionHeader(
                        title: 'Combustível',
                        subtitle:
                            'A maior parcela do custo. Atualize o preço quando '
                            'ele mudar no posto.',
                      ),
                      DropdownButtonFormField<FuelType>(
                        initialValue: _fuel,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: 'Tipo'),
                        items: [
                          for (final f in FuelType.values)
                            DropdownMenuItem(value: f, child: Text(f.label)),
                        ],
                        onChanged: (value) {
                          if (value != null) setState(() => _fuel = value);
                        },
                      ),
                      const SizedBox(height: 12),
                      DecimalField(
                        controller: _consumption,
                        label: 'Consumo médio',
                        suffix: _fuel.consumptionUnit,
                      ),
                      const SizedBox(height: 12),
                      DecimalField(
                        controller: _fuelPrice,
                        label: _fuel == FuelType.electric
                            ? 'Preço do kWh'
                            : 'Preço do litro',
                        prefix: r'R$ ',
                      ),

                      const FormSectionHeader(
                        title: 'Manutenção',
                        subtitle:
                            'Cada item é rateado pelo intervalo de troca. O que '
                            'você não detalhar, cubra no valor genérico.',
                      ),
                      _CostList(
                        rows: _maintenance,
                        isMaintenance: true,
                        onAdd: () => setState(
                          () => _maintenance.add(_CostRow.maintenance()),
                        ),
                        onRemove: (row) => setState(() {
                          _maintenance.remove(row);
                          row.dispose();
                        }),
                      ),
                      const SizedBox(height: 12),
                      DecimalField(
                        controller: _genericMaintenance,
                        label: 'Manutenção genérica',
                        prefix: r'R$ ',
                        suffix: '/ km',
                        required: false,
                        allowZero: true,
                      ),

                      const FormSectionHeader(
                        title: 'Depreciação',
                        subtitle:
                            'Quanto o veículo perde de valor a cada km rodado. '
                            'É custo real, mesmo sem sair do bolso hoje.',
                      ),
                      DecimalField(
                        controller: _marketValue,
                        label: 'Valor de mercado (FIPE)',
                        prefix: r'R$ ',
                        required: false,
                      ),
                      const SizedBox(height: 12),
                      DecimalField(
                        controller: _depreciation,
                        label: 'Depreciação por km',
                        prefix: r'R$ ',
                        suffix: '/ km',
                        required: false,
                        allowZero: true,
                      ),

                      const FormSectionHeader(
                        title: 'Custos fixos',
                        subtitle:
                            'Rateados pela quilometragem do mês. Informe o '
                            'valor mensal.',
                      ),
                      _CostList(
                        rows: _fixedCosts,
                        isMaintenance: false,
                        onAdd: () =>
                            setState(() => _fixedCosts.add(_CostRow.fixed())),
                        onRemove: (row) => setState(() {
                          _fixedCosts.remove(row);
                          row.dispose();
                        }),
                      ),

                      const FormSectionHeader(
                        title: 'Seu ritmo de trabalho',
                        subtitle:
                            'Base do rateio: quanto mais você roda, menor o '
                            'peso dos custos fixos em cada km.',
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: LabeledField(
                              controller: _workDays,
                              label: 'Dias por mês',
                              required: true,
                              maxLength: 2,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DecimalField(
                              controller: _kmPerDay,
                              label: 'Km por dia',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
                      FilledButton.icon(
                        onPressed: _saving ? null : _save,
                        icon: _saving
                            ? const SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.check_rounded),
                        label: Text(_saving ? 'Salvando…' : 'Salvar veículo'),
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

/// Resumo do custo por km, recalculado a cada digitação.
///
/// Mostrar o efeito imediato é o que faz o motorista entender que o número
/// não é mágico: é a soma do que ele próprio informou.
class _CostPreview extends StatelessWidget {
  const _CostPreview({required this.breakdown});

  final CostBreakdown? breakdown;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = breakdown;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Seu custo por quilômetro', style: theme.textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(
              data == null ? '—' : '${Fmt.perKm(data.totalPerKm)} / km',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            if (data == null)
              Text(
                'Preencha consumo, preço e ritmo de trabalho para calcular.',
                style: theme.textTheme.bodySmall,
              )
            else
              MetricGrid(
                cells: [
                  MetricCell(
                    label: 'Combustível',
                    value: Fmt.perKm(data.fuelPerKm),
                  ),
                  MetricCell(
                    label: 'Manutenção',
                    value: Fmt.perKm(data.maintenancePerKm),
                  ),
                  MetricCell(
                    label: 'Depreciação',
                    value: Fmt.perKm(data.depreciationPerKm),
                  ),
                  MetricCell(label: 'Fixos', value: Fmt.perKm(data.fixedPerKm)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Lista editável de custos (manutenção ou fixos).
class _CostList extends StatelessWidget {
  const _CostList({
    required this.rows,
    required this.isMaintenance,
    required this.onAdd,
    required this.onRemove,
  });

  final List<_CostRow> rows;
  final bool isMaintenance;
  final VoidCallback onAdd;
  final void Function(_CostRow row) onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final row in rows) ...[
          _CostRowFields(
            row: row,
            isMaintenance: isMaintenance,
            onRemove: () => onRemove(row),
          ),
          const SizedBox(height: 12),
        ],
        OutlinedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add_rounded),
          label: Text(
            isMaintenance ? 'Adicionar item' : 'Adicionar custo fixo',
          ),
        ),
      ],
    );
  }
}

class _CostRowFields extends StatelessWidget {
  const _CostRowFields({
    required this.row,
    required this.isMaintenance,
    required this.onRemove,
  });

  final _CostRow row;
  final bool isMaintenance;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: LabeledField(
                    controller: row.label,
                    label: isMaintenance ? 'Item' : 'Descrição',
                    maxLength: 40,
                  ),
                ),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.close_rounded),
                  tooltip: 'Remover',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                children: [
                  Expanded(
                    child: DecimalField(
                      controller: row.amount,
                      label: isMaintenance ? 'Custo' : 'Valor mensal',
                      prefix: r'R$ ',
                      required: false,
                    ),
                  ),
                  if (isMaintenance) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: DecimalField(
                        controller: row.interval!,
                        label: 'A cada',
                        suffix: 'km',
                        required: false,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Linha editável de custo, com seus próprios controladores.
class _CostRow {
  _CostRow.maintenance({String? label, Decimal? amount, Decimal? interval})
    : label = TextEditingController(text: label ?? ''),
      amount = TextEditingController(text: amount?.toString() ?? ''),
      interval = TextEditingController(text: interval?.toString() ?? '');

  _CostRow.fixed({String? label, Decimal? amount})
    : label = TextEditingController(text: label ?? ''),
      amount = TextEditingController(text: amount?.toString() ?? ''),
      interval = null;

  final TextEditingController label;
  final TextEditingController amount;
  final TextEditingController? interval;

  /// Converte para item de manutenção, ou `null` se incompleto.
  ///
  /// Linha pela metade é descartada em silêncio: o motorista está digitando, e
  /// bloquear o salvamento por um campo em branco que ele ia preencher depois
  /// seria atrapalhar.
  MaintenanceItem? toMaintenance() {
    final cost = MoneyInput.tryParse(amount.text);
    final km = MoneyInput.tryParse(interval?.text ?? '');
    final name = label.text.trim();

    if (cost == null || km == null || km == Decimal.zero || name.isEmpty) {
      return null;
    }
    return MaintenanceItem(label: name, cost: cost, intervalKm: km);
  }

  /// Converte para custo fixo mensal, ou `null` se incompleto.
  FixedCost? toFixedCost() {
    final value = MoneyInput.tryParse(amount.text);
    final name = label.text.trim();

    if (value == null || name.isEmpty) return null;
    return FixedCost.monthly(label: name, amount: value);
  }

  void dispose() {
    label.dispose();
    amount.dispose();
    interval?.dispose();
  }
}
