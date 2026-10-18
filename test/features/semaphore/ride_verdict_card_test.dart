import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rota_plus/app/theme/app_theme.dart';
import 'package:rota_plus/features/goals/domain/entities/work_goals.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_evaluation.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_offer.dart';
import 'package:rota_plus/features/semaphore/domain/usecases/evaluate_ride.dart';
import 'package:rota_plus/features/semaphore/presentation/widgets/ride_verdict_card.dart';

Decimal d(String value) => Decimal.parse(value);

RideEvaluation evaluationFor({required String fare}) {
  final useCase = EvaluateRide(
    costPerKm: d('1.20'),
    goals: WorkGoals(
      minRsPerKm: d('2.00'),
      minRsPerHour: d('30.00'),
      maxPickupKm: d('5'),
    ),
  );

  return useCase(
    RideOffer(
      platform: RidePlatform.uber,
      fare: d(fare),
      pickupKm: d('2'),
      tripKm: d('8'),
      pickupMinutes: 6,
      tripMinutes: 18,
      passengerRating: 4.9,
      pickupRegion: 'Centro',
      capturedAt: DateTime.utc(2026, 10, 17, 12),
    ),
  )!;
}

Widget wrap(
  Widget child, {
  Brightness brightness = Brightness.light,
  double textScale = 1,
  double width = 400,
}) {
  return MaterialApp(
    theme: brightness == Brightness.dark ? AppTheme.dark() : AppTheme.light(),
    home: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
      child: Scaffold(
        body: Center(
          child: SizedBox(width: width, child: child),
        ),
      ),
    ),
  );
}

void main() {
  group('RideVerdictCard', () {
    testWidgets('mostra o veredicto ACEITAR com as quatro métricas', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(RideVerdictCard(evaluation: evaluationFor(fare: '20.00'))),
      );

      expect(find.text('ACEITAR'), findsOneWidget);
      expect(find.text(r'R$/km'), findsOneWidget);
      expect(find.text(r'R$/hora'), findsOneWidget);
      expect(find.text('Lucro'), findsOneWidget);
      expect(find.text('Nota'), findsOneWidget);
      expect(find.text('Uber'), findsOneWidget);
      expect(find.text('Centro'), findsOneWidget);
    });

    testWidgets('mostra RECUSAR e o motivo quando dá prejuízo', (tester) async {
      await tester.pumpWidget(
        wrap(RideVerdictCard(evaluation: evaluationFor(fare: '10.00'))),
      );

      expect(find.text('RECUSAR'), findsOneWidget);
      expect(
        find.text(RejectionReason.belowOperatingCost.label),
        findsOneWidget,
      );
    });

    testWidgets('mostra PENSE no limiar da meta', (tester) async {
      await tester.pumpWidget(
        wrap(RideVerdictCard(evaluation: evaluationFor(fare: '17.50'))),
      );

      expect(find.text('PENSE'), findsOneWidget);
    });

    testWidgets('nunca usa a cor como único significante', (tester) async {
      // O ícone acompanha o texto para que daltônicos distingam o estado.
      await tester.pumpWidget(
        wrap(RideVerdictCard(evaluation: evaluationFor(fare: '20.00'))),
      );

      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });

    testWidgets('não estoura o layout com textScaler 2.0', (tester) async {
      await tester.pumpWidget(
        wrap(
          RideVerdictCard(evaluation: evaluationFor(fare: '20.00')),
          textScale: 2,
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('ACEITAR'), findsOneWidget);
    });

    testWidgets('não estoura o layout em largura estreita', (tester) async {
      await tester.pumpWidget(
        wrap(
          RideVerdictCard(evaluation: evaluationFor(fare: '20.00')),
          width: 300,
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('renderiza no tema escuro', (tester) async {
      await tester.pumpWidget(
        wrap(
          RideVerdictCard(evaluation: evaluationFor(fare: '20.00')),
          brightness: Brightness.dark,
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('ACEITAR'), findsOneWidget);
    });

    testWidgets('chama onDismiss ao fechar', (tester) async {
      var dismissed = false;
      await tester.pumpWidget(
        wrap(
          RideVerdictCard(
            evaluation: evaluationFor(fare: '20.00'),
            onDismiss: () => dismissed = true,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.close_rounded));
      expect(dismissed, isTrue);
    });
  });
}
