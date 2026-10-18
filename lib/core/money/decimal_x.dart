import 'package:decimal/decimal.dart';

/// Escala padrão para razões monetárias (R$/km, R$/hora).
///
/// Quatro casas seguem o `numeric(12,4)` usado nas colunas derivadas do
/// Postgres — a mesma precisão nos dois lados evita divergência entre o cálculo
/// offline e o relatório do servidor.
const int kRatioScale = 4;

/// Escala padrão para valores em reais.
const int kMoneyScale = 2;

/// Operações sobre [Decimal] que o projeto usa em cálculo financeiro.
///
/// `Decimal` é obrigatório aqui: `double` acumula erro de arredondamento, e um
/// relatório de fechamento de caixa que não fecha é bug reportável.
extension DecimalX on Decimal {
  /// Divide por [divisor], arredondando para [scale] casas.
  ///
  /// Retorna `null` quando [divisor] é zero, em vez de lançar: no caminho
  /// crítico do overlay uma oferta malformada não pode derrubar o serviço.
  Decimal? divideOrNull(Decimal divisor, {int scale = kRatioScale}) {
    if (divisor == Decimal.zero) return null;
    return (this / divisor).toDecimal(scaleOnInfinitePrecision: scale);
  }

  /// Divide por [divisor] assumindo que ele não é zero.
  ///
  /// Use apenas quando o divisor já foi validado.
  Decimal divideBy(Decimal divisor, {int scale = kRatioScale}) =>
      (this / divisor).toDecimal(scaleOnInfinitePrecision: scale);

  /// Arredonda para [scale] casas decimais.
  Decimal withScale([int scale = kMoneyScale]) => round(scale: scale);

  /// Aplica um percentual, onde 15 significa 15%.
  Decimal percentOf(Decimal percent) =>
      (this * percent).divideBy(Decimal.fromInt(100));
}

/// Converte um [num] para [Decimal] sem passar por `double` quando possível.
extension NumToDecimal on num {
  /// Retorna este número como [Decimal].
  ///
  /// Para `double`, converte via `toString()`: `Decimal.parse('0.4')` é exato,
  /// enquanto o binário por trás de `0.4` não é.
  Decimal get asDecimal {
    final value = this;
    return value is int ? Decimal.fromInt(value) : Decimal.parse(toString());
  }
}
