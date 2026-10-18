import 'package:decimal/decimal.dart';

/// Interpretação de valor digitado pelo usuário em pt-BR.
abstract final class MoneyInput {
  /// Converte texto digitado em [Decimal], ou `null` se não for um valor.
  ///
  /// Aceita o que o motorista realmente digita: `12,50`, `12.50`, `R$ 12,50`,
  /// `1.234,56` e `1234.56`. Assumir ponto como separador decimal faria
  /// `1.234` virar R$ 1,23 em vez de R$ 1.234 — erro silencioso e caro num app
  /// financeiro.
  static Decimal? tryParse(String input) {
    var text = input.trim();
    if (text.isEmpty) return null;

    // Remove tudo que não é dígito, separador ou sinal.
    text = text.replaceAll(RegExp(r'[^\d,.\-]'), '');
    if (text.isEmpty || text == '-') return null;

    final lastComma = text.lastIndexOf(',');
    final lastDot = text.lastIndexOf('.');

    if (lastComma >= 0 && lastDot >= 0) {
      // Os dois presentes: o último é o separador decimal, o outro é milhar.
      if (lastComma > lastDot) {
        text = text.replaceAll('.', '').replaceFirst(',', '.');
      } else {
        text = text.replaceAll(',', '');
      }
    } else if (lastComma >= 0) {
      // Só vírgula: separador decimal em pt-BR, ou milhar se houver mais de uma.
      final commas = RegExp(',').allMatches(text).length;
      text = commas > 1
          ? text.replaceAll(',', '')
          : text.replaceFirst(',', '.');
    } else if (lastDot >= 0) {
      // Só ponto: decimal quando sobram 1 ou 2 dígitos à direita; senão milhar.
      final decimals = text.length - lastDot - 1;
      final dots = RegExp(r'\.').allMatches(text).length;
      if (dots > 1 || decimals == 3) {
        text = text.replaceAll('.', '');
      }
    }

    final value = Decimal.tryParse(text);
    if (value == null || value < Decimal.zero) return null;
    return value;
  }
}
