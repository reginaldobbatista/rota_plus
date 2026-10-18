import 'package:flutter_test/flutter_test.dart';
import 'package:rota_plus/features/semaphore/data/parsers/ride_offer_parser.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_offer.dart';

import '../../support/fixtures.dart';

void main() {
  CapturedScreen screen(
    List<String> lines, {
    String package = 'com.ubercab.driver',
  }) => CapturedScreen(
    packageName: package,
    lines: lines,
    capturedAt: DateTime.utc(2026, 10, 18, 12),
  );

  group('StandardRideParser · oferta típica da Uber', () {
    final uberScreen = screen([
      'UberX',
      r'R$ 24,50',
      '4,85',
      '12 min (4,2 km) de distância',
      'Av. Brasil, Centro',
      '25 min (14,8 km) de viagem',
      'Pricumã',
      'Aceitar',
    ]);

    test('extrai o valor da corrida', () {
      final offer = RideParsers.parse(uberScreen)!;

      expect(offer.fare, d('24.50'));
      expect(offer.platform, RidePlatform.uber);
    });

    test('separa deslocamento e viagem na ordem em que aparecem', () {
      final offer = RideParsers.parse(uberScreen)!;

      expect(offer.pickupKm, d('4.2'));
      expect(offer.pickupMinutes, 12);
      expect(offer.tripKm, d('14.8'));
      expect(offer.tripMinutes, 25);
      expect(offer.totalKm, d('19'));
    });

    test('extrai a nota do passageiro', () {
      final offer = RideParsers.parse(uberScreen)!;

      expect(offer.passengerRating, 4.85);
    });

    test('a oferta resultante é avaliável', () {
      final offer = RideParsers.parse(uberScreen)!;

      expect(offer.isEvaluable, isTrue);
      expect(testEvaluator()(offer), isNotNull);
    });
  });

  group('StandardRideParser · variações de formato', () {
    test('aceita ponto como separador decimal', () {
      final offer = RideParsers.parse(
        screen([r'R$ 32.00', '8 min (2.5 km)', '20 min (11.0 km)']),
      )!;

      expect(offer.fare, d('32'));
      expect(offer.pickupKm, d('2.5'));
    });

    test('aceita valor sem espaço após o símbolo', () {
      final offer = RideParsers.parse(
        screen([r'R$18,90', '5 min (1,2 km)', '15 min (6,0 km)']),
      )!;

      expect(offer.fare, d('18.90'));
    });

    test('aceita valor com separador de milhar', () {
      final offer = RideParsers.parse(
        screen([r'R$ 1.250,00', '10 min (3 km)', '180 min (420 km)']),
      )!;

      expect(offer.fare, d('1250'));
    });

    test('aceita nota com uma casa decimal', () {
      final offer = RideParsers.parse(
        screen([r'R$ 20,00', '4,9', '5 min (2 km)', '10 min (5 km)']),
      )!;

      expect(offer.passengerRating, 4.9);
    });
  });

  group('StandardRideParser · armadilhas', () {
    test('não confunde a nota do passageiro com o valor', () {
      // 4,85 é nota, não tarifa. Um parser ingênuo pegaria o primeiro número
      // com duas casas e avaliaria a corrida como R$ 4,85.
      final offer = RideParsers.parse(
        screen(['4,85', r'R$ 22,00', '6 min (2 km)', '18 min (9 km)']),
      )!;

      expect(offer.fare, d('22'));
      expect(offer.passengerRating, 4.85);
    });

    test('usa o maior valor quando há adicional na tela', () {
      // Telas mostram "inclui R$ 2,00 de adicional" antes do total.
      final offer = RideParsers.parse(
        screen([
          r'Inclui R$ 6,00 de dinâmica',
          r'R$ 31,00',
          '7 min (3 km)',
          '22 min (12 km)',
        ]),
      )!;

      expect(offer.fare, d('31'));
    });

    test('não guarda endereço com número de porta', () {
      // O app registra a região, nunca o endereço do passageiro.
      final offer = RideParsers.parse(
        screen([
          r'R$ 20,00',
          'Rua das Flores, 1842',
          '5 min (2 km)',
          'Caçari',
          '15 min (7 km)',
        ]),
      )!;

      expect(offer.pickupRegion, 'Caçari');
      expect(offer.pickupRegion, isNot(contains('1842')));
    });

    test('ignora rótulos de botão como região', () {
      final offer = RideParsers.parse(
        screen([r'R$ 20,00', 'Aceitar', '5 min (2 km)', '15 min (7 km)']),
      )!;

      expect(offer.pickupRegion, isNot('Aceitar'));
    });
  });

  group('StandardRideParser · telas que não são oferta', () {
    test('devolve null sem valor na tela', () {
      final offer = RideParsers.parse(screen(['Procurando corridas', '4,85']));

      expect(offer, isNull);
    });

    test('devolve null sem distância', () {
      final offer = RideParsers.parse(screen([r'R$ 24,50', '4,85']));

      expect(offer, isNull);
    });

    test('devolve null com apenas o trecho de deslocamento', () {
      // Avaliar com a distância da corrida zerada inflaria o R$/km e levaria
      // o motorista a aceitar algo que não conhece.
      final offer = RideParsers.parse(
        screen([r'R$ 24,50', '12 min (4,2 km) de distância']),
      );

      expect(offer, isNull);
    });

    test('devolve null para tela vazia', () {
      expect(RideParsers.parse(screen([])), isNull);
      expect(RideParsers.parse(screen(['', '   '])), isNull);
    });

    test('devolve null para pacote não monitorado', () {
      final offer = RideParsers.parse(
        screen([
          r'R$ 24,50',
          '12 min (4,2 km)',
          '25 min (14,8 km)',
        ], package: 'com.whatsapp'),
      );

      expect(offer, isNull);
    });
  });

  group('RideParsers · plataformas', () {
    test('reconhece a 99', () {
      final offer = RideParsers.parse(
        screen([
          r'R$ 19,80',
          '6 min (2,1 km)',
          '14 min (6,5 km)',
        ], package: 'com.nineninetaxi.driver'),
      )!;

      expect(offer.platform, RidePlatform.ninetyNine);
    });

    test('reconhece o inDrive', () {
      final offer = RideParsers.parse(
        screen([
          r'R$ 15,00',
          '4 min (1,5 km)',
          '12 min (5,0 km)',
        ], package: 'sinet.startup.inDriver'),
      )!;

      expect(offer.platform, RidePlatform.indrive);
    });

    test('a lista de pacotes monitorados é fechada', () {
      // É o que separa "lê três apps de transporte" de "lê tudo no telefone",
      // e é o item central da revisão do Google Play.
      final packages = RideParsers.monitoredPackages;

      expect(packages, contains('com.ubercab.driver'));
      expect(packages.length, lessThanOrEqualTo(6));
      expect(packages.any((p) => p.contains('whatsapp')), isFalse);
      expect(packages.any((p) => p.contains('bank')), isFalse);
    });
  });
}
