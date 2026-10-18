import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rota_plus/app/providers.dart';
import 'package:rota_plus/features/vehicle/domain/entities/cost_parameters.dart';
import 'package:rota_plus/features/vehicle/domain/entities/work_profile.dart';
import 'package:rota_plus/features/vehicle/domain/usecases/calculate_cost_per_km.dart';
import 'package:rota_plus/features/vehicle/presentation/screens/vehicle_screen.dart';

import '../../support/app_harness.dart';
import '../../support/fixtures.dart';

void main() {
  late AppHarness harness;

  setUp(() => harness = AppHarness());
  tearDown(() => harness.dispose());

  Vehicle newVehicle() => Vehicle(
    nickname: 'Onix do trabalho',
    fuel: FuelType.flex,
    consumption: d('11'),
    fuelPrice: d('6.09'),
    depreciationPerKm: d('0.12'),
    genericMaintenancePerKm: d('0.08'),
    workDaysPerMonth: 24,
    kmPerDay: d('180'),
  );

  group('Encadeamento de providers', () {
    test('sem configuração o semáforo fica indisponível', () async {
      final container = ProviderContainer(overrides: harness.overrides);
      addTearDown(container.dispose);
      // `listen` mantém os providers vivos enquanto o teste roda.
      container.listen(activeProfileProvider, (_, _) {});

      await container.read(activeProfileProvider.future);

      expect(container.read(evaluateRideProvider), isNull);
      expect(container.read(isConfiguredProvider), isFalse);
      expect(container.read(costPerKmProvider), d('0'));
    });

    test('veículo e perfil tornam o semáforo utilizável', () async {
      final container = ProviderContainer(overrides: harness.overrides);
      addTearDown(container.dispose);
      container
        ..listen(activeProfileProvider, (_, _) {})
        ..listen(costParametersProvider, (_, _) {});

      final repo = container.read(configRepositoryProvider);
      final vehicleId = await repo.saveVehicle(
        vehicle: newVehicle(),
        maintenance: const [],
        fixedCosts: const [],
      );
      await repo.saveProfile(
        WorkProfile.initial(name: 'Padrão', vehicleClientId: vehicleId),
      );

      // Espera as streams do Drift chegarem aos providers.
      await container.read(activeProfileProvider.future);
      await container.read(costParametersProvider.future);

      expect(container.read(isConfiguredProvider), isTrue);
      expect(container.read(costPerKmProvider) > d('0'), isTrue);

      final evaluator = container.read(evaluateRideProvider);
      expect(evaluator, isNotNull);

      // O veredicto passa a usar o custo real do veículo cadastrado.
      final result = evaluator!(testOffer())!;
      expect(result.costPerKmUsed, container.read(costPerKmProvider));
    });

    test('alterar o custo do veículo muda o custo por km', () async {
      final container = ProviderContainer(overrides: harness.overrides);
      addTearDown(container.dispose);
      container
        ..listen(activeProfileProvider, (_, _) {})
        ..listen(costParametersProvider, (_, _) {});

      final repo = container.read(configRepositoryProvider);
      final vehicleId = await repo.saveVehicle(
        vehicle: newVehicle(),
        maintenance: const [],
        fixedCosts: const [],
      );
      await repo.saveProfile(
        WorkProfile.initial(name: 'Padrão', vehicleClientId: vehicleId),
      );
      await container.read(activeProfileProvider.future);
      await container.read(costParametersProvider.future);
      final before = container.read(costPerKmProvider);

      // Dobrar o preço do combustível precisa subir o custo por km.
      await repo.saveVehicle(
        vehicle: newVehicle().copyWith(
          clientId: vehicleId,
          fuelPrice: d('12.18'),
        ),
        maintenance: const [],
        fixedCosts: const [],
      );

      // Lê do repositório em vez do provider: `StreamProvider.future` resolve
      // com o valor que já está em cache, então esperar nele devolveria o
      // número antigo e o teste passaria sem provar nada.
      final params = (await repo.findCostParameters(vehicleId))!;
      final after = const CalculateCostPerKm()(params)!.totalPerKm;

      expect(after > before, isTrue);
    });
  });

  group('VehicleScreen · gravação', () {
    testWidgets('o que foi digitado chega ao banco', (tester) async {
      tester.view
        ..physicalSize = const Size(1000, 4000)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(harness.wrap(const VehicleScreen()));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.ancestor(
          of: find.text('Apelido'),
          matching: find.byType(TextFormField),
        ),
        'Moto',
      );
      await tester.enterText(
        find.ancestor(
          of: find.text('Consumo médio'),
          matching: find.byType(TextFormField),
        ),
        '32',
      );
      await tester.tap(find.text('Salvar veículo'));
      // Pump limitado: o indicador de progresso do botão anima sem parar,
      // então `pumpAndSettle` esperaria por uma árvore ociosa que não chega.
      for (var i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      final container = ProviderContainer(overrides: harness.overrides);
      addTearDown(container.dispose);
      final repo = container.read(configRepositoryProvider);

      // `runAsync` é obrigatório: dentro de `testWidgets` o relógio é falso e
      // um `await` direto numa consulta do SQLite nunca completaria.
      final (vehicles, profiles) = (await tester.runAsync(() async {
        return (await repo.listVehicles(), await repo.listProfiles());
      }))!;

      expect(vehicles, hasLength(1));
      expect(vehicles.single.nickname, 'Moto');
      expect(vehicles.single.consumption, d('32'));

      // A tela cria o perfil padrão junto do primeiro veículo, senão o app
      // teria custo cadastrado e continuaria sem metas.
      expect(profiles, hasLength(1));
      expect(profiles.single.vehicleClientId, vehicles.single.clientId);
    });
  });
}
