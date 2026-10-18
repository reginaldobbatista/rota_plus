import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:rota_plus/app/theme/breakpoints.dart';
import 'package:rota_plus/core/money/money_input.dart';
import 'package:rota_plus/features/expenses/domain/entities/expense.dart';

/// Dados preenchidos no formulário de despesa.
@immutable
final class ExpenseDraft {
  /// Cria o rascunho.
  const ExpenseDraft({
    required this.category,
    required this.amount,
    required this.occurredAt,
    this.liters,
    this.odometerKm,
    this.description,
  });

  /// Categoria escolhida.
  final ExpenseCategory category;

  /// Valor informado.
  final Decimal amount;

  /// Momento da despesa.
  final DateTime occurredAt;

  /// Litros, quando abastecimento.
  final Decimal? liters;

  /// Odômetro, quando abastecimento.
  final Decimal? odometerKm;

  /// Descrição livre.
  final String? description;
}

/// Formulário de despesa, usado para criar e para editar.
///
/// Rola e respeita o teclado: a variante de abastecimento tem seis campos e,
/// sem isso, metade fica inacessível em tela pequena.
class ExpenseForm extends StatefulWidget {
  /// Cria o formulário.
  const ExpenseForm({required this.onSubmit, this.initial, super.key});

  /// Chamado com o rascunho válido.
  final void Function(ExpenseDraft draft) onSubmit;

  /// Despesa a editar. Nulo para criação.
  final Expense? initial;

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amount;
  late final TextEditingController _liters;
  late final TextEditingController _odometer;
  late final TextEditingController _description;

  late ExpenseCategory _category;
  late DateTime _occurredAt;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _category = initial?.category ?? ExpenseCategory.fuel;
    _occurredAt = initial?.occurredAt ?? DateTime.now();
    _amount = TextEditingController(
      text: initial == null ? '' : initial.amount.toString(),
    );
    _liters = TextEditingController(text: initial?.liters?.toString() ?? '');
    _odometer = TextEditingController(
      text: initial?.odometerKm?.toString() ?? '',
    );
    _description = TextEditingController(text: initial?.description ?? '');
  }

  @override
  void dispose() {
    _amount.dispose();
    _liters.dispose();
    _odometer.dispose();
    _description.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final amount = MoneyInput.tryParse(_amount.text)!;
    final tracksVolume = _category.tracksFuelVolume;

    widget.onSubmit(
      ExpenseDraft(
        category: _category,
        amount: amount,
        occurredAt: _occurredAt,
        liters: tracksVolume ? MoneyInput.tryParse(_liters.text) : null,
        odometerKm: tracksVolume ? MoneyInput.tryParse(_odometer.text) : null,
        description: _description.text.trim().isEmpty
            ? null
            : _description.text.trim(),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _occurredAt,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked == null) return;
    setState(() {
      _occurredAt = DateTime(
        picked.year,
        picked.month,
        picked.day,
        _occurredAt.hour,
        _occurredAt.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final tracksVolume = _category.tracksFuelVolume;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          // Deixa o último campo acima do teclado.
          bottom: 20 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.readableWidth,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.initial == null ? 'Nova despesa' : 'Editar despesa',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<ExpenseCategory>(
                  initialValue: _category,
                  // Sem isExpanded, o rótulo longo ("Estacionamento") estoura
                  // para a direita quando o usuário aumenta a fonte.
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Categoria'),
                  items: [
                    for (final c in ExpenseCategory.values)
                      DropdownMenuItem(value: c, child: Text(c.label)),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _category = value);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amount,
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                    prefixText: r'R$ ',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.next,
                  autofocus: widget.initial == null,
                  validator: (value) {
                    final parsed = MoneyInput.tryParse(value ?? '');
                    if (parsed == null) return 'Informe um valor válido';
                    if (parsed == Decimal.zero) {
                      return 'O valor precisa ser maior que zero';
                    }
                    return null;
                  },
                ),
                if (tracksVolume) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _liters,
                    decoration: const InputDecoration(
                      labelText: 'Litros (opcional)',
                      helperText: 'Permite aferir o consumo real do veículo',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return null;
                      return MoneyInput.tryParse(value) == null
                          ? 'Valor inválido'
                          : null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _odometer,
                    decoration: const InputDecoration(
                      labelText: 'Odômetro (opcional)',
                      suffixText: 'km',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return null;
                      return MoneyInput.tryParse(value) == null
                          ? 'Valor inválido'
                          : null;
                    },
                  ),
                ],
                const SizedBox(height: 16),
                TextFormField(
                  controller: _description,
                  decoration: const InputDecoration(
                    labelText: 'Descrição (opcional)',
                  ),
                  maxLength: 120,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 4),
                // Wrap em vez de ListTile/Row: com fonte grande o rótulo e o
                // botão deixam de caber na mesma linha e precisam quebrar, em
                // vez de estourar.
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: [
                    const Icon(Icons.event_rounded, size: 20),
                    Text('Data: ${_formatDate(_occurredAt)}'),
                    TextButton(
                      onPressed: _pickDate,
                      child: const Text('Alterar'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}/'
      '${value.month.toString().padLeft(2, '0')}/${value.year}';
}
