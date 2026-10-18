import 'package:decimal/decimal.dart';
import 'package:rota_plus/core/money/decimal_x.dart';
import 'package:rota_plus/features/goals/domain/entities/work_goals.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_evaluation.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_offer.dart';

/// Avalia uma oferta de corrida e produz o veredicto do semáforo.
///
/// Este é o caminho crítico do produto: o orçamento é de 120 ms entre o evento
/// de acessibilidade e o primeiro frame do overlay. Por isso o caso de uso é
/// **puro** — recebe custo e metas já resolvidos, não faz I/O, não toca em
/// banco e não chama rede.
///
/// Regra de decisão, em ordem de precedência:
///
/// 1. Critério eliminatório violado (embarque longe demais, nota baixa) → recusar.
/// 2. R$/km abaixo do custo operacional → recusar (a corrida dá prejuízo).
/// 3. Ambas as metas atingidas → aceitar.
/// 4. Ambas as metas dentro da tolerância → pensar.
/// 5. Caso contrário → recusar.
final class EvaluateRide {
  /// Cria o caso de uso com o custo por km e as metas do perfil ativo.
  const EvaluateRide({required this.costPerKm, required this.goals});

  /// Custo por quilômetro do perfil ativo, já calculado e cacheado.
  final Decimal costPerKm;

  /// Metas do perfil ativo.
  final WorkGoals goals;

  /// Avalia [offer]. Retorna `null` quando a captura está incompleta.
  RideEvaluation? call(RideOffer offer) {
    if (!offer.isEvaluable) return null;

    final totalKm = offer.totalKm;
    final rsPerKm = offer.fare.divideBy(totalKm);
    final rsPerHour = offer.fare.divideBy(offer.totalHours.asDecimal);

    final operatingCost = (costPerKm * totalKm).withScale();
    final realProfit = (offer.fare - operatingCost).withScale();
    final marginRatio = realProfit.divideOrNull(offer.fare, scale: 6);
    final marginPercent = marginRatio == null
        ? Decimal.zero
        : (marginRatio * Decimal.fromInt(100)).withScale();

    final reasons = _collectReasons(offer, rsPerKm, rsPerHour);
    final verdict = _decide(reasons, rsPerKm, rsPerHour);

    return RideEvaluation(
      offer: offer,
      verdict: verdict,
      rsPerKm: rsPerKm,
      rsPerHour: rsPerHour,
      costPerKmUsed: costPerKm,
      operatingCost: operatingCost,
      realProfit: realProfit,
      marginPercent: marginPercent,
      reasons: reasons,
    );
  }

  List<RejectionReason> _collectReasons(
    RideOffer offer,
    Decimal rsPerKm,
    Decimal rsPerHour,
  ) {
    final reasons = <RejectionReason>[];

    if (rsPerKm < costPerKm) {
      reasons.add(RejectionReason.belowOperatingCost);
    }
    if (offer.pickupKm > goals.maxPickupKm) {
      reasons.add(RejectionReason.pickupTooFar);
    }
    final rating = offer.passengerRating;
    if (rating != null && rating < goals.minPassengerRating) {
      reasons.add(RejectionReason.lowPassengerRating);
    }
    if (rsPerKm < goals.minRsPerKm) {
      reasons.add(RejectionReason.belowKmGoal);
    }
    if (rsPerHour < goals.minRsPerHour) {
      reasons.add(RejectionReason.belowHourGoal);
    }

    return reasons;
  }

  RideVerdict _decide(
    List<RejectionReason> reasons,
    Decimal rsPerKm,
    Decimal rsPerHour,
  ) {
    // Eliminatórios e prejuízo não admitem tolerância.
    const blocking = {
      RejectionReason.belowOperatingCost,
      RejectionReason.pickupTooFar,
      RejectionReason.lowPassengerRating,
    };
    if (reasons.any(blocking.contains)) return RideVerdict.reject;

    final metKm = rsPerKm >= goals.minRsPerKm;
    final metHour = rsPerHour >= goals.minRsPerHour;
    if (metKm && metHour) return RideVerdict.accept;

    final tolerance =
        Decimal.one -
        goals.thinkTolerancePercent.divideBy(Decimal.fromInt(100), scale: 6);
    final nearKm = rsPerKm >= (goals.minRsPerKm * tolerance);
    final nearHour = rsPerHour >= (goals.minRsPerHour * tolerance);

    return nearKm && nearHour ? RideVerdict.think : RideVerdict.reject;
  }
}
