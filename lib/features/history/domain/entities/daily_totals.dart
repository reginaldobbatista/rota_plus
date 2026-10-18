import 'package:meta/meta.dart';

/// Resumo de um dia de trabalho.
///
/// Vive no domínio, e não junto do DAO, para que a camada de apresentação não
/// precise importar nada do Drift para exibir o resumo.
///
/// Os totais monetários são `double` de propósito: vêm de uma soma feita em SQL
/// e servem para **indicador de tela**. O fechamento de caixa oficial soma em
/// `Decimal`, a partir das linhas.
@immutable
final class DailyTotals {
  /// Cria o resumo.
  const DailyTotals({
    required this.evaluated,
    required this.accepted,
    required this.rejected,
    required this.grossRevenue,
    required this.netProfit,
  });

  /// Resumo vazio, para quando ainda não há corridas.
  static const DailyTotals empty = DailyTotals(
    evaluated: 0,
    accepted: 0,
    rejected: 0,
    grossRevenue: 0,
    netProfit: 0,
  );

  /// Corridas avaliadas.
  final int evaluated;

  /// Corridas aceitas.
  final int accepted;

  /// Corridas recusadas.
  final int rejected;

  /// Faturamento bruto das aceitas.
  final double grossRevenue;

  /// Lucro das aceitas, já descontado o custo operacional.
  final double netProfit;

  /// Taxa de aceitação, de 0 a 1. Nula quando nada foi avaliado.
  double? get acceptanceRate => evaluated == 0 ? null : accepted / evaluated;
}
