import 'package:decimal/decimal.dart';
import 'package:meta/meta.dart';

/// Metas do perfil de trabalho ativo.
///
/// São os critérios que [EvaluateRide] usa para decidir o veredicto do
/// semáforo. Vêm do perfil ativo e ficam em memória — o caminho crítico do
/// overlay não faz I/O para obtê-las.
@immutable
final class WorkGoals {
  /// Cria as metas de trabalho.
  const WorkGoals({
    required this.minRsPerKm,
    required this.minRsPerHour,
    this.minPassengerRating = 4.5,
    Decimal? maxPickupKm,
    Decimal? thinkTolerancePercent,
  }) : _maxPickupKm = maxPickupKm,
       _thinkTolerancePercent = thinkTolerancePercent;

  /// Meta mínima de R$/km.
  final Decimal minRsPerKm;

  /// Meta mínima de R$/hora.
  final Decimal minRsPerHour;

  /// Nota mínima aceitável do passageiro.
  final double minPassengerRating;

  final Decimal? _maxPickupKm;
  final Decimal? _thinkTolerancePercent;

  /// Distância máxima aceitável até o embarque, em km. Padrão: 5 km.
  Decimal get maxPickupKm => _maxPickupKm ?? Decimal.fromInt(5);

  /// Tolerância do estado "PENSE", em percentual. Padrão: 15%.
  ///
  /// Uma oferta que fica até este percentual abaixo da meta é amarela em vez de
  /// vermelha — a meta é um alvo, não um precipício.
  Decimal get thinkTolerancePercent =>
      _thinkTolerancePercent ?? Decimal.fromInt(15);
}
