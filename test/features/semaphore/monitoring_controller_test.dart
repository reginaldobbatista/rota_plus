import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rota_plus/app/providers.dart';
import 'package:rota_plus/core/services/overlay_service.dart';
import 'package:rota_plus/features/semaphore/data/parsers/ride_offer_parser.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_evaluation.dart';
import 'package:rota_plus/features/semaphore/presentation/controllers/monitoring_controller.dart';
import 'package:rota_plus/features/vehicle/domain/entities/cost_parameters.dart';
import 'package:rota_plus/features/vehicle/domain/entities/work_profile.dart';

import '../../support/app_harness.dart';
import '../../support/fixtures.dart';

/// Overlay controlável, para verificar o que seria desenhado.
class FakeOverlayService implements OverlayService {
  final List<RideEvaluation> shown = [];
  int hideCount = 0;

  @override
  Duration get autoDismiss => const Duration(seconds: 8);

  @override
  Future<void> show(RideEvaluation evaluation) async => shown.add(evaluation);

  @override
  Future<void> hide() async => hideCount++;
}

void main() {
  late AppHarness harness;

  setUp(() => harness = AppHarness());
  tearDown(() => harness.dispose());

  CapturedScreen uberOffer({String fare = r'R$ 24,50'}) => CapturedScreen(
    packageName: 'com.ubercab.driver',
    lines: [
      fare,
      '4,85',
      '12 min (4,2 km) de distância',
      'Centro',
      '25 min (14,8 km) de viagem',
    ],
    capturedAt: DateTime.utc(2026, 10, 18, 12),
  );

  /// Monta um container já configurado com veículo e perfil.
  Future<(ProviderContainer, FakeOverlayService)> configured() async {
    final overlay = FakeOverlayService();
    final container = ProviderContainer(
      overrides: [
        ...harness.overrides,
        overlayServiceProvider.overrideWithValue(overlay),
      ],
    );
    addTearDown(container.dispose);
    container
      ..listen(activeProfileProvider, (_, _) {})
      ..listen(costParametersProvider, (_, _) {});

    final repo = container.read(configRepositoryProvider);
    final vehicleId = await repo.saveVehicle(
      vehicle: Vehicle(
        nickname: 'Onix',
        fuel: FuelType.flex,
        consumption: d('11'),
        fuelPrice: d('6.09'),
        depreciationPerKm: d('0.12'),
        genericMaintenancePerKm: d('0.08'),
        workDaysPerMonth: 24,
        kmPerDay: d('180'),
      ),
      maintenance: const [],
      fixedCosts: const [],
    );
    await repo.saveProfile(
      WorkProfile.initial(name: 'Padrão', vehicleClientId: vehicleId),
    );

    await container.read(activeProfileProvider.future);
    await container.read(costParametersProvider.future);

    return (container, overlay);
  }

  group('MonitoringController · caminho crítico', () {
    test('captura vira veredicto e vai para o overlay', () async {
      final (container, overlay) = await configured();
      final controller = container.read(monitoringControllerProvider.notifier);

      await controller.evaluateNow(uberOffer());

      expect(overlay.shown, hasLength(1));
      expect(overlay.shown.single.offer.fare, d('24.50'));
      expect(overlay.shown.single.rsPerKm > d('0'), isTrue);
    });

    test('a avaliação é registrada no histórico', () async {
      final (container, _) = await configured();
      final controller = container.read(monitoringControllerProvider.notifier);

      await controller.evaluateNow(uberOffer());

      final rides = await container
          .read(rideHistoryRepositoryProvider)
          .watchRecent()
          .first;

      expect(rides, hasLength(1));
      // Desfecho desconhecido: o app registra que avaliou, não que o
      // motorista aceitou. Supor aceitação inflaria o faturamento.
      expect(rides.single.outcome, RideOutcome.unknown);
    });

    test('o estado acompanha a última avaliação', () async {
      final (container, _) = await configured();
      final controller = container.read(monitoringControllerProvider.notifier);

      await controller.evaluateNow(uberOffer());
      final state = container.read(monitoringControllerProvider);

      expect(state.lastEvaluation, isNotNull);
      expect(state.evaluatedToday, 1);
    });

    test('a mesma oferta repetida não gera segundo cartão', () async {
      // A Uber redesenha o cartão dezenas de vezes por segundo. Sem o
      // descarte por assinatura, o motorista ouviria o mesmo aviso em loop.
      final (container, overlay) = await configured();
      final controller = container.read(monitoringControllerProvider.notifier);

      await controller.evaluateNow(uberOffer());
      await controller.evaluateNow(uberOffer());
      await controller.evaluateNow(uberOffer());

      expect(overlay.shown, hasLength(1));
      expect(container.read(monitoringControllerProvider).evaluatedToday, 1);
    });

    test('oferta diferente gera cartão novo', () async {
      final (container, overlay) = await configured();
      final controller = container.read(monitoringControllerProvider.notifier);

      await controller.evaluateNow(uberOffer());
      await controller.evaluateNow(uberOffer(fare: r'R$ 38,00'));

      expect(overlay.shown, hasLength(2));
      expect(overlay.shown.last.offer.fare, d('38'));
    });
  });

  group('MonitoringController · telas que não são oferta', () {
    test('ignora captura que não é oferta', () async {
      final (container, overlay) = await configured();
      final controller = container.read(monitoringControllerProvider.notifier);

      await controller.evaluateNow(
        CapturedScreen(
          packageName: 'com.ubercab.driver',
          lines: const ['Procurando corridas', 'Você está online'],
          capturedAt: DateTime.utc(2026, 10, 18, 12),
        ),
      );

      expect(overlay.shown, isEmpty);
    });

    test('ignora captura de app não monitorado', () async {
      final (container, overlay) = await configured();
      final controller = container.read(monitoringControllerProvider.notifier);

      await controller.evaluateNow(
        CapturedScreen(
          packageName: 'com.whatsapp',
          lines: const [r'R$ 24,50', '12 min (4,2 km)', '25 min (14,8 km)'],
          capturedAt: DateTime.utc(2026, 10, 18, 12),
        ),
      );

      expect(overlay.shown, isEmpty);
    });
  });

  group('MonitoringController · sem configuração', () {
    test('não avalia sem perfil cadastrado', () async {
      // Sem metas não há critério. Mostrar um veredicto inventado seria pior
      // do que não mostrar nada.
      final overlay = FakeOverlayService();
      final container = ProviderContainer(
        overrides: [
          ...harness.overrides,
          overlayServiceProvider.overrideWithValue(overlay),
        ],
      );
      addTearDown(container.dispose);
      container.listen(activeProfileProvider, (_, _) {});
      await container.read(activeProfileProvider.future);

      await container
          .read(monitoringControllerProvider.notifier)
          .evaluateNow(uberOffer());

      expect(overlay.shown, isEmpty);
    });
  });

  group('OverlayService.encode', () {
    test('envia o veredicto já calculado, não os insumos', () async {
      // O overlay roda noutro engine. Recalcular lá abriria espaço para o
      // cartão discordar do histórico.
      final payload = OverlayService.encode(testEvaluation());

      expect(payload['verdict'], 'accept');
      expect(payload['rsPerKm'], '2');
      expect(payload['fare'], '20');
      expect(payload.containsKey('costPerKm'), isFalse);
    });

    test('não leva dado identificável do passageiro', () {
      final payload = OverlayService.encode(testEvaluation());

      // Só a região textual; nunca nome, telefone ou endereço.
      expect(payload['region'], 'Centro');
      expect(payload.keys, isNot(contains('passengerName')));
      expect(payload.keys, isNot(contains('address')));
    });
  });
}
