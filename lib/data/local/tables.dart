import 'package:drift/drift.dart';
import 'package:rota_plus/data/local/converters/decimal_converter.dart';
import 'package:rota_plus/features/expenses/domain/entities/expense.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_evaluation.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_offer.dart';

/// Corridas avaliadas, espelhando `public.ride_evaluations`.
///
/// A chave primária é o `clientId` gerado no dispositivo: é ele que torna o
/// reenvio idempotente quando o outbox tenta subir a mesma linha duas vezes.
/// A tabela é *insert-only* — uma corrida avaliada é fato histórico.
@DataClassName('LocalRide')
class LocalRideEvaluations extends Table {
  /// UUID gerado no dispositivo.
  TextColumn get clientId => text()();

  /// Plataforma de origem da oferta.
  TextColumn get platform => textEnum<RidePlatform>()();

  /// Momento da avaliação.
  DateTimeColumn get occurredAt => dateTime()();

  /// Valor oferecido pela corrida.
  TextColumn get fare => text().map(const DecimalConverter())();

  /// Distância até o passageiro, em km.
  TextColumn get pickupKm => text().map(const DecimalConverter())();

  /// Distância da corrida, em km.
  TextColumn get tripKm => text().map(const DecimalConverter())();

  /// Tempo até o passageiro, em minutos.
  RealColumn get pickupMinutes => real().withDefault(const Constant(0))();

  /// Tempo da corrida, em minutos.
  RealColumn get tripMinutes => real().withDefault(const Constant(0))();

  /// Nota do passageiro, quando informada.
  RealColumn get passengerRating => real().nullable()();

  /// Nome do bairro ou região de embarque.
  TextColumn get pickupRegion => text().nullable()();

  /// Multiplicador de tarifa dinâmica, quando informado.
  TextColumn get surgeMultiplier =>
      text().map(const DecimalConverter()).nullable()();

  /// Receita por quilômetro.
  TextColumn get rsPerKm => text().map(const DecimalConverter())();

  /// Receita por hora.
  TextColumn get rsPerHour => text().map(const DecimalConverter())();

  /// Custo por km usado na avaliação.
  TextColumn get costPerKmUsed => text().map(const DecimalConverter())();

  /// Custo operacional estimado.
  TextColumn get operatingCost => text().map(const DecimalConverter())();

  /// Lucro real.
  TextColumn get realProfit => text().map(const DecimalConverter())();

  /// Margem sobre a tarifa, em percentual.
  TextColumn get marginPercent =>
      text().map(const DecimalConverter()).nullable()();

  /// Veredicto do semáforo.
  TextColumn get verdict => textEnum<RideVerdict>()();

  /// Desfecho: o motorista aceitou, recusou, expirou.
  TextColumn get outcome => textEnum<RideOutcome>()();

  /// Sessão de trabalho à qual a corrida pertence.
  TextColumn get workSessionClientId => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {clientId};
}

/// Despesas registradas pelo motorista, espelhando `public.expenses`.
@DataClassName('LocalExpense')
class LocalExpenses extends Table {
  /// UUID gerado no dispositivo.
  TextColumn get clientId => text()();

  /// Categoria da despesa.
  TextColumn get category => textEnum<ExpenseCategory>()();

  /// Valor pago.
  TextColumn get amount => text().map(const DecimalConverter())();

  /// Litros abastecidos, quando a categoria é combustível.
  TextColumn get liters => text().map(const DecimalConverter()).nullable()();

  /// Leitura do odômetro, para aferir o consumo real.
  TextColumn get odometerKm =>
      text().map(const DecimalConverter()).nullable()();

  /// Descrição livre.
  TextColumn get description => text().nullable()();

  /// Momento da despesa.
  DateTimeColumn get occurredAt => dateTime()();

  /// Momento da última alteração, base do last-write-wins na sincronização.
  DateTimeColumn get updatedAt => dateTime()();

  /// Marca de exclusão lógica: a linha precisa sobreviver até sincronizar.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  /// Sessão de trabalho à qual a despesa pertence.
  TextColumn get workSessionClientId => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {clientId};
}

/// Sessões de trabalho, base do cálculo de horas trabalhadas.
@DataClassName('LocalWorkSession')
class LocalWorkSessions extends Table {
  /// UUID gerado no dispositivo.
  TextColumn get clientId => text()();

  /// Início da sessão.
  DateTimeColumn get startedAt => dateTime()();

  /// Fim da sessão. Nulo enquanto estiver aberta.
  DateTimeColumn get endedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {clientId};
}

/// Tipo de operação pendente de sincronização.
enum OutboxKind {
  /// Inserção de corrida avaliada.
  rideInsert,

  /// Criação ou alteração de despesa.
  expenseUpsert,

  /// Exclusão lógica de despesa.
  expenseDelete,

  /// Criação ou alteração de sessão de trabalho.
  workSessionUpsert,
}

/// Fila de operações a enviar ao Supabase.
///
/// A escrita local e o enfileiramento acontecem na mesma transação: ou os dois
/// ocorrem, ou nenhum. É isso que garante que nada se perde quando o app é
/// morto pelo sistema no meio de um registro.
@DataClassName('OutboxEntry')
class OutboxEntries extends Table {
  /// Ordem de enfileiramento.
  IntColumn get id => integer().autoIncrement()();

  /// Tipo de operação.
  TextColumn get kind => textEnum<OutboxKind>()();

  /// `clientId` da entidade afetada.
  TextColumn get entityClientId => text()();

  /// Momento do enfileiramento.
  DateTimeColumn get createdAt => dateTime()();

  /// Número de tentativas de envio já feitas.
  IntColumn get attempts => integer().withDefault(const Constant(0))();

  /// Erro da última tentativa, para diagnóstico.
  TextColumn get lastError => text().nullable()();

  @override
  List<String> get customConstraints => <String>[
    // Reenfileirar a mesma entidade substitui a pendência em vez de duplicá-la.
    'UNIQUE (kind, entity_client_id)',
  ];
}
