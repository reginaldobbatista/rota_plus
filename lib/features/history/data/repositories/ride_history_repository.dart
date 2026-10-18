import 'package:rota_plus/data/local/daos/outbox_dao.dart';
import 'package:rota_plus/data/local/daos/ride_dao.dart';
import 'package:rota_plus/data/local/database.dart';
import 'package:rota_plus/data/local/mappers/ride_mapper.dart';
import 'package:rota_plus/data/local/tables.dart';
import 'package:rota_plus/features/history/domain/entities/daily_totals.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_evaluation.dart';
import 'package:uuid/uuid.dart';

/// Histórico de corridas avaliadas, com escrita local-first.
///
/// Leitura sempre do banco local, em stream. Escrita grava no banco e
/// enfileira o envio **na mesma transação**: ou os dois acontecem, ou nenhum.
/// É isso que garante que nada se perde se o sistema matar o app no meio de um
/// registro — situação rotineira num serviço que roda horas em background.
class RideHistoryRepository {
  /// Cria o repositório.
  RideHistoryRepository({
    required AppDatabase database,
    required RideDao rideDao,
    required OutboxDao outboxDao,
    Uuid uuid = const Uuid(),
  }) : _db = database,
       _rides = rideDao,
       _outbox = outboxDao,
       _uuid = uuid;

  final AppDatabase _db;
  final RideDao _rides;
  final OutboxDao _outbox;
  final Uuid _uuid;

  /// Registra uma avaliação e devolve o `clientId` atribuído.
  ///
  /// O UUID é gerado **no dispositivo**, não pelo servidor: é o que permite
  /// registrar offline e tornar o reenvio idempotente.
  Future<String> record(
    RideEvaluation evaluation, {
    RideOutcome outcome = RideOutcome.unknown,
    String? workSessionClientId,
  }) async {
    final clientId = evaluation.clientId ?? _uuid.v4();
    final row = evaluation
        .copyWith(
          clientId: clientId,
          outcome: outcome,
          workSessionClientId: workSessionClientId,
        )
        .toRow(clientId: clientId);

    await _db.transaction(() async {
      await _rides.insertRide(row);
      await _outbox.enqueue(
        kind: OutboxKind.rideInsert,
        entityClientId: clientId,
      );
    });

    return clientId;
  }

  /// Observa as corridas mais recentes.
  Stream<List<RideEvaluation>> watchRecent({int limit = 50}) => _rides
      .watchRecent(limit: limit)
      .map((rows) => rows.map((row) => row.toDomain()).toList());

  /// Observa as corridas de um período, paginando.
  Stream<List<RideEvaluation>> watchByPeriod({
    required DateTime from,
    required DateTime to,
    int limit = 50,
    int offset = 0,
  }) => _rides
      .watchByPeriod(from: from, to: to, limit: limit, offset: offset)
      .map((rows) => rows.map((row) => row.toDomain()).toList());

  /// Observa o resumo de hoje.
  Stream<DailyTotals> watchToday() => _rides.watchDailyTotals(DateTime.now());

  /// Observa o resumo de um dia específico.
  Stream<DailyTotals> watchDay(DateTime day) => _rides.watchDailyTotals(day);

  /// Registra o desfecho de uma corrida e reenfileira o envio.
  Future<void> setOutcome(String clientId, RideOutcome outcome) async {
    await _db.transaction(() async {
      await _rides.setOutcome(clientId, outcome);
      await _outbox.enqueue(
        kind: OutboxKind.rideInsert,
        entityClientId: clientId,
      );
    });
  }
}
