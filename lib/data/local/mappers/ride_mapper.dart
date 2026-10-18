import 'package:decimal/decimal.dart';
import 'package:rota_plus/data/local/database.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_evaluation.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_offer.dart';

/// Conversão entre a avaliação de domínio e a linha do banco local.
extension RideEvaluationToRow on RideEvaluation {
  /// Monta a linha a persistir.
  ///
  /// Os motivos da recusa **não** são persistidos de propósito: são derivados
  /// das metas vigentes no momento da avaliação e recalculá-los depois, com
  /// metas diferentes, daria um resultado enganoso. O que fica gravado é a
  /// métrica, que é fato.
  LocalRide toRow({required String clientId}) => LocalRide(
    clientId: clientId,
    platform: offer.platform,
    occurredAt: offer.capturedAt,
    fare: offer.fare,
    pickupKm: offer.pickupKm,
    tripKm: offer.tripKm,
    pickupMinutes: offer.pickupMinutes,
    tripMinutes: offer.tripMinutes,
    passengerRating: offer.passengerRating,
    pickupRegion: offer.pickupRegion,
    surgeMultiplier: offer.surgeMultiplier,
    rsPerKm: rsPerKm,
    rsPerHour: rsPerHour,
    costPerKmUsed: costPerKmUsed,
    operatingCost: operatingCost,
    realProfit: realProfit,
    marginPercent: marginPercent,
    verdict: verdict,
    outcome: outcome,
    workSessionClientId: workSessionClientId,
  );
}

/// Conversão da linha do banco local de volta para o domínio.
extension RowToRideEvaluation on LocalRide {
  /// Reconstrói a avaliação a partir da linha persistida.
  RideEvaluation toDomain() => RideEvaluation(
    offer: RideOffer(
      platform: platform,
      fare: fare,
      pickupKm: pickupKm,
      tripKm: tripKm,
      pickupMinutes: pickupMinutes,
      tripMinutes: tripMinutes,
      passengerRating: passengerRating,
      pickupRegion: pickupRegion,
      surgeMultiplier: surgeMultiplier,
      capturedAt: occurredAt,
    ),
    verdict: verdict,
    rsPerKm: rsPerKm,
    rsPerHour: rsPerHour,
    costPerKmUsed: costPerKmUsed,
    operatingCost: operatingCost,
    realProfit: realProfit,
    marginPercent: marginPercent ?? Decimal.zero,
    clientId: clientId,
    outcome: outcome,
    workSessionClientId: workSessionClientId,
  );

  /// Monta o payload de sincronização direto da linha.
  Map<String, Object?> toSyncPayload() => <String, Object?>{
    'client_id': clientId,
    'platform': _platformToSql(platform),
    'occurred_at': occurredAt.toUtc().toIso8601String(),
    'fare': fare.toString(),
    'pickup_km': pickupKm.toString(),
    'trip_km': tripKm.toString(),
    'pickup_minutes': pickupMinutes,
    'trip_minutes': tripMinutes,
    'passenger_rating': passengerRating,
    'pickup_region': pickupRegion,
    'surge_multiplier': surgeMultiplier?.toString(),
    'rs_per_km': rsPerKm.toString(),
    'rs_per_hour': rsPerHour.toString(),
    'cost_per_km_used': costPerKmUsed.toString(),
    'operating_cost': operatingCost.toString(),
    'real_profit': realProfit.toString(),
    'margin_pct': marginPercent?.toString(),
    'verdict': _verdictToSql(verdict),
    'outcome': outcome.name,
    'work_session_id': workSessionClientId,
  };
}

/// Nomes do enum `public.ride_platform` no Postgres.
///
/// O Dart usa `ninetyNine` e o SQL usa `ninety_nine`: um mapa explícito evita
/// depender de conversão automática de case.
String _platformToSql(RidePlatform platform) => switch (platform) {
  RidePlatform.uber => 'uber',
  RidePlatform.ninetyNine => 'ninety_nine',
  RidePlatform.indrive => 'indrive',
  RidePlatform.other => 'other',
};

/// Nomes do enum `public.ride_verdict` no Postgres.
String _verdictToSql(RideVerdict verdict) => switch (verdict) {
  RideVerdict.accept => 'accept',
  RideVerdict.think => 'think',
  RideVerdict.reject => 'reject',
};
