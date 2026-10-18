import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:rota_plus/core/sync/sync_engine.dart';

/// Decide **quando** o outbox é drenado.
///
/// O [SyncEngine] sabe enviar, mas não sabe quando. Sem este agendador a fila
/// cresceria para sempre — foi exatamente o que aconteceu até aqui.
///
/// Dispara em quatro situações, todas oportunistas:
///
/// - a conectividade volta;
/// - o app volta para o primeiro plano;
/// - a cada [interval] enquanto o app estiver visível;
/// - sob demanda, quando a tela pede.
///
/// Nunca acorda o aparelho só para sincronizar: o serviço roda horas em
/// background e bateria é recurso escasso para quem trabalha dirigindo.
class SyncScheduler with WidgetsBindingObserver {
  /// Cria o agendador.
  SyncScheduler({
    required SyncEngine engine,
    Connectivity? connectivity,
    this.interval = const Duration(minutes: 15),
  }) : _engine = engine,
       _connectivity = connectivity ?? Connectivity();

  final SyncEngine _engine;
  final Connectivity _connectivity;

  /// Intervalo entre tentativas enquanto o app está visível.
  final Duration interval;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _timer;
  bool _started = false;

  /// Começa a observar conectividade e ciclo de vida.
  void start() {
    if (_started) return;
    _started = true;

    WidgetsBinding.instance.addObserver(this);

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      results,
    ) {
      if (_hasConnection(results)) unawaited(flushNow());
    });

    _startTimer();
    unawaited(flushNow());
  }

  /// Para de observar e libera os recursos.
  void dispose() {
    if (!_started) return;
    _started = false;

    WidgetsBinding.instance.removeObserver(this);
    unawaited(_connectivitySubscription?.cancel());
    _connectivitySubscription = null;
    _timer?.cancel();
    _timer = null;
  }

  /// Dispara uma rodada imediatamente.
  ///
  /// Erro aqui não propaga: falha de sincronização não pode derrubar a tela,
  /// e a fila já guarda o que não subiu.
  Future<SyncResult> flushNow() async {
    try {
      return await _engine.flush();
    } on Object {
      return SyncResult.offline;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _startTimer();
        unawaited(flushNow());
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        // Sem timer em background: acordar o processo só para tentar enviar
        // gastaria bateria sem garantia de haver rede.
        _timer?.cancel();
        _timer = null;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) => unawaited(flushNow()));
  }

  static bool _hasConnection(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);
}
