import 'package:decimal/decimal.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_offer.dart';

/// Texto capturado da tela de um app de transporte.
///
/// Contém **apenas** as linhas visíveis e o pacote de origem. O lado nativo
/// filtra a subárvore relevante antes de enviar: a árvore inteira de nós
/// nunca cruza o canal.
class CapturedScreen {
  /// Cria a captura.
  const CapturedScreen({
    required this.packageName,
    required this.lines,
    required this.capturedAt,
  });

  /// Pacote Android de origem.
  final String packageName;

  /// Linhas de texto visíveis, na ordem em que aparecem.
  final List<String> lines;

  /// Momento da captura.
  final DateTime capturedAt;
}

/// Converte uma captura de tela numa oferta de corrida.
abstract interface class RideOfferParser {
  /// Plataforma que este parser entende.
  RidePlatform get platform;

  /// Pacotes Android atendidos.
  Set<String> get packageNames;

  /// Converte a captura, ou devolve `null` se a tela não for uma oferta.
  RideOffer? parse(CapturedScreen screen);
}

/// Parser para o layout usado por Uber, 99 e inDrive.
///
/// As três telas seguem a mesma estrutura: valor em destaque, nota do
/// passageiro, e dois pares "tempo (distância)" — primeiro o deslocamento até
/// o embarque, depois a viagem.
///
/// **Por que o parsing vive em Dart e não em Kotlin:** o descritivo previa
/// Kotlin por desempenho, mas o custo real era serializar a árvore de nós, o
/// que continua sendo evitado — o nativo manda só as linhas de texto. Em
/// compensação, esta é a parte que mais quebra quando os apps mudam de layout,
/// e aqui ela fica coberta por teste e pode ser corrigida sem tocar em código
/// nativo.
class StandardRideParser implements RideOfferParser {
  /// Cria o parser.
  const StandardRideParser({
    required this.platform,
    required this.packageNames,
  });

  @override
  final RidePlatform platform;

  @override
  final Set<String> packageNames;

  /// `R$ 24,50`, `R$24.50`, `24,50`.
  static final RegExp _money = RegExp(
    r'R?\$?\s*(\d{1,3}(?:[.\s]\d{3})*|\d+)[,.](\d{2})\b',
  );

  /// `12 min (4,2 km)` em qualquer ordem de separadores.
  static final RegExp _legPattern = RegExp(
    r'(\d+)\s*min[^\d]{0,12}(\d+(?:[.,]\d+)?)\s*km',
    caseSensitive: false,
  );

  /// Distância isolada: `4,2 km`.
  static final RegExp _distanceOnly = RegExp(
    r'(\d+(?:[.,]\d+)?)\s*km',
    caseSensitive: false,
  );

  /// Nota do passageiro: número entre 1 e 5 com uma ou duas casas.
  static final RegExp _rating = RegExp(r'^\s*([1-5][.,]\d{1,2})\s*★?\s*$');

  @override
  RideOffer? parse(CapturedScreen screen) {
    final lines = screen.lines
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    if (lines.isEmpty) return null;

    final fare = _findFare(lines);
    if (fare == null) return null;

    final legs = _findLegs(lines);
    if (legs.isEmpty) return null;

    final pickup = legs.first;
    // Oferta sem o trecho da viagem acontece: algumas telas só mostram o
    // deslocamento até o passageiro. Avaliar com a distância da corrida
    // zerada inflaria o R$/km, então é melhor descartar.
    if (legs.length < 2) return null;
    final trip = legs[1];

    return RideOffer(
      platform: platform,
      fare: fare,
      pickupKm: pickup.km,
      tripKm: trip.km,
      pickupMinutes: pickup.minutes,
      tripMinutes: trip.minutes,
      passengerRating: _findRating(lines),
      pickupRegion: _findRegion(lines),
      capturedAt: screen.capturedAt,
    );
  }

  /// Procura o maior valor monetário da tela.
  ///
  /// O maior, e não o primeiro: algumas telas mostram antes um adicional ou
  /// uma gorjeta, e pegar o primeiro subestimaria a corrida.
  Decimal? _findFare(List<String> lines) {
    Decimal? best;

    for (final line in lines) {
      for (final match in _money.allMatches(line)) {
        final whole = match.group(1)!.replaceAll(RegExp(r'[.\s]'), '');
        final cents = match.group(2)!;
        final value = Decimal.tryParse('$whole.$cents');

        if (value == null) continue;
        // Nota de passageiro (4,85) seria confundida com valor. Tarifa de
        // corrida abaixo de R$ 5 praticamente não existe.
        if (value < Decimal.fromInt(5)) continue;
        if (best == null || value > best) best = value;
      }
    }

    return best;
  }

  List<({Decimal km, double minutes})> _findLegs(List<String> lines) {
    final legs = <({Decimal km, double minutes})>[];

    for (final line in lines) {
      final match = _legPattern.firstMatch(line);
      if (match != null) {
        final minutes = double.tryParse(match.group(1)!);
        final km = _toDecimal(match.group(2)!);
        if (minutes != null && km != null) {
          legs.add((km: km, minutes: minutes));
          continue;
        }
      }

      // Alguns layouts separam distância e tempo em linhas distintas.
      final distance = _distanceOnly.firstMatch(line);
      if (distance != null && !line.toLowerCase().contains('min')) {
        final km = _toDecimal(distance.group(1)!);
        if (km != null) legs.add((km: km, minutes: 0));
      }
    }

    return legs;
  }

  double? _findRating(List<String> lines) {
    for (final line in lines) {
      final match = _rating.firstMatch(line);
      if (match == null) continue;
      final value = double.tryParse(match.group(1)!.replaceAll(',', '.'));
      if (value != null && value >= 1 && value <= 5) return value;
    }
    return null;
  }

  /// Procura o nome do bairro.
  ///
  /// Descarta linhas com número de porta: o app guarda a região, nunca o
  /// endereço do passageiro.
  String? _findRegion(List<String> lines) {
    for (final line in lines) {
      if (line.length < 3 || line.length > 60) continue;
      if (_money.hasMatch(line)) continue;
      if (_distanceOnly.hasMatch(line)) continue;
      if (_rating.hasMatch(line)) continue;
      if (RegExp(r'\d{2,}').hasMatch(line)) continue;
      if (RegExp(r'^[\d\W]+$').hasMatch(line)) continue;

      final lower = line.toLowerCase();
      const noise = [
        'aceitar',
        'recusar',
        'viagem',
        'distância',
        'distancia',
        'min',
        'corrida',
        'passageiro',
      ];
      if (noise.any(lower.contains)) continue;

      return line;
    }
    return null;
  }

  static Decimal? _toDecimal(String raw) =>
      Decimal.tryParse(raw.replaceAll(',', '.'));
}

/// Parsers disponíveis, por pacote Android.
abstract final class RideParsers {
  /// Uber Driver.
  static const StandardRideParser uber = StandardRideParser(
    platform: RidePlatform.uber,
    packageNames: {'com.ubercab.driver'},
  );

  /// 99 Motorista.
  static const StandardRideParser ninetyNine = StandardRideParser(
    platform: RidePlatform.ninetyNine,
    packageNames: {'com.nineninetaxi.driver', 'com.taxis99'},
  );

  /// inDrive.
  static const StandardRideParser indrive = StandardRideParser(
    platform: RidePlatform.indrive,
    packageNames: {'com.indrive.passenger', 'sinet.startup.inDriver'},
  );

  /// Todos os parsers.
  static const List<StandardRideParser> all = [uber, ninetyNine, indrive];

  /// Pacotes monitorados.
  ///
  /// Lista fechada: é o que separa "lê três apps de transporte" de "lê tudo
  /// que o usuário faz no telefone", e é o item central da revisão do Google
  /// Play.
  static Set<String> get monitoredPackages => {
    for (final parser in all) ...parser.packageNames,
  };

  /// Converte uma captura usando o parser do pacote de origem.
  static RideOffer? parse(CapturedScreen screen) {
    for (final parser in all) {
      if (parser.packageNames.contains(screen.packageName)) {
        return parser.parse(screen);
      }
    }
    return null;
  }
}
