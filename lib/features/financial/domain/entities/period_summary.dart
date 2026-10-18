import 'package:decimal/decimal.dart';
import 'package:meta/meta.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_offer.dart';

/// Período de apuração do fechamento de caixa.
enum CashPeriod {
  /// Hoje.
  day,

  /// Últimos sete dias.
  week,

  /// Mês corrente.
  month;

  /// Nome exibido no seletor.
  String get label => switch (this) {
    CashPeriod.day => 'Dia',
    CashPeriod.week => 'Semana',
    CashPeriod.month => 'Mês',
  };

  /// Intervalo coberto, a partir de [now] no fuso local.
  (DateTime from, DateTime to) rangeFrom(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    return switch (this) {
      CashPeriod.day => (today, today.add(const Duration(days: 1))),
      CashPeriod.week => (
        today.subtract(const Duration(days: 6)),
        today.add(const Duration(days: 1)),
      ),
      CashPeriod.month => (
        DateTime(now.year, now.month),
        DateTime(now.year, now.month + 1),
      ),
    };
  }
}

/// Apuração financeira de um período.
///
/// Os valores monetários são `Decimal`: este é o número que o motorista usa
/// para saber se a semana fechou no azul, e erro de arredondamento aqui é
/// defeito reportável.
@immutable
final class PeriodSummary {
  /// Cria a apuração.
  const PeriodSummary({
    required this.ridesEvaluated,
    required this.ridesAccepted,
    required this.grossRevenue,
    required this.operatingCost,
    required this.extraExpenses,
    required this.kmDriven,
    required this.minutesDriven,
    this.minutesWorked = 0,
  });

  /// Apuração vazia.
  static PeriodSummary get empty => PeriodSummary(
    ridesEvaluated: 0,
    ridesAccepted: 0,
    grossRevenue: Decimal.zero,
    operatingCost: Decimal.zero,
    extraExpenses: Decimal.zero,
    kmDriven: Decimal.zero,
    minutesDriven: 0,
  );

  /// Corridas avaliadas no período.
  final int ridesEvaluated;

  /// Corridas aceitas.
  final int ridesAccepted;

  /// Faturamento bruto das aceitas.
  final Decimal grossRevenue;

  /// Custo operacional estimado das aceitas.
  final Decimal operatingCost;

  /// Despesas lançadas manualmente.
  final Decimal extraExpenses;

  /// Quilometragem das corridas aceitas.
  final Decimal kmDriven;

  /// Minutos comprometidos com as corridas aceitas.
  ///
  /// Não é a jornada do motorista: é o tempo dentro das corridas.
  final double minutesDriven;

  /// Minutos de expediente registrados no período.
  ///
  /// Esta é a jornada real, incluindo o tempo parado esperando chamada — que é
  /// justamente o que separa um R$/hora honesto de um otimista.
  final double minutesWorked;

  /// Lucro líquido: bruto menos custo operacional menos despesas.
  Decimal get netProfit => grossRevenue - operatingCost - extraExpenses;

  /// Horas comprometidas com corridas.
  double get hoursDriven => minutesDriven / 60;

  /// Horas de expediente.
  double get hoursWorked => minutesWorked / 60;

  /// Indica se há expediente registrado no período.
  bool get hasWorkSessions => minutesWorked > 0;

  /// Receita por hora em corrida. Nula sem tempo registrado.
  Decimal? get revenuePerHour => _perHour(grossRevenue, hoursDriven);

  /// Lucro por hora em corrida. Nulo sem tempo registrado.
  Decimal? get profitPerHour => _perHour(netProfit, hoursDriven);

  /// Receita por hora de expediente. Nula sem expediente registrado.
  Decimal? get revenuePerWorkedHour => _perHour(grossRevenue, hoursWorked);

  /// Lucro por hora de expediente. Nulo sem expediente registrado.
  Decimal? get profitPerWorkedHour => _perHour(netProfit, hoursWorked);

  /// Proporção do expediente efetivamente dentro de corridas, de 0 a 1.
  ///
  /// Mostra quanto do tempo o motorista passou parado. É o indicador que
  /// explica por que o R$/hora de expediente é sempre menor que o de corrida.
  double? get occupancyRate {
    if (minutesWorked <= 0) return null;
    return (minutesDriven / minutesWorked).clamp(0.0, 1.0);
  }

  static Decimal? _perHour(Decimal value, double hours) {
    if (hours <= 0) return null;
    return (value / Decimal.parse(hours.toString()))
        .toDecimal(scaleOnInfinitePrecision: 2)
        .round(scale: 2);
  }

  /// Taxa de aceitação, de 0 a 1. Nula sem corridas avaliadas.
  double? get acceptanceRate =>
      ridesEvaluated == 0 ? null : ridesAccepted / ridesEvaluated;

  /// Indica se o período fechou no prejuízo.
  bool get isLoss => netProfit < Decimal.zero;
}

/// Ponto diário, para o gráfico de evolução.
@immutable
final class DailyPoint {
  /// Cria o ponto.
  const DailyPoint({
    required this.day,
    required this.grossRevenue,
    required this.netProfit,
    required this.rides,
  });

  /// Dia referente, à meia-noite local.
  final DateTime day;

  /// Faturamento bruto do dia.
  final Decimal grossRevenue;

  /// Lucro do dia, sem descontar despesas manuais.
  final Decimal netProfit;

  /// Corridas aceitas no dia.
  final int rides;
}

/// Desempenho por plataforma.
@immutable
final class PlatformStat {
  /// Cria a estatística.
  const PlatformStat({
    required this.platform,
    required this.offers,
    required this.accepted,
    required this.avgRsPerKm,
    required this.avgRsPerHour,
    required this.totalProfit,
  });

  /// Plataforma avaliada.
  final RidePlatform platform;

  /// Ofertas recebidas.
  final int offers;

  /// Ofertas aceitas.
  final int accepted;

  /// Média de R$/km das ofertas.
  final Decimal avgRsPerKm;

  /// Média de R$/hora das ofertas.
  final Decimal avgRsPerHour;

  /// Lucro acumulado nas aceitas.
  final Decimal totalProfit;

  /// Taxa de aceitação, de 0 a 1.
  double? get acceptanceRate => offers == 0 ? null : accepted / offers;
}

/// Célula do mapa de calor: um dia da semana numa faixa de hora.
@immutable
final class HourStat {
  /// Cria a célula.
  const HourStat({
    required this.weekday,
    required this.hour,
    required this.offers,
    required this.avgRsPerKm,
  });

  /// Dia da semana, de 0 (domingo) a 6 (sábado).
  final int weekday;

  /// Hora do dia, de 0 a 23.
  final int hour;

  /// Ofertas recebidas nessa combinação.
  final int offers;

  /// Média de R$/km.
  final Decimal avgRsPerKm;
}
