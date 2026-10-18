import 'package:decimal/decimal.dart';
import 'package:meta/meta.dart';
import 'package:rota_plus/features/goals/domain/entities/work_goals.dart';
import 'package:rota_plus/features/vehicle/domain/entities/cost_parameters.dart';

/// Veículo do motorista, com os parâmetros que determinam o custo por km.
@immutable
final class Vehicle {
  /// Cria um veículo.
  const Vehicle({
    required this.nickname,
    required this.fuel,
    required this.consumption,
    required this.fuelPrice,
    required this.depreciationPerKm,
    required this.genericMaintenancePerKm,
    required this.workDaysPerMonth,
    required this.kmPerDay,
    this.clientId,
    this.make,
    this.model,
    this.modelYear,
    this.plateSuffix,
    this.marketValue,
  });

  /// UUID gerado no dispositivo. Nulo antes do primeiro salvamento.
  final String? clientId;

  /// Apelido para distinguir veículos.
  final String nickname;

  /// Marca.
  final String? make;

  /// Modelo.
  final String? model;

  /// Ano do modelo.
  final int? modelYear;

  /// Quatro últimos caracteres da placa.
  ///
  /// Nunca a placa completa: é dado identificável e o app não precisa dele
  /// para calcular nada.
  final String? plateSuffix;

  /// Tipo de combustível.
  final FuelType fuel;

  /// Consumo médio, em km por litro ou por kWh.
  final Decimal consumption;

  /// Preço do litro ou do kWh.
  final Decimal fuelPrice;

  /// Valor de mercado (FIPE).
  final Decimal? marketValue;

  /// Depreciação por km rodado.
  final Decimal depreciationPerKm;

  /// Manutenção genérica por km.
  final Decimal genericMaintenancePerKm;

  /// Dias trabalhados por mês.
  final int workDaysPerMonth;

  /// Quilometragem média por dia trabalhado.
  final Decimal kmPerDay;

  /// Descrição curta para listas: "Onix 2020 · Flex".
  ///
  /// Cai para só o combustível quando marca, modelo e ano estão em branco —
  /// campos opcionais que muitos motoristas não preenchem.
  String get summary {
    final parts = <String>[?make, ?model, ?modelYear?.toString()];
    return parts.isEmpty ? fuel.label : '${parts.join(' ')} · ${fuel.label}';
  }

  /// Retorna uma cópia com os campos informados substituídos.
  Vehicle copyWith({
    String? clientId,
    String? nickname,
    String? make,
    String? model,
    int? modelYear,
    String? plateSuffix,
    FuelType? fuel,
    Decimal? consumption,
    Decimal? fuelPrice,
    Decimal? marketValue,
    Decimal? depreciationPerKm,
    Decimal? genericMaintenancePerKm,
    int? workDaysPerMonth,
    Decimal? kmPerDay,
  }) => Vehicle(
    clientId: clientId ?? this.clientId,
    nickname: nickname ?? this.nickname,
    make: make ?? this.make,
    model: model ?? this.model,
    modelYear: modelYear ?? this.modelYear,
    plateSuffix: plateSuffix ?? this.plateSuffix,
    fuel: fuel ?? this.fuel,
    consumption: consumption ?? this.consumption,
    fuelPrice: fuelPrice ?? this.fuelPrice,
    marketValue: marketValue ?? this.marketValue,
    depreciationPerKm: depreciationPerKm ?? this.depreciationPerKm,
    genericMaintenancePerKm:
        genericMaintenancePerKm ?? this.genericMaintenancePerKm,
    workDaysPerMonth: workDaysPerMonth ?? this.workDaysPerMonth,
    kmPerDay: kmPerDay ?? this.kmPerDay,
  );
}

/// Perfil de trabalho: um conjunto de metas associado a um veículo.
///
/// Permite ao motorista ter critérios diferentes para cenários diferentes —
/// rodar de dia na cidade não tem as mesmas metas de uma madrugada de tarifa
/// dinâmica.
@immutable
final class WorkProfile {
  /// Cria um perfil de trabalho.
  const WorkProfile({
    required this.name,
    required this.goals,
    required this.dailyRevenueGoal,
    required this.monthlyRevenueGoal,
    required this.targetMarginPercent,
    this.clientId,
    this.vehicleClientId,
    this.isActive = false,
  });

  /// Cria um perfil com valores iniciais razoáveis.
  factory WorkProfile.initial({
    required String name,
    String? vehicleClientId,
  }) => WorkProfile(
    name: name,
    vehicleClientId: vehicleClientId,
    goals: WorkGoals(
      minRsPerKm: Decimal.parse('2.00'),
      minRsPerHour: Decimal.parse('35.00'),
      maxPickupKm: Decimal.parse('5'),
    ),
    dailyRevenueGoal: Decimal.parse('250'),
    monthlyRevenueGoal: Decimal.parse('6000'),
    targetMarginPercent: Decimal.parse('30'),
  );

  /// UUID gerado no dispositivo. Nulo antes do primeiro salvamento.
  final String? clientId;

  /// Nome do perfil.
  final String name;

  /// Veículo usado neste perfil.
  final String? vehicleClientId;

  /// Metas que alimentam o semáforo.
  final WorkGoals goals;

  /// Meta diária de faturamento.
  final Decimal dailyRevenueGoal;

  /// Meta mensal de faturamento.
  final Decimal monthlyRevenueGoal;

  /// Margem desejada sobre o custo, em percentual.
  final Decimal targetMarginPercent;

  /// Indica se é o perfil em uso.
  final bool isActive;

  /// Retorna uma cópia com os campos informados substituídos.
  ///
  /// `clientId` aceita nulo explícito para duplicar um perfil como novo.
  WorkProfile copyWith({
    Object? clientId = _unset,
    String? name,
    Object? vehicleClientId = _unset,
    WorkGoals? goals,
    Decimal? dailyRevenueGoal,
    Decimal? monthlyRevenueGoal,
    Decimal? targetMarginPercent,
    bool? isActive,
  }) => WorkProfile(
    clientId: clientId == _unset ? this.clientId : clientId as String?,
    name: name ?? this.name,
    vehicleClientId: vehicleClientId == _unset
        ? this.vehicleClientId
        : vehicleClientId as String?,
    goals: goals ?? this.goals,
    dailyRevenueGoal: dailyRevenueGoal ?? this.dailyRevenueGoal,
    monthlyRevenueGoal: monthlyRevenueGoal ?? this.monthlyRevenueGoal,
    targetMarginPercent: targetMarginPercent ?? this.targetMarginPercent,
    isActive: isActive ?? this.isActive,
  );
}

/// Sentinela que distingue "não informado" de "informado como nulo".
const Object _unset = Object();
