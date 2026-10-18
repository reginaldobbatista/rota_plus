import 'package:decimal/decimal.dart';
import 'package:rota_plus/core/money/decimal_x.dart';
import 'package:rota_plus/features/vehicle/domain/entities/cost_parameters.dart';

/// Resultado detalhado do cálculo de custo por quilômetro.
///
/// A composição é exposta porque a tela de veículo mostra ao motorista de onde
/// vem o custo — um número único e opaco não gera confiança no veredicto.
final class CostBreakdown {
  /// Cria a composição do custo por km.
  const CostBreakdown({
    required this.fuelPerKm,
    required this.maintenancePerKm,
    required this.depreciationPerKm,
    required this.fixedPerKm,
  });

  /// Custo de combustível por km.
  final Decimal fuelPerKm;

  /// Custo de manutenção por km, detalhado mais o genérico.
  final Decimal maintenancePerKm;

  /// Depreciação por km.
  final Decimal depreciationPerKm;

  /// Custos fixos rateados por km.
  final Decimal fixedPerKm;

  /// Soma de tudo: o custo real de rodar um quilômetro.
  Decimal get totalPerKm =>
      (fuelPerKm + maintenancePerKm + depreciationPerKm + fixedPerKm).withScale(
        kRatioScale,
      );

  /// Parcela variável, que depende de rodar.
  Decimal get variablePerKm =>
      (fuelPerKm + maintenancePerKm + depreciationPerKm).withScale(kRatioScale);
}

/// Calcula o custo por quilômetro a partir dos parâmetros do veículo.
///
/// Esta é a contraparte Dart de `public.fn_calculate_cost_per_km()`. As duas
/// implementações precisam usar a mesma fórmula: se divergirem, o veredicto
/// offline e o relatório do servidor passam a discordar entre si.
final class CalculateCostPerKm {
  /// Cria o caso de uso.
  const CalculateCostPerKm();

  /// Retorna a composição do custo, ou `null` se os parâmetros forem inválidos.
  CostBreakdown? call(CostParameters params) {
    if (!params.isValid) return null;

    final fuelPerKm = params.fuelPrice.divideBy(params.consumption, scale: 6);

    final detailedMaintenance = params.maintenanceItems.fold(
      Decimal.zero,
      (sum, item) => sum + item.costPerKm,
    );
    final maintenancePerKm =
        detailedMaintenance + params.genericMaintenancePerKm;

    final monthlyFixed = params.fixedCosts.fold(
      Decimal.zero,
      (sum, cost) => sum + cost.monthlyAmount,
    );
    final monthlyKm =
        Decimal.fromInt(params.workDaysPerMonth) * params.kmPerDay;
    final fixedPerKm =
        monthlyFixed.divideOrNull(monthlyKm, scale: 6) ?? Decimal.zero;

    return CostBreakdown(
      fuelPerKm: fuelPerKm,
      maintenancePerKm: maintenancePerKm,
      depreciationPerKm: params.depreciationPerKm,
      fixedPerKm: fixedPerKm,
    );
  }

  /// Calcula a tarifa mínima de R$/km para atingir [targetMarginPercent].
  Decimal minimumFarePerKm({
    required Decimal costPerKm,
    required Decimal targetMarginPercent,
  }) {
    final multiplier =
        Decimal.one +
        targetMarginPercent.divideBy(Decimal.fromInt(100), scale: 6);
    return (costPerKm * multiplier).withScale(kRatioScale);
  }
}
