import 'package:drift/drift.dart';
import 'package:rota_plus/data/local/database.dart';
import 'package:rota_plus/data/local/tables.dart';

part 'report_dao.g.dart';

/// Linhas brutas de um período, prontas para agregação.
class PeriodRows {
  /// Agrupa corridas e despesas do período.
  const PeriodRows({required this.rides, required this.expenses});

  /// Corridas avaliadas no período.
  final List<LocalRide> rides;

  /// Despesas lançadas no período.
  final List<LocalExpense> expenses;
}

/// Leitura das linhas que alimentam os relatórios.
///
/// Devolve **linhas**, não somas. A agregação acontece em Dart, com `Decimal`,
/// por dois motivos:
///
/// 1. `SUM` sobre coluna TEXT no SQLite converte para ponto flutuante e perde
///    precisão — inaceitável no fechamento de caixa.
/// 2. Agrupar por dia ou por hora em SQL exigiria embutir o fuso na consulta.
///    Em Dart, `toLocal()` resolve isso sem hardcode.
///
/// O custo é irrelevante: o banco é local e um mês tem ordem de milhares de
/// linhas. A regra de "agregar no servidor" do descritivo existe para evitar
/// baixar dados pela rede, o que não se aplica aqui.
@DriftAccessor(tables: [LocalRideEvaluations, LocalExpenses])
class ReportDao extends DatabaseAccessor<AppDatabase> with _$ReportDaoMixin {
  /// Cria o DAO.
  ReportDao(super.db);

  /// Observa as linhas de um período, reemitindo quando qualquer das duas
  /// tabelas muda.
  Stream<PeriodRows> watchPeriod({
    required DateTime from,
    required DateTime to,
  }) {
    return customSelect(
      'SELECT 1',
      readsFrom: {localRideEvaluations, localExpenses},
    ).watch().asyncMap((_) => fetchPeriod(from: from, to: to));
  }

  /// Lê as linhas de um período uma única vez.
  Future<PeriodRows> fetchPeriod({
    required DateTime from,
    required DateTime to,
  }) async {
    final rides =
        await (select(localRideEvaluations)
              ..where((t) => t.occurredAt.isBiggerOrEqualValue(from))
              ..where((t) => t.occurredAt.isSmallerThanValue(to))
              ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)]))
            .get();

    final expenses =
        await (select(localExpenses)
              ..where((t) => t.deletedAt.isNull())
              ..where((t) => t.occurredAt.isBiggerOrEqualValue(from))
              ..where((t) => t.occurredAt.isSmallerThanValue(to)))
            .get();

    return PeriodRows(rides: rides, expenses: expenses);
  }
}
