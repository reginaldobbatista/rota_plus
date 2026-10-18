import 'package:flutter_tts/flutter_tts.dart';
import 'package:rota_plus/core/formatters/formatters.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_evaluation.dart';

/// Fala o veredicto do semáforo.
///
/// Existe por segurança viária, não por conforto: o motorista está dirigindo
/// quando a oferta chega, e ler a tela nessa hora é pior do que ouvir.
///
/// Duas decisões importam:
///
/// - **Fala curta.** Uma frase de dois segundos. Texto longo competiria com a
///   instrução do navegador justamente na hora de uma conversão.
/// - **Não interrompe a navegação.** Usa a categoria de áudio que faz o Waze
///   abaixar o volume por um instante em vez de ser cortado.
class TtsService {
  /// Cria o serviço.
  TtsService({FlutterTts? tts}) : _tts = tts ?? FlutterTts();

  final FlutterTts _tts;
  bool _ready = false;

  /// Prepara o motor de voz. Idempotente.
  Future<void> init() async {
    if (_ready) return;

    await _tts.setLanguage('pt-BR');
    await _tts.setSpeechRate(0.55);
    await _tts.setVolume(1);
    await _tts.setPitch(1);
    await _tts.awaitSpeakCompletion(true);

    // Duck em vez de interromper: a instrução do navegador é mais importante
    // que o nosso aviso, e perder uma conversão custa mais que uma corrida.
    await _tts.setIosAudioCategory(IosTextToSpeechAudioCategory.playback, [
      IosTextToSpeechAudioCategoryOptions.duckOthers,
      IosTextToSpeechAudioCategoryOptions.mixWithOthers,
    ], IosTextToSpeechAudioMode.voicePrompt);

    _ready = true;
  }

  /// Anuncia o veredicto de uma avaliação.
  Future<void> announce(RideEvaluation evaluation) =>
      speak(phraseFor(evaluation));

  /// Fala um texto, interrompendo o anterior.
  ///
  /// Uma oferta nova torna a anterior irrelevante: enfileirar faria o
  /// motorista ouvir o veredicto da corrida que já passou.
  Future<void> speak(String text) async {
    await init();
    await _tts.stop();
    await _tts.speak(text);
  }

  /// Interrompe a fala.
  Future<void> stop() => _tts.stop();

  /// Ajusta a velocidade da fala, de 0.3 a 1.0.
  Future<void> setRate(double rate) => _tts.setSpeechRate(rate.clamp(0.3, 1));

  /// Monta a frase falada para uma avaliação.
  ///
  /// Separada da fala para poder ser testada sem motor de voz.
  static String phraseFor(RideEvaluation evaluation) {
    final valor = Fmt.money(evaluation.rsPerKm).replaceFirst(r'R$', '').trim();

    return switch (evaluation.verdict) {
      RideVerdict.accept => 'Corrida boa! $valor por quilômetro.',
      RideVerdict.think => 'Atenção! Corrida na média, avalie.',
      RideVerdict.reject => switch (evaluation.primaryReason) {
        RejectionReason.belowOperatingCost =>
          'Corrida ruim. $valor por quilômetro, abaixo do seu custo.',
        RejectionReason.pickupTooFar => 'Corrida ruim. Embarque muito longe.',
        RejectionReason.lowPassengerRating =>
          'Corrida ruim. Nota do passageiro baixa.',
        _ => 'Corrida ruim. $valor por quilômetro.',
      },
    };
  }
}
