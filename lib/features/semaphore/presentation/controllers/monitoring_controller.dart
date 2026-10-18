import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota_plus/app/providers.dart';
import 'package:rota_plus/features/semaphore/data/parsers/ride_offer_parser.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_evaluation.dart';

/// Estado do monitoramento de corridas.
class MonitoringState {
  /// Cria o estado.
  const MonitoringState({
    this.isRunning = false,
    this.accessibilityEnabled = false,
    this.overlayAllowed = false,
    this.lastEvaluation,
    this.evaluatedToday = 0,
  });

  /// Indica se o serviço está rodando.
  final bool isRunning;

  /// Indica se o serviço de acessibilidade está ativo.
  final bool accessibilityEnabled;

  /// Indica se a sobreposição foi autorizada.
  final bool overlayAllowed;

  /// Última avaliação produzida.
  final RideEvaluation? lastEvaluation;

  /// Quantidade de ofertas avaliadas desde o início da sessão.
  final int evaluatedToday;

  /// Indica se falta alguma permissão para operar.
  bool get missingPermissions => !accessibilityEnabled || !overlayAllowed;

  /// Retorna uma cópia com os campos informados substituídos.
  MonitoringState copyWith({
    bool? isRunning,
    bool? accessibilityEnabled,
    bool? overlayAllowed,
    RideEvaluation? lastEvaluation,
    int? evaluatedToday,
  }) => MonitoringState(
    isRunning: isRunning ?? this.isRunning,
    accessibilityEnabled: accessibilityEnabled ?? this.accessibilityEnabled,
    overlayAllowed: overlayAllowed ?? this.overlayAllowed,
    lastEvaluation: lastEvaluation ?? this.lastEvaluation,
    evaluatedToday: evaluatedToday ?? this.evaluatedToday,
  );
}

/// Orquestra o caminho crítico do produto.
///
/// Captura → oferta → veredicto → cartão + voz + registro.
///
/// O orçamento é de 120 ms entre o evento de acessibilidade e o primeiro frame
/// do overlay. Por isso, nesta ordem:
///
/// 1. avalia (puro, em memória, sem I/O);
/// 2. mostra o cartão;
/// 3. fala;
/// 4. **só então** grava no banco.
///
/// Gravar antes de desenhar colocaria uma escrita em disco no caminho crítico.
class MonitoringController extends Notifier<MonitoringState> {
  Timer? _debounce;
  StreamSubscription<CapturedScreen>? _subscription;

  /// Janela de agrupamento das capturas.
  ///
  /// A Uber dispara dezenas de eventos por segundo durante a animação do
  /// cartão. Sem isso, o app reavaliaria a mesma oferta a cada frame.
  static const Duration debounceWindow = Duration(milliseconds: 250);

  /// Assinatura da última oferta avaliada, para descartar repetição.
  String? _lastSignature;

  @override
  MonitoringState build() {
    ref.onDispose(() {
      _debounce?.cancel();
      _subscription?.cancel();
    });
    return const MonitoringState();
  }

  /// Reconsulta o estado das permissões.
  Future<void> refreshPermissions() async {
    final bridge = ref.read(accessibilityBridgeProvider);

    final accessibility = await bridge.isAccessibilityEnabled();
    final overlay = await bridge.canDrawOverlay();
    final running = await bridge.isMonitoring();

    state = state.copyWith(
      accessibilityEnabled: accessibility,
      overlayAllowed: overlay,
      isRunning: running,
    );
  }

  /// Inicia o monitoramento.
  ///
  /// Devolve `false` quando falta permissão — a tela então orienta o motorista
  /// em vez de ligar um serviço que não capturaria nada.
  Future<bool> start() async {
    await refreshPermissions();
    if (state.missingPermissions) return false;

    final bridge = ref.read(accessibilityBridgeProvider);
    await bridge.startMonitoring();

    await _subscription?.cancel();
    _subscription = bridge.captures().listen(_onCapture);

    state = state.copyWith(isRunning: true);
    return true;
  }

  /// Encerra o monitoramento.
  Future<void> stop() async {
    _debounce?.cancel();
    await _subscription?.cancel();
    _subscription = null;

    await ref.read(accessibilityBridgeProvider).stopMonitoring();
    await ref.read(overlayServiceProvider).hide();

    state = state.copyWith(isRunning: false);
  }

  void _onCapture(CapturedScreen capture) {
    _debounce?.cancel();
    _debounce = Timer(debounceWindow, () => _evaluate(capture));
  }

  Future<void> _evaluate(CapturedScreen capture) async {
    final offer = RideParsers.parse(capture);
    if (offer == null) return;

    // Mesma oferta reapresentada não merece novo cartão nem nova fala.
    final signature =
        '${offer.platform.name}|${offer.fare}|${offer.pickupKm}|'
        '${offer.tripKm}|${offer.pickupMinutes}|${offer.tripMinutes}';
    if (signature == _lastSignature) return;
    _lastSignature = signature;

    final evaluator = ref.read(evaluateRideProvider);
    if (evaluator == null) return;

    final evaluation = evaluator(offer);
    if (evaluation == null) return;

    state = state.copyWith(
      lastEvaluation: evaluation,
      evaluatedToday: state.evaluatedToday + 1,
    );

    await ref.read(overlayServiceProvider).show(evaluation);

    final settings = ref.read(appSettingsProvider).value;
    if (settings?.ttsEnabled ?? true) {
      unawaited(_speak(evaluation));
    }

    // Por último: a escrita em disco não pode atrasar o cartão.
    unawaited(_record(evaluation));
  }

  Future<void> _speak(RideEvaluation evaluation) async {
    try {
      final tts = ref.read(ttsServiceProvider);
      final rate = ref.read(appSettingsProvider).value?.ttsRate;
      if (rate != null) await tts.setRate(rate);
      await tts.announce(evaluation);
    } on Object {
      // Aparelho sem motor de voz não pode impedir o veredicto visual.
    }
  }

  Future<void> _record(RideEvaluation evaluation) async {
    try {
      await ref.read(rideHistoryRepositoryProvider).record(evaluation);
    } on Object {
      // Falha de gravação não pode derrubar o monitoramento. O motorista
      // perde uma linha de histórico, não a avaliação da próxima corrida.
    }
  }

  /// Avalia uma captura imediatamente, sem debounce.
  ///
  /// Usado em teste e no modo de contingência manual.
  Future<void> evaluateNow(CapturedScreen capture) => _evaluate(capture);
}

/// Estado do monitoramento de corridas.
final monitoringControllerProvider =
    NotifierProvider<MonitoringController, MonitoringState>(
      MonitoringController.new,
    );
