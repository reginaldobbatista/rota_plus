import 'package:decimal/decimal.dart';
import 'package:meta/meta.dart';
import 'package:rota_plus/core/money/decimal_x.dart';

/// Tipo de combustível do veículo.
enum FuelType {
  /// Gasolina.
  gasoline,

  /// Etanol.
  ethanol,

  /// Flex (gasolina ou etanol).
  flex,

  /// Gás natural veicular.
  cng,

  /// Diesel.
  diesel,

  /// Elétrico.
  electric;

  /// Nome exibido na UI.
  String get label => switch (this) {
    FuelType.gasoline => 'Gasolina',
    FuelType.ethanol => 'Etanol',
    FuelType.flex => 'Flex',
    FuelType.cng => 'GNV',
    FuelType.diesel => 'Diesel',
    FuelType.electric => 'Elétrico',
  };

  /// Unidade de consumo correspondente.
  String get consumptionUnit => this == FuelType.electric ? 'km/kWh' : 'km/l';
}

/// Item de manutenção com custo e intervalo de troca.
@immutable
final class MaintenanceItem {
  /// Cria um item de manutenção.
  const MaintenanceItem({
    required this.label,
    required this.cost,
    required this.intervalKm,
  });

  /// Descrição do item, por exemplo "Troca de óleo".
  final String label;

  /// Custo do serviço ou peça, em reais.
  final Decimal cost;

  /// Intervalo de troca, em quilômetros.
  final Decimal intervalKm;

  /// Custo rateado por quilômetro rodado.
  ///
  /// Retorna zero quando o intervalo é inválido, para que um cadastro
  /// incompleto não contamine o custo total.
  Decimal get costPerKm =>
      cost.divideOrNull(intervalKm, scale: 6) ?? Decimal.zero;
}

/// Custo fixo do veículo, rateado pela quilometragem mensal.
@immutable
final class FixedCost {
  /// Cria um custo fixo a partir do valor mensal.
  const FixedCost.monthly({required this.label, required Decimal amount})
    : _monthlyAmount = amount;

  /// Cria um custo fixo a partir do valor anual, convertendo para mensal.
  FixedCost.annual({required this.label, required Decimal amount})
    : _monthlyAmount = amount.divideBy(Decimal.fromInt(12));

  /// Descrição do custo, por exemplo "IPVA".
  final String label;

  final Decimal _monthlyAmount;

  /// Valor mensal equivalente, em reais.
  Decimal get monthlyAmount => _monthlyAmount;
}

/// Parâmetros de custo de um veículo, usados para calcular o custo por km.
///
/// Esta entidade é o insumo de [CalculateCostPerKm]. Ela não conhece banco de
/// dados nem UI.
@immutable
final class CostParameters {
  /// Cria os parâmetros de custo.
  const CostParameters({
    required this.fuelType,
    required this.fuelPrice,
    required this.consumption,
    required this.workDaysPerMonth,
    required this.kmPerDay,
    Decimal? depreciationPerKm,
    Decimal? genericMaintenancePerKm,
    this.maintenanceItems = const <MaintenanceItem>[],
    this.fixedCosts = const <FixedCost>[],
  }) : _depreciationPerKm = depreciationPerKm,
       _genericMaintenancePerKm = genericMaintenancePerKm;

  /// Tipo de combustível.
  final FuelType fuelType;

  /// Preço do litro ou do kWh, em reais.
  final Decimal fuelPrice;

  /// Consumo médio, em km por litro ou por kWh.
  final Decimal consumption;

  final Decimal? _depreciationPerKm;
  final Decimal? _genericMaintenancePerKm;

  /// Depreciação estimada por quilômetro rodado, em reais. Zero quando não informada.
  Decimal get depreciationPerKm => _depreciationPerKm ?? Decimal.zero;

  /// Custo genérico de manutenção por quilômetro, em reais.
  ///
  /// Cobre o que o motorista não detalhou em [maintenanceItems]. Zero quando
  /// não informado.
  Decimal get genericMaintenancePerKm =>
      _genericMaintenancePerKm ?? Decimal.zero;

  /// Itens de manutenção detalhados.
  final List<MaintenanceItem> maintenanceItems;

  /// Custos fixos a ratear.
  final List<FixedCost> fixedCosts;

  /// Dias trabalhados por mês, base do rateio dos custos fixos.
  final int workDaysPerMonth;

  /// Quilometragem média por dia trabalhado.
  final Decimal kmPerDay;

  /// Indica se os parâmetros permitem calcular o custo por km.
  bool get isValid =>
      consumption > Decimal.zero &&
      kmPerDay > Decimal.zero &&
      workDaysPerMonth > 0;
}
