import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:rota_plus/core/money/money_input.dart';

/// Campo de entrada numérica em pt-BR.
///
/// Usa o mesmo parser do registro de despesas: aceita `12,50`, `12.50` e
/// `1.234,56`. Assumir ponto como separador decimal faria `84.000` virar
/// oitenta e quatro — num campo de odômetro ou de valor FIPE isso é erro de
/// três ordens de grandeza.
class DecimalField extends StatelessWidget {
  /// Cria o campo.
  const DecimalField({
    required this.controller,
    required this.label,
    this.prefix,
    this.suffix,
    this.helper,
    this.required = true,
    this.allowZero = false,
    this.onChanged,
    super.key,
  });

  /// Controlador do texto.
  final TextEditingController controller;

  /// Rótulo do campo.
  final String label;

  /// Prefixo, por exemplo `R$ `.
  final String? prefix;

  /// Sufixo, por exemplo `km/l`.
  final String? suffix;

  /// Texto de apoio abaixo do campo.
  final String? helper;

  /// Indica se o preenchimento é obrigatório.
  final bool required;

  /// Indica se zero é um valor aceitável.
  final bool allowZero;

  /// Chamado a cada alteração válida.
  final ValueChanged<Decimal?>? onChanged;

  /// Lê o valor atual do controlador.
  static Decimal? read(TextEditingController controller) =>
      MoneyInput.tryParse(controller.text);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefix,
        suffixText: suffix,
        helperText: helper,
        helperMaxLines: 2,
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.next,
      onChanged: (value) => onChanged?.call(MoneyInput.tryParse(value)),
      validator: (value) {
        final text = value?.trim() ?? '';
        if (text.isEmpty) return required ? 'Informe um valor' : null;

        final parsed = MoneyInput.tryParse(text);
        if (parsed == null) return 'Valor inválido';
        if (!allowZero && parsed == Decimal.zero) {
          return 'Precisa ser maior que zero';
        }
        return null;
      },
    );
  }
}

/// Campo de texto simples com rótulo, para dados de identificação.
class LabeledField extends StatelessWidget {
  /// Cria o campo.
  const LabeledField({
    required this.controller,
    required this.label,
    this.required = false,
    this.maxLength,
    this.keyboardType,
    super.key,
  });

  /// Controlador do texto.
  final TextEditingController controller;

  /// Rótulo do campo.
  final String label;

  /// Indica se o preenchimento é obrigatório.
  final bool required;

  /// Limite de caracteres.
  final int? maxLength;

  /// Tipo de teclado.
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, counterText: ''),
      maxLength: maxLength,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      validator: required
          ? (value) =>
                (value?.trim().isEmpty ?? true) ? 'Campo obrigatório' : null
          : null,
    );
  }
}

/// Cabeçalho de seção dentro de um formulário longo.
class FormSectionHeader extends StatelessWidget {
  /// Cria o cabeçalho.
  const FormSectionHeader({required this.title, this.subtitle, super.key});

  /// Título da seção.
  final String title;

  /// Explicação curta do que a seção afeta.
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          if (subtitle case final text?) ...[
            const SizedBox(height: 4),
            Text(text, style: theme.textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}
