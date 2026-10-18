import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:rota_plus/app/theme/app_theme.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_evaluation.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_offer.dart';
import 'package:rota_plus/features/semaphore/presentation/widgets/ride_verdict_card.dart';

/// Ponto de entrada do engine do overlay.
///
/// Roda num isolate e num FlutterEngine **separados** do app: não enxerga
/// providers, banco nem a sessão. Tudo que precisa chega como JSON por
/// `FlutterOverlayWindow.overlayListener`.
///
/// A anotação `vm:entry-point` é obrigatória — sem ela o tree shaking do build
/// de release remove esta função e o overlay abre em branco.
@pragma('vm:entry-point')
void overlayMain() {
  runApp(const _OverlayApp());
}

class _OverlayApp extends StatelessWidget {
  const _OverlayApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const _OverlayBody(),
    );
  }
}

class _OverlayBody extends StatefulWidget {
  const _OverlayBody();

  @override
  State<_OverlayBody> createState() => _OverlayBodyState();
}

class _OverlayBodyState extends State<_OverlayBody> {
  RideEvaluation? _evaluation;

  @override
  void initState() {
    super.initState();
    FlutterOverlayWindow.overlayListener.listen((event) {
      final decoded = _decode(event);
      if (decoded != null && mounted) {
        setState(() => _evaluation = decoded);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final evaluation = _evaluation;

    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: evaluation == null
              ? const SizedBox.shrink()
              : RideVerdictCard(
                  evaluation: evaluation,
                  onDismiss: FlutterOverlayWindow.closeOverlay,
                ),
        ),
      ),
    );
  }
}

/// Reconstrói a avaliação a partir do JSON recebido do app.
///
/// Reconstrói, não recalcula: o veredicto e as métricas vêm prontos. Calcular
/// de novo aqui abriria espaço para o cartão discordar do histórico.
RideEvaluation? _decode(Object? event) {
  try {
    final raw = event is String ? event : null;
    if (raw == null) return null;

    final map = jsonDecode(raw) as Map<String, dynamic>;
    final fare = Decimal.parse(map['fare'] as String);
    final totalKm = Decimal.parse(map['totalKm'] as String);
    final totalMinutes = (map['totalMinutes'] as num).toDouble();

    return RideEvaluation(
      offer: RideOffer(
        platform: RidePlatform.values.firstWhere(
          (p) => p.name == map['platform'],
          orElse: () => RidePlatform.other,
        ),
        fare: fare,
        // O cartão só mostra o total, então a divisão entre deslocamento e
        // viagem não precisa atravessar o canal.
        pickupKm: Decimal.zero,
        tripKm: totalKm,
        tripMinutes: totalMinutes,
        passengerRating: (map['rating'] as num?)?.toDouble(),
        pickupRegion: map['region'] as String?,
        capturedAt: DateTime.now(),
      ),
      verdict: RideVerdict.values.firstWhere(
        (v) => v.name == map['verdict'],
        orElse: () => RideVerdict.think,
      ),
      rsPerKm: Decimal.parse(map['rsPerKm'] as String),
      rsPerHour: Decimal.parse(map['rsPerHour'] as String),
      costPerKmUsed: Decimal.zero,
      operatingCost: Decimal.zero,
      realProfit: Decimal.parse(map['profit'] as String),
      marginPercent: Decimal.zero,
      reasons: [
        for (final reason in RejectionReason.values)
          if (reason.name == map['reason']) reason,
      ],
    );
  } on Object {
    // JSON malformado não pode derrubar o overlay: o motorista está
    // dirigindo, e um crash aqui aparece por cima do app de corrida.
    return null;
  }
}
