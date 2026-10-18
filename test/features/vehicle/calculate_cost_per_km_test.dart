import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rota_plus/features/vehicle/domain/entities/cost_parameters.dart';
import 'package:rota_plus/features/vehicle/domain/usecases/calculate_cost_per_km.dart';

Decimal d(String value) => Decimal.parse(value);

void main() {
  const useCase = CalculateCostPerKm();

  group('CalculateCostPerKm', () {
    test('calcula apenas o combustível quando não há outros custos', () {
      final params = CostParameters(
        fuelType: FuelType.flex,
        fuelPrice: d('6.00'),
        consumption: d('10'),
        workDaysPerMonth: 24,
        kmPerDay: d('150'),
      );

      final result = useCase(params)!;

      expect(result.fuelPerKm, d('0.6'));
      expect(result.totalPerKm, d('0.6'));
    });

    test('rateia item de manutenção pelo intervalo de troca', () {
      final params = CostParameters(
        fuelType: FuelType.gasoline,
        fuelPrice: d('6.00'),
        consumption: d('10'),
        workDaysPerMonth: 24,
        kmPerDay: d('150'),
        maintenanceItems: [
          // R$ 300 a cada 10.000 km = R$ 0,03/km
          MaintenanceItem(
            label: 'Troca de óleo',
            cost: d('300'),
            intervalKm: d('10000'),
          ),
          // R$ 2.000 a cada 40.000 km = R$ 0,05/km
          MaintenanceItem(
            label: 'Pneus',
            cost: d('2000'),
            intervalKm: d('40000'),
          ),
        ],
      );

      final result = useCase(params)!;

      expect(result.maintenancePerKm, d('0.08'));
      expect(result.totalPerKm, d('0.68'));
    });

    test('rateia custo fixo pela quilometragem mensal', () {
      final params = CostParameters(
        fuelType: FuelType.flex,
        fuelPrice: d('6.00'),
        consumption: d('10'),
        workDaysPerMonth: 20,
        kmPerDay: d('100'),
        // 20 × 100 = 2.000 km/mês. R$ 400/mês = R$ 0,20/km
        fixedCosts: [FixedCost.monthly(label: 'Aluguel', amount: d('400'))],
      );

      final result = useCase(params)!;

      expect(result.fixedPerKm, d('0.2'));
      expect(result.totalPerKm, d('0.8'));
    });

    test('converte custo anual para mensal antes de ratear', () {
      final annual = FixedCost.annual(label: 'IPVA', amount: d('1200'));

      expect(annual.monthlyAmount, d('100'));
    });

    test('soma todas as parcelas no custo total', () {
      final params = CostParameters(
        fuelType: FuelType.gasoline,
        fuelPrice: d('6.00'),
        consumption: d('12'),
        depreciationPerKm: d('0.15'),
        genericMaintenancePerKm: d('0.05'),
        workDaysPerMonth: 24,
        kmPerDay: d('200'),
        fixedCosts: [
          FixedCost.annual(label: 'IPVA', amount: d('1200')),
          FixedCost.annual(label: 'Seguro', amount: d('2400')),
        ],
      );

      final result = useCase(params)!;

      // combustível 0,50 + manutenção 0,05 + depreciação 0,15
      expect(result.variablePerKm, d('0.7'));
      // fixos: (100 + 200) / (24 × 200) = 300 / 4800 = 0,0625
      expect(result.fixedPerKm, d('0.0625'));
      expect(result.totalPerKm, d('0.7625'));
    });

    test('devolve null quando o consumo é zero', () {
      final params = CostParameters(
        fuelType: FuelType.flex,
        fuelPrice: d('6.00'),
        consumption: Decimal.zero,
        workDaysPerMonth: 24,
        kmPerDay: d('150'),
      );

      expect(useCase(params), isNull);
    });

    test('ignora item de manutenção com intervalo inválido', () {
      final item = MaintenanceItem(
        label: 'Suspensão',
        cost: d('1500'),
        intervalKm: Decimal.zero,
      );

      expect(item.costPerKm, Decimal.zero);
    });

    test('tarifa mínima aplica a margem desejada sobre o custo', () {
      final result = useCase.minimumFarePerKm(
        costPerKm: d('1.20'),
        targetMarginPercent: d('30'),
      );

      expect(result, d('1.56'));
    });

    test('não acumula erro de ponto flutuante', () {
      // Em double, 0.1 + 0.2 != 0.3. Em Decimal, precisa somar exato.
      final params = CostParameters(
        fuelType: FuelType.flex,
        fuelPrice: d('1.00'),
        consumption: d('10'),
        depreciationPerKm: d('0.2'),
        workDaysPerMonth: 1,
        kmPerDay: d('1'),
      );

      final result = useCase(params)!;

      expect(result.variablePerKm, d('0.3'));
      expect(result.variablePerKm.toString(), '0.3');
    });
  });
}
