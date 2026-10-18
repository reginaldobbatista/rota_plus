import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

/// Formatação de valores para a UI, sempre em pt-BR.
abstract final class Fmt {
  static final NumberFormat _currency = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: r'R$',
    decimalDigits: 2,
  );

  static final NumberFormat _compactCurrency = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: r'R$',
    decimalDigits: 0,
  );

  static final NumberFormat _decimal2 = NumberFormat('#,##0.00', 'pt_BR');
  static final NumberFormat _decimal1 = NumberFormat('#,##0.0', 'pt_BR');

  /// Formata um valor monetário: `R$ 1.234,56`.
  static String money(Decimal value) => _currency.format(value.toDouble());

  /// Formata um valor monetário sem centavos: `R$ 1.235`.
  static String moneyCompact(Decimal value) =>
      _compactCurrency.format(value.toDouble());

  /// Formata uma razão por km: `R$ 2,80`.
  static String perKm(Decimal value) => money(value);

  /// Formata uma razão por hora: `R$ 42,50`.
  static String perHour(Decimal value) => money(value);

  /// Formata uma quilometragem: `12,5 km`.
  static String km(Decimal value) => '${_decimal1.format(value.toDouble())} km';

  /// Formata uma nota de 0 a 5: `4,9`.
  static String rating(double value) => _decimal1.format(value);

  /// Formata um percentual: `40,0%`.
  static String percent(Decimal value) =>
      '${_decimal1.format(value.toDouble())}%';

  /// Formata um número decimal com 2 casas.
  static String number(Decimal value) => _decimal2.format(value.toDouble());

  /// Formata uma duração em minutos de forma legível: `24 min`, `1 h 05`.
  static String minutes(double value) {
    final total = value.round();
    if (total < 60) return '$total min';
    final hours = total ~/ 60;
    final rest = total % 60;
    return rest == 0
        ? '$hours h'
        : '$hours h ${rest.toString().padLeft(2, '0')}';
  }
}
