import 'package:drift/drift.dart';
import 'package:rota_plus/data/local/database.dart';
import 'package:rota_plus/data/local/tables_config.dart';

part 'config_dao.g.dart';

/// Veículo com seus custos detalhados, lido numa única consulta.
class VehicleWithCosts {
  /// Agrupa o veículo e seus custos.
  const VehicleWithCosts({
    required this.vehicle,
    required this.maintenance,
    required this.fixedCosts,
  });

  /// Dados do veículo.
  final LocalVehicle vehicle;

  /// Itens de manutenção detalhados.
  final List<LocalMaintenanceItem> maintenance;

  /// Custos fixos a ratear.
  final List<LocalFixedCost> fixedCosts;
}

/// Acesso à configuração do motorista: veículos, custos e perfis de trabalho.
@DriftAccessor(
  tables: [
    LocalVehicles,
    LocalMaintenanceItems,
    LocalFixedCosts,
    LocalWorkProfiles,
  ],
)
class ConfigDao extends DatabaseAccessor<AppDatabase> with _$ConfigDaoMixin {
  /// Cria o DAO.
  ConfigDao(super.db);

  // ---------------------------------------------------------------- veículos

  /// Insere ou atualiza um veículo.
  Future<void> upsertVehicle(LocalVehicle row) =>
      into(localVehicles).insertOnConflictUpdate(row);

  /// Observa os veículos ativos.
  Stream<List<LocalVehicle>> watchVehicles() {
    final query = select(localVehicles)
      ..where((t) => t.deletedAt.isNull())
      ..orderBy([(t) => OrderingTerm.asc(t.nickname)]);
    return query.watch();
  }

  /// Busca um veículo pelo `clientId`.
  Future<LocalVehicle?> findVehicle(String clientId) => (select(
    localVehicles,
  )..where((t) => t.clientId.equals(clientId))).getSingleOrNull();

  /// Marca um veículo como excluído.
  Future<void> softDeleteVehicle(String clientId, DateTime when) =>
      (update(localVehicles)..where((t) => t.clientId.equals(clientId))).write(
        LocalVehiclesCompanion(deletedAt: Value(when), updatedAt: Value(when)),
      );

  // ------------------------------------------------------------------ custos

  /// Substitui todos os itens de manutenção de um veículo.
  ///
  /// Substituição em bloco em vez de diff item a item: a tela de custos edita
  /// a lista inteira de uma vez, e reconciliar item a item só adicionaria
  /// complexidade sem ganho.
  Future<void> replaceMaintenance(
    String vehicleClientId,
    List<LocalMaintenanceItem> items,
  ) async {
    await transaction(() async {
      await (delete(
        localMaintenanceItems,
      )..where((t) => t.vehicleClientId.equals(vehicleClientId))).go();
      await batch((b) => b.insertAll(localMaintenanceItems, items));
    });
  }

  /// Substitui todos os custos fixos de um veículo.
  Future<void> replaceFixedCosts(
    String vehicleClientId,
    List<LocalFixedCost> costs,
  ) async {
    await transaction(() async {
      await (delete(
        localFixedCosts,
      )..where((t) => t.vehicleClientId.equals(vehicleClientId))).go();
      await batch((b) => b.insertAll(localFixedCosts, costs));
    });
  }

  /// Observa um veículo junto de seus custos.
  Stream<VehicleWithCosts?> watchVehicleWithCosts(String vehicleClientId) {
    // Consulta trivial só para declarar `readsFrom`: faz o Drift reemitir
    // quando qualquer das três tabelas muda. Em seguida busca o conjunto
    // completo com Futures.
    //
    // A versão anterior criava três streams e chamava `.first` neles a cada
    // emissão. Reescutar um stream já escutado trava a espera para sempre, e
    // a tela ficava carregando sem erro nenhum — falha silenciosa.
    return customSelect(
      'SELECT 1',
      readsFrom: {localVehicles, localMaintenanceItems, localFixedCosts},
    ).watch().asyncMap((_) => findVehicleWithCosts(vehicleClientId));
  }

  /// Lê um veículo com seus custos, sem observar.
  Future<VehicleWithCosts?> findVehicleWithCosts(String vehicleClientId) async {
    final vehicle = await findVehicle(vehicleClientId);
    if (vehicle == null) return null;

    final maintenance = await (select(
      localMaintenanceItems,
    )..where((t) => t.vehicleClientId.equals(vehicleClientId))).get();
    final fixed = await (select(
      localFixedCosts,
    )..where((t) => t.vehicleClientId.equals(vehicleClientId))).get();

    return VehicleWithCosts(
      vehicle: vehicle,
      maintenance: maintenance,
      fixedCosts: fixed,
    );
  }

  // ------------------------------------------------------- perfis de trabalho

  /// Insere ou atualiza um perfil de trabalho.
  Future<void> upsertProfile(LocalWorkProfile row) =>
      into(localWorkProfiles).insertOnConflictUpdate(row);

  /// Observa os perfis ativos, com o perfil em uso primeiro.
  Stream<List<LocalWorkProfile>> watchProfiles() {
    final query = select(localWorkProfiles)
      ..where((t) => t.deletedAt.isNull())
      ..orderBy([
        (t) => OrderingTerm.desc(t.isActive),
        (t) => OrderingTerm.asc(t.name),
      ]);
    return query.watch();
  }

  /// Observa o perfil em uso.
  Stream<LocalWorkProfile?> watchActiveProfile() {
    final query = select(localWorkProfiles)
      ..where((t) => t.isActive & t.deletedAt.isNull())
      ..limit(1);
    return query.watchSingleOrNull();
  }

  /// Lê os perfis uma única vez.
  ///
  /// Existe em vez de `watchProfiles().first` porque usar um stream como
  /// leitura pontual cria e destrói uma assinatura a cada chamada — e já
  /// causou travamento neste projeto.
  Future<List<LocalWorkProfile>> getProfiles() {
    final query = select(localWorkProfiles)
      ..where((t) => t.deletedAt.isNull())
      ..orderBy([
        (t) => OrderingTerm.desc(t.isActive),
        (t) => OrderingTerm.asc(t.name),
      ]);
    return query.get();
  }

  /// Lê os veículos uma única vez.
  Future<List<LocalVehicle>> getVehicles() {
    final query = select(localVehicles)
      ..where((t) => t.deletedAt.isNull())
      ..orderBy([(t) => OrderingTerm.asc(t.nickname)]);
    return query.get();
  }

  /// Conta quantos perfis ativos existem, para impor o limite de 10.
  Future<int> countProfiles() async {
    final count = localWorkProfiles.clientId.count();
    final query = selectOnly(localWorkProfiles)
      ..addColumns([count])
      ..where(localWorkProfiles.deletedAt.isNull());
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  /// Busca um perfil pelo `clientId`.
  Future<LocalWorkProfile?> findProfile(String clientId) => (select(
    localWorkProfiles,
  )..where((t) => t.clientId.equals(clientId))).getSingleOrNull();

  /// Torna um perfil o ativo, desativando os demais.
  ///
  /// Numa transação: dois perfis ativos ao mesmo tempo fariam o semáforo usar
  /// metas indeterminadas.
  Future<void> setActiveProfile(String clientId, DateTime when) async {
    await transaction(() async {
      await (update(localWorkProfiles)..where((t) => t.isActive)).write(
        LocalWorkProfilesCompanion(
          isActive: const Value(false),
          updatedAt: Value(when),
        ),
      );
      await (update(
        localWorkProfiles,
      )..where((t) => t.clientId.equals(clientId))).write(
        LocalWorkProfilesCompanion(
          isActive: const Value(true),
          updatedAt: Value(when),
        ),
      );
    });
  }

  /// Marca um perfil como excluído.
  Future<void> softDeleteProfile(String clientId, DateTime when) =>
      (update(
        localWorkProfiles,
      )..where((t) => t.clientId.equals(clientId))).write(
        LocalWorkProfilesCompanion(
          deletedAt: Value(when),
          isActive: const Value(false),
          updatedAt: Value(when),
        ),
      );
}
