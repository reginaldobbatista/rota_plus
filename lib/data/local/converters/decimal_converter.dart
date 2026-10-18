import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';

/// Converte [Decimal] para `TEXT` no SQLite.
///
/// SQLite não tem tipo decimal exato: `REAL` é ponto flutuante binário e
/// introduz erro de arredondamento em dinheiro. Guardar a representação
/// textual mantém o valor exato e espelha o `numeric` do Postgres.
class DecimalConverter extends TypeConverter<Decimal, String> {
  /// Cria o conversor.
  const DecimalConverter();

  @override
  Decimal fromSql(String fromDb) => Decimal.parse(fromDb);

  @override
  String toSql(Decimal value) => value.toString();
}
