import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota_plus/app/app.dart';
import 'package:rota_plus/bootstrap.dart';
import 'package:rota_plus/core/config/env.dart';
import 'package:rota_plus/overlay/overlay_main.dart' as overlay;
import 'package:sentry_flutter/sentry_flutter.dart';

/// Ponto de entrada do engine do overlay.
///
/// Precisa viver aqui, no mesmo arquivo de `main`: o plugin procura a função
/// pelo nome a partir da biblioteca principal. A anotação `vm:entry-point`
/// impede o tree shaking de removê-la no build de release — sem ela o overlay
/// abre em branco, e só em release.
@pragma('vm:entry-point')
void overlayMain() => overlay.overlayMain();

Future<void> main() async {
  final overrides = await bootstrap();
  final app = ProviderScope(overrides: overrides, child: const RotaPlusApp());

  // Sem DSN configurado o app roda sem telemetria, em vez de falhar.
  if (!Env.hasSentry) {
    runApp(app);
    return;
  }

  await SentryFlutter.init((options) {
    options.dsn = Env.sentryDsn;

    // Privacidade antes de observabilidade: este app lê a tela de outros
    // apps. Nada de identificável pode sair daqui.
    options.sendDefaultPii = false;
    options.attachScreenshot = false;
    options.attachViewHierarchy = false;
    options.enableUserInteractionBreadcrumbs = false;

    // Amostragem de performance baixa: o serviço roda horas em background e
    // trace de tudo custaria bateria e dados móveis do motorista.
    options.tracesSampleRate = 0.1;
  }, appRunner: () => runApp(SentryWidget(child: app)));
}
