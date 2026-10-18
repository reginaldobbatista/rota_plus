import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rota_plus/features/semaphore/data/parsers/ride_offer_parser.dart';

/// Ponte com o serviço de captura nativo.
///
/// O lado Kotlin escuta os eventos de acessibilidade, filtra pelos pacotes
/// monitorados e envia **apenas as linhas de texto visíveis** — nunca a árvore
/// de nós inteira. A conversão em oferta acontece em Dart, onde está coberta
/// por teste.
class AccessibilityBridge {
  /// Cria a ponte.
  AccessibilityBridge({MethodChannel? methods, EventChannel? captures})
    : _methods = methods ?? const MethodChannel(methodChannelName),
      _captures = captures ?? const EventChannel(eventChannelName);

  /// Nome do canal de comandos.
  static const String methodChannelName = 'io.r2b.rota_plus/monitoring';

  /// Nome do canal de capturas.
  static const String eventChannelName = 'io.r2b.rota_plus/captures';

  final MethodChannel _methods;
  final EventChannel _captures;

  Stream<CapturedScreen>? _stream;

  /// Indica se o serviço de acessibilidade está ativo.
  Future<bool> isAccessibilityEnabled() async {
    final enabled = await _methods.invokeMethod<bool>('isAccessibilityEnabled');
    return enabled ?? false;
  }

  /// Indica se a permissão de sobreposição foi concedida.
  Future<bool> canDrawOverlay() async {
    final granted = await _methods.invokeMethod<bool>('canDrawOverlay');
    return granted ?? false;
  }

  /// Abre a tela de Acessibilidade do sistema.
  ///
  /// Não existe API de runtime para esta permissão: o motorista precisa
  /// ativá-la manualmente.
  Future<void> openAccessibilitySettings() =>
      _methods.invokeMethod<void>('openAccessibilitySettings');

  /// Abre a tela de permissão de sobreposição.
  Future<void> openOverlaySettings() =>
      _methods.invokeMethod<void>('openOverlaySettings');

  /// Inicia o monitoramento com notificação persistente.
  Future<void> startMonitoring() => _methods.invokeMethod<void>(
    'startMonitoring',
    {'packages': RideParsers.monitoredPackages.toList()},
  );

  /// Encerra o monitoramento.
  Future<void> stopMonitoring() =>
      _methods.invokeMethod<void>('stopMonitoring');

  /// Indica se o monitoramento está ativo.
  Future<bool> isMonitoring() async {
    final running = await _methods.invokeMethod<bool>('isMonitoring');
    return running ?? false;
  }

  /// Capturas de tela dos apps monitorados.
  ///
  /// O stream é compartilhado: cada ouvinte novo não recria o canal nativo,
  /// que registraria o listener duas vezes.
  Stream<CapturedScreen> captures() {
    return _stream ??= _captures
        .receiveBroadcastStream()
        .map(_toCapture)
        .where((capture) => capture != null)
        .cast<CapturedScreen>()
        .asBroadcastStream();
  }

  CapturedScreen? _toCapture(Object? event) {
    if (event is! Map) return null;

    final package = event['package'];
    final lines = event['lines'];
    if (package is! String || lines is! List) return null;

    return CapturedScreen(
      packageName: package,
      lines: lines.whereType<String>().toList(),
      // O instante é do dispositivo: o nativo não precisa saber de fuso.
      capturedAt: DateTime.now().toUtc(),
    );
  }
}
