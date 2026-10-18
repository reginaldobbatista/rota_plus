import 'package:flutter_test/flutter_test.dart';
import 'package:rota_plus/core/services/tts_service.dart';
import 'package:rota_plus/features/goals/domain/entities/work_goals.dart';
import 'package:rota_plus/features/semaphore/domain/usecases/evaluate_ride.dart';

import '../support/fixtures.dart';

void main() {
  group('TtsService.phraseFor', () {
    test('anuncia corrida boa com o valor por km', () {
      final phrase = TtsService.phraseFor(testEvaluation());

      expect(phrase, 'Corrida boa! 2,00 por quilômetro.');
    });

    test('pede atenção na zona amarela, sem citar número', () {
      // Na dúvida o motorista precisa olhar o cartão; recitar métrica aqui só
      // ocuparia o tempo em que ele deveria estar decidindo.
      final phrase = TtsService.phraseFor(testEvaluation(fare: '17.50'));

      expect(phrase, 'Atenção! Corrida na média, avalie.');
    });

    test('explica o prejuízo ao recusar por custo', () {
      final phrase = TtsService.phraseFor(testEvaluation(fare: '10.00'));

      expect(phrase, contains('abaixo do seu custo'));
      expect(phrase, contains('1,00'));
    });

    test('explica a recusa por embarque longe', () {
      final useCase = EvaluateRide(costPerKm: d('1.20'), goals: testGoals());
      final evaluation = useCase(
        testOffer(fare: '60.00', pickupKm: '10', tripKm: '10'),
      )!;

      final phrase = TtsService.phraseFor(evaluation);

      expect(phrase, 'Corrida ruim. Embarque muito longe.');
    });

    test('explica a recusa por nota baixa', () {
      final useCase = EvaluateRide(costPerKm: d('1.20'), goals: testGoals());
      final evaluation = useCase(testOffer(rating: 3.2))!;

      final phrase = TtsService.phraseFor(evaluation);

      expect(phrase, 'Corrida ruim. Nota do passageiro baixa.');
    });

    test('toda frase cabe em poucos segundos de fala', () {
      // O motorista está dirigindo: frase longa competiria com a instrução do
      // navegador justamente na hora de uma conversão.
      final frases = [
        TtsService.phraseFor(testEvaluation()),
        TtsService.phraseFor(testEvaluation(fare: '17.50')),
        TtsService.phraseFor(testEvaluation(fare: '10.00')),
      ];

      for (final frase in frases) {
        expect(frase.split(' ').length, lessThanOrEqualTo(10));
      }
    });

    test('usa vírgula decimal, como se fala em português', () {
      final phrase = TtsService.phraseFor(testEvaluation(fare: '28.00'));

      expect(phrase, contains('2,80'));
      expect(phrase, isNot(contains('2.80')));
    });

    test('não lê o símbolo da moeda', () {
      // "R$ 2,80 por quilômetro" sairia como "erre cifrão" em alguns motores.
      final phrase = TtsService.phraseFor(testEvaluation());

      expect(phrase, isNot(contains(r'R$')));
    });
  });

  group('WorkGoals', () {
    test('tolerância padrão é de 15%', () {
      final goals = WorkGoals(minRsPerKm: d('2'), minRsPerHour: d('30'));

      expect(goals.thinkTolerancePercent, d('15'));
      expect(goals.maxPickupKm, d('5'));
    });
  });
}
