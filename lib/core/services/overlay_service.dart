import 'dart:async';
import 'dart:convert';

import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_evaluation.dart';

/// Controla o cartão flutuante sobre os apps de transporte.
///
/// O overlay roda num **FlutterEngine separado**, com memória própria: ele não
/// enxerga os providers nem o banco do app. Por isso recebe um retrato pronto
/// da avaliação, em JSON, e nunca uma referência ao estado.
class OverlayService {
  /// Cria o serviço.
  OverlayService({this.autoDismiss = const Duration(seconds: 8)});

  /// Tempo até o cartão sumir sozinho.
  final Duration autoDismiss;

  Timer? _dismissTimer;

  /// Mostra o cartão com o veredicto.
  Future<void> show(RideEvaluation evaluation) async {
    final payload = jsonEncode(encode(evaluation));

    if (await FlutterOverlayWindow.isActive()) {
      // Atualiza em vez de recriar: recriar a janela custa um ciclo de
      // inicialização de engine e estouraria o orçamento de 120 ms.
      await FlutterOverlayWindow.shareData(payload);
    } else {
      await FlutterOverlayWindow.showOverlay(
        height: 460,
        alignment: OverlayAlignment.topCenter,
        overlayTitle: 'Rota Plus',
        enableDrag: true,
      );
      await FlutterOverlayWindow.shareData(payload);
    }

    _dismissTimer?.cancel();
    _dismissTimer = Timer(autoDismiss, () => hide().ignore());
  }

  /// Esconde o cartão.
  Future<void> hide() async {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    if (await FlutterOverlayWindow.isActive()) {
      await FlutterOverlayWindow.closeOverlay();
    }
  }

  /// Serializa a avaliação para o engine do overlay.
  ///
  /// Só o necessário para desenhar: o overlay não recalcula nada, porque
  /// recalcular do outro lado abriria espaço para os dois discordarem.
  static Map<String, Object?> encode(RideEvaluation e) => {
    'verdict': e.verdict.name,
    'fare': e.offer.fare.toString(),
    'rsPerKm': e.rsPerKm.toString(),
    'rsPerHour': e.rsPerHour.toString(),
    'profit': e.realProfit.toString(),
    'rating': e.offer.passengerRating,
    'platform': e.offer.platform.name,
    'region': e.offer.pickupRegion,
    'totalKm': e.offer.totalKm.toString(),
    'totalMinutes': e.offer.totalMinutes,
    'reason': e.primaryReason?.name,
  };
}
