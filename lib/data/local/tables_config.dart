import 'package:drift/drift.dart';
import 'package:rota_plus/data/local/converters/decimal_converter.dart';
import 'package:rota_plus/features/vehicle/domain/entities/cost_parameters.dart';

/// Veículos do motorista, espelhando `public.vehicles`.
///
/// Até aqui os custos viviam em memória, com valores de exemplo. Persistir é
/// o que torna o veredicto do semáforo confiável: o custo por km passa a ser
/// o custo real do veículo dele, não um palpite.
@DataClassName('LocalVehicle')
class LocalVehicles extends Table {
  /// UUID gerado no dispositivo.
  TextColumn get clientId => text()();

  /// Apelido para o motorista distinguir seus veículos.
  TextColumn get nickname => text().withLength(min: 1, max: 60)();

  /// Marca.
  TextColumn get make => text().nullable()();

  /// Modelo.
  TextColumn get model => text().nullable()();

  /// Ano do modelo.
  IntColumn get modelYear => integer().nullable()();

  /// Quatro últimos caracteres da placa. Nunca a placa inteira.
  TextColumn get plateSuffix => text().nullable()();

  /// Tipo de combustível.
  TextColumn get fuel => textEnum<FuelType>()();

  /// Consumo médio, em km por litro ou por kWh.
  TextColumn get consumption => text().map(const DecimalConverter())();

  /// Preço do litro ou do kWh.
  TextColumn get fuelPrice => text().map(const DecimalConverter())();

  /// Valor de mercado (FIPE), base da depreciação.
  TextColumn get marketValue =>
      text().map(const DecimalConverter()).nullable()();

  /// Depreciação por km rodado.
  TextColumn get depreciationPerKm => text().map(const DecimalConverter())();

  /// Manutenção genérica por km, para o que não foi detalhado.
  TextColumn get genericMaintenancePerKm =>
      text().map(const DecimalConverter())();

  /// Dias trabalhados por mês, base do rateio dos custos fixos.
  IntColumn get workDaysPerMonth => integer()();

  /// Quilometragem média por dia trabalhado.
  TextColumn get kmPerDay => text().map(const DecimalConverter())();

  /// Momento da última alteração, para o last-write-wins da sincronização.
  DateTimeColumn get updatedAt => dateTime()();

  /// Exclusão lógica.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {clientId};
}

/// Itens de manutenção com custo e intervalo, espelhando
/// `public.maintenance_items`.
@DataClassName('LocalMaintenanceItem')
class LocalMaintenanceItems extends Table {
  /// UUID gerado no dispositivo.
  TextColumn get clientId => text()();

  /// Veículo ao qual o item pertence.
  TextColumn get vehicleClientId => text().references(
    LocalVehicles,
    #clientId,
    onDelete: KeyAction.cascade,
  )();

  /// Descrição, por exemplo "Troca de óleo".
  TextColumn get label => text()();

  /// Custo do serviço ou peça.
  TextColumn get cost => text().map(const DecimalConverter())();

  /// Intervalo de troca, em km.
  TextColumn get intervalKm => text().map(const DecimalConverter())();

  @override
  Set<Column<Object>> get primaryKey => {clientId};
}

/// Custos fixos rateados por km, espelhando `public.fixed_costs`.
@DataClassName('LocalFixedCost')
class LocalFixedCosts extends Table {
  /// UUID gerado no dispositivo.
  TextColumn get clientId => text()();

  /// Veículo ao qual o custo pertence.
  TextColumn get vehicleClientId => text().references(
    LocalVehicles,
    #clientId,
    onDelete: KeyAction.cascade,
  )();

  /// Descrição, por exemplo "IPVA".
  TextColumn get label => text()();

  /// Valor já normalizado para o mês.
  ///
  /// A conversão de anual para mensal acontece na entrada, não na leitura:
  /// assim o rateio não precisa saber a periodicidade de cada item.
  TextColumn get monthlyAmount => text().map(const DecimalConverter())();

  @override
  Set<Column<Object>> get primaryKey => {clientId};
}

/// Perfis de trabalho, espelhando `public.work_profiles`.
///
/// Máximo de 10 por motorista. O limite é imposto no repositório **e** no
/// Postgres por trigger — regra de negócio não se defende só no cliente.
@DataClassName('LocalWorkProfile')
class LocalWorkProfiles extends Table {
  /// UUID gerado no dispositivo.
  TextColumn get clientId => text()();

  /// Nome do perfil, por exemplo "Noturno".
  TextColumn get name => text().withLength(min: 1, max: 60)();

  /// Veículo usado neste perfil.
  TextColumn get vehicleClientId => text().nullable()();

  /// Meta mínima de R$/km.
  TextColumn get goalRsPerKm => text().map(const DecimalConverter())();

  /// Meta mínima de R$/hora.
  TextColumn get goalRsPerHour => text().map(const DecimalConverter())();

  /// Nota mínima aceitável do passageiro.
  RealColumn get minPassengerRating => real()();

  /// Distância máxima aceitável até o embarque.
  TextColumn get maxPickupKm => text().map(const DecimalConverter())();

  /// Meta diária de faturamento.
  TextColumn get dailyRevenueGoal => text().map(const DecimalConverter())();

  /// Meta mensal de faturamento.
  TextColumn get monthlyRevenueGoal => text().map(const DecimalConverter())();

  /// Tolerância do estado "PENSE", em percentual.
  TextColumn get thinkTolerancePercent =>
      text().map(const DecimalConverter())();

  /// Margem desejada sobre o custo, em percentual.
  TextColumn get targetMarginPercent => text().map(const DecimalConverter())();

  /// Perfil em uso. Só um fica ativo por vez.
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();

  /// Momento da última alteração.
  DateTimeColumn get updatedAt => dateTime()();

  /// Exclusão lógica.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {clientId};
}

/// Preferências do app, como pares chave-valor.
///
/// Guarda configuração de **aparelho** — se o onboarding já foi visto, qual
/// tema o usuário escolheu — e não dado de domínio. Uma tabela genérica evita
/// uma migração de schema a cada nova preferência.
@DataClassName('LocalSetting')
class LocalSettings extends Table {
  /// Identificador da preferência.
  TextColumn get key => text()();

  /// Valor serializado como texto.
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}
