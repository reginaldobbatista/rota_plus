import 'package:decimal/decimal.dart';
import 'package:rota_plus/features/goals/domain/entities/work_goals.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_evaluation.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_offer.dart';
import 'package:rota_plus/features/semaphore/domain/usecases/evaluate_ride.dart';

/// Atalho para montar um [Decimal] a partir de literal.
Decimal d(String value) => Decimal.parse(value);

/// Metas padrão de teste: R$ 2,00/km e R$ 30,00/hora.
WorkGoals testGoals() => WorkGoals(
  minRsPerKm: d('2.00'),
  minRsPerHour: d('30.00'),
  maxPickupKm: d('5'),
);

/// Avaliador padrão de teste, com custo de R$ 1,20/km.
EvaluateRide testEvaluator() =>
    EvaluateRide(costPerKm: d('1.20'), goals: testGoals());

/// Monta uma oferta de corrida.
RideOffer testOffer({
  String fare = '20.00',
  String pickupKm = '2',
  String tripKm = '8',
  double pickupMinutes = 6,
  double tripMinutes = 18,
  double? rating = 4.9,
  RidePlatform platform = RidePlatform.uber,
  DateTime? capturedAt,
}) => RideOffer(
  platform: platform,
  fare: d(fare),
  pickupKm: d(pickupKm),
  tripKm: d(tripKm),
  pickupMinutes: pickupMinutes,
  tripMinutes: tripMinutes,
  passengerRating: rating,
  pickupRegion: 'Centro',
  capturedAt: capturedAt ?? DateTime.utc(2026, 10, 17, 12),
);

/// Avalia uma oferta com o avaliador padrão.
RideEvaluation testEvaluation({
  String fare = '20.00',
  RidePlatform platform = RidePlatform.uber,
  DateTime? capturedAt,
}) => testEvaluator()(
  testOffer(fare: fare, platform: platform, capturedAt: capturedAt),
)!;
