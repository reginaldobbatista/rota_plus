import 'package:decimal/decimal.dart';
import 'package:meta/meta.dart';

/// Plataforma de transporte que originou a oferta.
enum RidePlatform {
  /// Uber Driver.
  uber,

  /// 99 Motorista.
  ninetyNine,

  /// inDrive.
  indrive,

  /// Origem desconhecida ou plataforma não suportada.
  other;

  /// Nome exibido na UI.
  String get label => switch (this) {
    RidePlatform.uber => 'Uber',
    RidePlatform.ninetyNine => '99',
    RidePlatform.indrive => 'inDrive',
    RidePlatform.other => 'Outra',
  };

  /// Package name do app Android correspondente, quando houver.
  String? get androidPackage => switch (this) {
    RidePlatform.uber => 'com.ubercab.driver',
    RidePlatform.ninetyNine => 'com.nineninetaxi.driver',
    RidePlatform.indrive => 'com.indrive.passenger',
    RidePlatform.other => null,
  };
}

/// Oferta de corrida capturada da tela de um app de transporte.
///
/// Contém **apenas** dados numéricos e o nome da região de embarque. Nome,
/// telefone e endereço do passageiro são descartados no parser, antes de chegar
/// aqui — ver a seção de Segurança da Informação do descritivo.
@immutable
final class RideOffer {
  /// Cria uma oferta de corrida.
  const RideOffer({
    required this.platform,
    required this.fare,
    required this.pickupKm,
    required this.tripKm,
    required this.capturedAt,
    this.pickupMinutes = 0,
    this.tripMinutes = 0,
    this.passengerRating,
    this.pickupRegion,
    this.surgeMultiplier,
  });

  /// Plataforma de origem.
  final RidePlatform platform;

  /// Valor oferecido pela corrida, em reais.
  final Decimal fare;

  /// Distância do motorista até o passageiro, em quilômetros.
  final Decimal pickupKm;

  /// Distância da corrida em si, em quilômetros.
  final Decimal tripKm;

  /// Tempo estimado até o passageiro, em minutos.
  final double pickupMinutes;

  /// Tempo estimado da corrida, em minutos.
  final double tripMinutes;

  /// Nota do passageiro, de 0 a 5. `null` quando a tela não informou.
  final double? passengerRating;

  /// Nome do bairro ou região de embarque.
  final String? pickupRegion;

  /// Multiplicador de tarifa dinâmica, quando informado.
  final Decimal? surgeMultiplier;

  /// Momento da captura.
  final DateTime capturedAt;

  /// Distância total percorrida: deslocamento até o passageiro + corrida.
  Decimal get totalKm => pickupKm + tripKm;

  /// Tempo total comprometido, em minutos.
  double get totalMinutes => pickupMinutes + tripMinutes;

  /// Tempo total comprometido, em horas.
  double get totalHours => totalMinutes / 60;

  /// Indica se a oferta tem dados suficientes para ser avaliada.
  ///
  /// Uma captura parcial (a tela ainda estava animando, por exemplo) produz
  /// quilometragem zerada; avaliar isso geraria divisão por zero e um veredicto
  /// sem sentido.
  bool get isEvaluable => totalKm > Decimal.zero && totalMinutes > 0;
}
