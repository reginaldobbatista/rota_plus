import 'package:decimal/decimal.dart';
import 'package:rota_plus/data/local/daos/config_dao.dart';
import 'package:rota_plus/data/local/database.dart';
import 'package:rota_plus/features/goals/domain/entities/work_goals.dart';
import 'package:rota_plus/features/vehicle/domain/entities/cost_parameters.dart';
import 'package:rota_plus/features/vehicle/domain/entities/work_profile.dart';
import 'package:uuid/uuid.dart';

/// Erro de regra de negócio da configuração.
class ConfigFailure implements Exception {
  /// Cria a falha com a mensagem exibida ao usuário.
  const ConfigFailure(this.message);

  /// Mensagem pronta para a UI, em linguagem do motorista.
  final String message;

  @override
  String toString() => message;
}

/// Configuração do motorista: veículos, custos e perfis de trabalho.
///
/// Substitui os valores em memória que o app usava até aqui. O veredicto do
/// semáforo passa a sair do custo real do veículo dele.
class ConfigRepository {
  /// Cria o repositório.
  ConfigRepository({
    required AppDatabase database,
    required ConfigDao dao,
    Uuid uuid = const Uuid(),
    DateTime Function() clock = _utcNow,
  }) : _db = database,
       _dao = dao,
       _uuid = uuid,
       _clock = clock;

  static DateTime _utcNow() => DateTime.now().toUtc();

  /// Limite de perfis por motorista, conforme o descritivo.
  static const int maxProfiles = 10;

  final AppDatabase _db;
  final ConfigDao _dao;
  final Uuid _uuid;
  final DateTime Function() _clock;

  // ---------------------------------------------------------------- veículos

  /// Observa os veículos cadastrados.
  Stream<List<Vehicle>> watchVehicles() =>
      _dao.watchVehicles().map((rows) => rows.map(_toVehicle).toList());

  /// Observa um veículo com seus custos, já pronto para o cálculo.
  Stream<CostParameters?> watchCostParameters(String vehicleClientId) =>
      _dao.watchVehicleWithCosts(vehicleClientId).map(_toCostParameters);

  /// Lê os parâmetros de custo de um veículo.
  Future<CostParameters?> findCostParameters(String vehicleClientId) async =>
      _toCostParameters(await _dao.findVehicleWithCosts(vehicleClientId));

  /// Cria ou atualiza um veículo com seus custos.
  ///
  /// Tudo numa transação: um veículo salvo sem os custos daria um custo por km
  /// errado para baixo, e o motorista aceitaria corrida que dá prejuízo.
  Future<String> saveVehicle({
    required Vehicle vehicle,
    required List<MaintenanceItem> maintenance,
    required List<FixedCost> fixedCosts,
  }) async {
    final clientId = vehicle.clientId ?? _uuid.v4();
    final now = _clock();

    await _db.transaction(() async {
      await _dao.upsertVehicle(
        LocalVehicle(
          clientId: clientId,
          nickname: vehicle.nickname,
          make: vehicle.make,
          model: vehicle.model,
          modelYear: vehicle.modelYear,
          plateSuffix: vehicle.plateSuffix,
          fuel: vehicle.fuel,
          consumption: vehicle.consumption,
          fuelPrice: vehicle.fuelPrice,
          marketValue: vehicle.marketValue,
          depreciationPerKm: vehicle.depreciationPerKm,
          genericMaintenancePerKm: vehicle.genericMaintenancePerKm,
          workDaysPerMonth: vehicle.workDaysPerMonth,
          kmPerDay: vehicle.kmPerDay,
          updatedAt: now,
        ),
      );

      await _dao.replaceMaintenance(clientId, [
        for (final item in maintenance)
          LocalMaintenanceItem(
            clientId: _uuid.v4(),
            vehicleClientId: clientId,
            label: item.label,
            cost: item.cost,
            intervalKm: item.intervalKm,
          ),
      ]);

      await _dao.replaceFixedCosts(clientId, [
        for (final cost in fixedCosts)
          LocalFixedCost(
            clientId: _uuid.v4(),
            vehicleClientId: clientId,
            label: cost.label,
            monthlyAmount: cost.monthlyAmount,
          ),
      ]);
    });

    return clientId;
  }

  /// Exclui logicamente um veículo.
  Future<void> removeVehicle(String clientId) =>
      _dao.softDeleteVehicle(clientId, _clock());

  // ------------------------------------------------------- perfis de trabalho

  /// Observa os perfis de trabalho.
  Stream<List<WorkProfile>> watchProfiles() =>
      _dao.watchProfiles().map((rows) => rows.map(_toProfile).toList());

  /// Observa o perfil em uso.
  Stream<WorkProfile?> watchActiveProfile() => _dao.watchActiveProfile().map(
    (row) => row == null ? null : _toProfile(row),
  );

  /// Cria ou atualiza um perfil de trabalho.
  ///
  /// Lança [ConfigFailure] ao exceder o limite de [maxProfiles]. O Postgres
  /// impõe o mesmo limite por trigger: regra de negócio não se defende só no
  /// cliente, mas defendê-la aqui dá uma mensagem melhor ao motorista.
  Future<String> saveProfile(WorkProfile profile) async {
    final isNew = profile.clientId == null;

    if (isNew && await _dao.countProfiles() >= maxProfiles) {
      throw const ConfigFailure(
        'Você atingiu o limite de 10 perfis de trabalho. '
        'Exclua um perfil para criar outro.',
      );
    }

    final clientId = profile.clientId ?? _uuid.v4();
    final now = _clock();
    final isFirst = isNew && await _dao.countProfiles() == 0;

    await _dao.upsertProfile(
      LocalWorkProfile(
        clientId: clientId,
        name: profile.name,
        vehicleClientId: profile.vehicleClientId,
        goalRsPerKm: profile.goals.minRsPerKm,
        goalRsPerHour: profile.goals.minRsPerHour,
        minPassengerRating: profile.goals.minPassengerRating,
        maxPickupKm: profile.goals.maxPickupKm,
        dailyRevenueGoal: profile.dailyRevenueGoal,
        monthlyRevenueGoal: profile.monthlyRevenueGoal,
        thinkTolerancePercent: profile.goals.thinkTolerancePercent,
        targetMarginPercent: profile.targetMarginPercent,
        // O primeiro perfil criado já nasce ativo: sem isso o app ficaria sem
        // metas e o semáforo não teria critério.
        isActive: isFirst || profile.isActive,
        updatedAt: now,
      ),
    );

    if (isFirst) await _dao.setActiveProfile(clientId, now);

    return clientId;
  }

  /// Torna um perfil o ativo.
  Future<void> activateProfile(String clientId) =>
      _dao.setActiveProfile(clientId, _clock());

  /// Duplica um perfil, útil para variar metas a partir de um existente.
  Future<String> duplicateProfile(String clientId) async {
    final source = await _dao.findProfile(clientId);
    if (source == null) {
      throw const ConfigFailure('Perfil não encontrado.');
    }

    return saveProfile(
      _toProfile(source).copyWith(
        clientId: null,
        name: '${source.name} (cópia)',
        isActive: false,
      ),
    );
  }

  /// Exclui logicamente um perfil.
  Future<void> removeProfile(String clientId) async {
    final profile = await _dao.findProfile(clientId);
    if (profile == null) return;

    if (profile.isActive && await _dao.countProfiles() <= 1) {
      throw const ConfigFailure(
        'Este é o seu único perfil. Crie outro antes de excluí-lo.',
      );
    }

    await _dao.softDeleteProfile(clientId, _clock());

    // Sem perfil ativo o semáforo fica sem metas: promove o primeiro restante.
    if (profile.isActive) {
      final remaining = await _dao.watchProfiles().first;
      if (remaining.isNotEmpty) {
        await _dao.setActiveProfile(remaining.first.clientId, _clock());
      }
    }
  }

  // ---------------------------------------------------------------- mapeamento

  Vehicle _toVehicle(LocalVehicle row) => Vehicle(
    clientId: row.clientId,
    nickname: row.nickname,
    make: row.make,
    model: row.model,
    modelYear: row.modelYear,
    plateSuffix: row.plateSuffix,
    fuel: row.fuel,
    consumption: row.consumption,
    fuelPrice: row.fuelPrice,
    marketValue: row.marketValue,
    depreciationPerKm: row.depreciationPerKm,
    genericMaintenancePerKm: row.genericMaintenancePerKm,
    workDaysPerMonth: row.workDaysPerMonth,
    kmPerDay: row.kmPerDay,
  );

  WorkProfile _toProfile(LocalWorkProfile row) => WorkProfile(
    clientId: row.clientId,
    name: row.name,
    vehicleClientId: row.vehicleClientId,
    goals: WorkGoals(
      minRsPerKm: row.goalRsPerKm,
      minRsPerHour: row.goalRsPerHour,
      minPassengerRating: row.minPassengerRating,
      maxPickupKm: row.maxPickupKm,
      thinkTolerancePercent: row.thinkTolerancePercent,
    ),
    dailyRevenueGoal: row.dailyRevenueGoal,
    monthlyRevenueGoal: row.monthlyRevenueGoal,
    targetMarginPercent: row.targetMarginPercent,
    isActive: row.isActive,
  );

  CostParameters? _toCostParameters(VehicleWithCosts? data) {
    if (data == null) return null;
    final v = data.vehicle;

    return CostParameters(
      fuelType: v.fuel,
      fuelPrice: v.fuelPrice,
      consumption: v.consumption,
      depreciationPerKm: v.depreciationPerKm,
      genericMaintenancePerKm: v.genericMaintenancePerKm,
      workDaysPerMonth: v.workDaysPerMonth,
      kmPerDay: v.kmPerDay,
      maintenanceItems: [
        for (final item in data.maintenance)
          MaintenanceItem(
            label: item.label,
            cost: item.cost,
            intervalKm: item.intervalKm,
          ),
      ],
      fixedCosts: [
        for (final cost in data.fixedCosts)
          FixedCost.monthly(label: cost.label, amount: cost.monthlyAmount),
      ],
    );
  }
}

/// Valor padrão sugerido ao cadastrar o primeiro veículo.
///
/// Não são os custos de ninguém: são um ponto de partida plausível para o
/// motorista ajustar. A tela deixa isso explícito.
abstract final class VehicleDefaults {
  /// Consumo médio sugerido, em km/l.
  static Decimal get consumption => Decimal.parse('11');

  /// Preço do litro sugerido.
  static Decimal get fuelPrice => Decimal.parse('6.09');

  /// Depreciação por km sugerida.
  static Decimal get depreciationPerKm => Decimal.parse('0.12');

  /// Manutenção genérica por km sugerida.
  static Decimal get genericMaintenancePerKm => Decimal.parse('0.08');

  /// Dias trabalhados por mês sugeridos.
  static const int workDaysPerMonth = 24;

  /// Quilometragem diária sugerida.
  static Decimal get kmPerDay => Decimal.parse('180');
}
