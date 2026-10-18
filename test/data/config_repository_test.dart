import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rota_plus/data/local/database.dart';
import 'package:rota_plus/features/vehicle/data/repositories/config_repository.dart';
import 'package:rota_plus/features/vehicle/domain/entities/cost_parameters.dart';
import 'package:rota_plus/features/vehicle/domain/entities/work_profile.dart';
import 'package:rota_plus/features/vehicle/domain/usecases/calculate_cost_per_km.dart';

import '../support/fixtures.dart';

void main() {
  late AppDatabase db;
  late ConfigRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = ConfigRepository(database: db, dao: db.configDao);
  });

  tearDown(() => db.close());

  Vehicle vehicle({String nickname = 'Onix'}) => Vehicle(
    nickname: nickname,
    make: 'Chevrolet',
    model: 'Onix',
    modelYear: 2020,
    fuel: FuelType.flex,
    consumption: d('11'),
    fuelPrice: d('6.09'),
    depreciationPerKm: d('0.12'),
    genericMaintenancePerKm: d('0.08'),
    workDaysPerMonth: 24,
    kmPerDay: d('180'),
  );

  group('ConfigRepository · veículos', () {
    test('salva o veículo com manutenção e custos fixos', () async {
      final id = await repo.saveVehicle(
        vehicle: vehicle(),
        maintenance: [
          MaintenanceItem(
            label: 'Óleo',
            cost: d('300'),
            intervalKm: d('10000'),
          ),
        ],
        fixedCosts: [FixedCost.annual(label: 'IPVA', amount: d('1200'))],
      );

      final params = (await repo.findCostParameters(id))!;

      expect(params.maintenanceItems, hasLength(1));
      expect(params.fixedCosts, hasLength(1));
      expect(params.fixedCosts.single.monthlyAmount, d('100'));
    });

    test('os custos salvos alimentam o cálculo de custo por km', () async {
      final id = await repo.saveVehicle(
        vehicle: vehicle(),
        maintenance: const [],
        fixedCosts: const [],
      );

      final params = (await repo.findCostParameters(id))!;
      final breakdown = const CalculateCostPerKm()(params);

      // 6,09 / 11 = 0,5536… de combustível, + 0,08 de manutenção genérica,
      // + 0,12 de depreciação. Sem custo fixo, passa de R$ 0,75/km.
      expect(breakdown, isNotNull);
      expect(breakdown!.totalPerKm > d('0.75'), isTrue);
    });

    test('salvar de novo substitui os custos em vez de duplicar', () async {
      final v = vehicle();
      final id = await repo.saveVehicle(
        vehicle: v,
        maintenance: [
          MaintenanceItem(
            label: 'Óleo',
            cost: d('300'),
            intervalKm: d('10000'),
          ),
        ],
        fixedCosts: const [],
      );

      await repo.saveVehicle(
        vehicle: v.copyWith(clientId: id),
        maintenance: [
          MaintenanceItem(
            label: 'Pneus',
            cost: d('2000'),
            intervalKm: d('40000'),
          ),
        ],
        fixedCosts: const [],
      );

      final params = (await repo.findCostParameters(id))!;

      expect(params.maintenanceItems, hasLength(1));
      expect(params.maintenanceItems.single.label, 'Pneus');
    });

    test('veículo excluído some da lista', () async {
      final id = await repo.saveVehicle(
        vehicle: vehicle(),
        maintenance: const [],
        fixedCosts: const [],
      );

      await repo.removeVehicle(id);

      expect(await repo.watchVehicles().first, isEmpty);
    });
  });

  group('ConfigRepository · perfis de trabalho', () {
    test('o primeiro perfil criado já nasce ativo', () async {
      // Sem isso o app ficaria sem metas e o semáforo sem critério.
      await repo.saveProfile(WorkProfile.initial(name: 'Diurno'));

      final active = await repo.watchActiveProfile().first;

      expect(active, isNotNull);
      expect(active!.name, 'Diurno');
    });

    test('o segundo perfil não rouba o ativo', () async {
      await repo.saveProfile(WorkProfile.initial(name: 'Diurno'));
      await repo.saveProfile(WorkProfile.initial(name: 'Noturno'));

      final active = await repo.watchActiveProfile().first;

      expect(active!.name, 'Diurno');
    });

    test('ativar um perfil desativa o anterior', () async {
      await repo.saveProfile(WorkProfile.initial(name: 'Diurno'));
      final noturno = await repo.saveProfile(
        WorkProfile.initial(name: 'Noturno'),
      );

      await repo.activateProfile(noturno);
      final profiles = await repo.watchProfiles().first;

      // Dois perfis ativos ao mesmo tempo deixariam as metas indeterminadas.
      expect(profiles.where((p) => p.isActive), hasLength(1));
      expect((await repo.watchActiveProfile().first)!.name, 'Noturno');
    });

    test('recusa o 11º perfil', () async {
      for (var i = 1; i <= ConfigRepository.maxProfiles; i++) {
        await repo.saveProfile(WorkProfile.initial(name: 'Perfil $i'));
      }

      expect(
        () => repo.saveProfile(WorkProfile.initial(name: 'Excedente')),
        throwsA(isA<ConfigFailure>()),
      );
      expect(await repo.watchProfiles().first, hasLength(10));
    });

    test('editar um perfil existente não conta para o limite', () async {
      for (var i = 1; i <= ConfigRepository.maxProfiles; i++) {
        await repo.saveProfile(WorkProfile.initial(name: 'Perfil $i'));
      }
      final existing = (await repo.watchProfiles().first).first;

      await repo.saveProfile(existing.copyWith(name: 'Renomeado'));

      expect(await repo.watchProfiles().first, hasLength(10));
    });

    test('duplicar cria um perfil novo com sufixo', () async {
      final id = await repo.saveProfile(WorkProfile.initial(name: 'Diurno'));

      await repo.duplicateProfile(id);
      final profiles = await repo.watchProfiles().first;

      expect(profiles, hasLength(2));
      expect(profiles.any((p) => p.name == 'Diurno (cópia)'), isTrue);
      // A cópia não assume o lugar do ativo.
      expect((await repo.watchActiveProfile().first)!.name, 'Diurno');
    });

    test('recusa excluir o único perfil', () async {
      final id = await repo.saveProfile(WorkProfile.initial(name: 'Único'));

      expect(() => repo.removeProfile(id), throwsA(isA<ConfigFailure>()));
    });

    test('excluir o ativo promove outro perfil', () async {
      final diurno = await repo.saveProfile(
        WorkProfile.initial(name: 'Diurno'),
      );
      await repo.saveProfile(WorkProfile.initial(name: 'Noturno'));

      await repo.removeProfile(diurno);
      final active = await repo.watchActiveProfile().first;

      // Ficar sem perfil ativo deixaria o semáforo sem metas.
      expect(active, isNotNull);
      expect(active!.name, 'Noturno');
    });

    test('perfil guarda e devolve as metas', () async {
      final id = await repo.saveProfile(
        WorkProfile.initial(
          name: 'Exigente',
        ).copyWith(goals: testGoals(), targetMarginPercent: d('40')),
      );

      final saved = (await repo.watchProfiles().first).firstWhere(
        (p) => p.clientId == id,
      );

      expect(saved.goals.minRsPerKm, d('2.00'));
      expect(saved.goals.minRsPerHour, d('30.00'));
      expect(saved.targetMarginPercent, d('40'));
    });
  });
}
