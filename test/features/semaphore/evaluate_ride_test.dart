import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rota_plus/features/goals/domain/entities/work_goals.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_evaluation.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_offer.dart';
import 'package:rota_plus/features/semaphore/domain/usecases/evaluate_ride.dart';

Decimal d(String value) => Decimal.parse(value);

RideOffer offer({
  String fare = '20.00',
  String pickupKm = '2',
  String tripKm = '8',
  double pickupMinutes = 6,
  double tripMinutes = 18,
  double? rating = 4.9,
}) => RideOffer(
  platform: RidePlatform.uber,
  fare: d(fare),
  pickupKm: d(pickupKm),
  tripKm: d(tripKm),
  pickupMinutes: pickupMinutes,
  tripMinutes: tripMinutes,
  passengerRating: rating,
  capturedAt: DateTime.utc(2026, 10, 17, 12),
);

void main() {
  // Custo de R$ 1,20/km e metas de R$ 2,00/km e R$ 30,00/hora.
  final goals = WorkGoals(
    minRsPerKm: d('2.00'),
    minRsPerHour: d('30.00'),
    maxPickupKm: d('5'),
  );
  final useCase = EvaluateRide(costPerKm: d('1.20'), goals: goals);

  group('EvaluateRide · métricas', () {
    test('calcula R\$/km sobre a distância total, não só a da corrida', () {
      // R$ 20 / (2 + 8) km = R$ 2,00/km
      final result = useCase(offer())!;

      expect(result.rsPerKm, d('2'));
    });

    test('calcula R\$/hora sobre o tempo total comprometido', () {
      // 24 min = 0,4 h → R$ 20 / 0,4 = R$ 50,00/hora
      final result = useCase(offer())!;

      expect(result.rsPerHour, d('50'));
    });

    test('calcula custo operacional e lucro real', () {
      // 10 km × R$ 1,20 = R$ 12,00 de custo → lucro R$ 8,00
      final result = useCase(offer())!;

      expect(result.operatingCost, d('12'));
      expect(result.realProfit, d('8'));
      expect(result.marginPercent, d('40'));
      expect(result.isLoss, isFalse);
    });

    test('expõe o custo por km usado, para auditoria do veredicto', () {
      final result = useCase(offer())!;

      expect(result.costPerKmUsed, d('1.20'));
    });
  });

  group('EvaluateRide · veredicto', () {
    test('aceita quando as duas metas são atingidas', () {
      final result = useCase(offer())!;

      expect(result.verdict, RideVerdict.accept);
      expect(result.reasons, isEmpty);
    });

    test('recusa quando o R\$/km fica abaixo do custo operacional', () {
      // R$ 10 / 10 km = R$ 1,00/km, abaixo do custo de R$ 1,20
      final result = useCase(offer(fare: '10.00'))!;

      expect(result.verdict, RideVerdict.reject);
      expect(result.realProfit, lessThan(Decimal.zero));
      expect(result.isLoss, isTrue);
      expect(result.reasons, contains(RejectionReason.belowOperatingCost));
    });

    test('pensa quando fica dentro da tolerância de 15%', () {
      // R$ 17,50 / 10 km = R$ 1,75/km. Meta 2,00; piso da tolerância 1,70.
      // R$ 17,50 / 0,4 h = R$ 43,75/hora, acima da meta.
      final result = useCase(offer(fare: '17.50'))!;

      expect(result.verdict, RideVerdict.think);
      expect(result.reasons, contains(RejectionReason.belowKmGoal));
    });

    test('recusa quando fura a tolerância', () {
      // R$ 16,00 / 10 km = R$ 1,60/km, abaixo do piso de 1,70
      final result = useCase(offer(fare: '16.00'))!;

      expect(result.verdict, RideVerdict.reject);
    });

    test('recusa por embarque longe, mesmo com métricas boas', () {
      // R$ 60 / 20 km = R$ 3,00/km — ótimo. Mas 10 km de deslocamento.
      final result = useCase(
        offer(fare: '60.00', pickupKm: '10', tripKm: '10'),
      )!;

      expect(result.verdict, RideVerdict.reject);
      expect(result.reasons, contains(RejectionReason.pickupTooFar));
      expect(result.rsPerKm, d('3'));
    });

    test('recusa por nota baixa do passageiro', () {
      final result = useCase(offer(rating: 3.8))!;

      expect(result.verdict, RideVerdict.reject);
      expect(result.reasons, contains(RejectionReason.lowPassengerRating));
    });

    test('não penaliza oferta sem nota informada', () {
      final result = useCase(offer(rating: null))!;

      expect(result.verdict, RideVerdict.accept);
      expect(
        result.reasons,
        isNot(contains(RejectionReason.lowPassengerRating)),
      );
    });

    test('recusa quando só o R\$/hora está abaixo da meta', () {
      // R$ 20 / 10 km = R$ 2,00/km (meta ok), mas 120 min → R$ 10/hora.
      // 10,00 < piso de 25,50 (30 × 0,85) → recusa.
      final result = useCase(offer(pickupMinutes: 20, tripMinutes: 100))!;

      expect(result.verdict, RideVerdict.reject);
      expect(result.reasons, contains(RejectionReason.belowHourGoal));
    });

    test('prejuízo tem precedência sobre a tolerância', () {
      final tightGoals = WorkGoals(
        minRsPerKm: d('1.00'),
        minRsPerHour: d('1.00'),
      );
      final tolerant = EvaluateRide(costPerKm: d('1.20'), goals: tightGoals);

      // R$ 1,10/km passa as metas, mas fica abaixo do custo de 1,20.
      final result = tolerant(offer(fare: '11.00'))!;

      expect(result.verdict, RideVerdict.reject);
      expect(result.primaryReason, RejectionReason.belowOperatingCost);
    });
  });

  group('EvaluateRide · captura incompleta', () {
    test('devolve null quando a quilometragem é zero', () {
      final result = useCase(offer(pickupKm: '0', tripKm: '0'));

      expect(result, isNull);
    });

    test('devolve null quando o tempo é zero', () {
      final result = useCase(offer(pickupMinutes: 0, tripMinutes: 0));

      expect(result, isNull);
    });
  });
}
