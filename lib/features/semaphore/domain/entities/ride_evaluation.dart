import 'package:decimal/decimal.dart';
import 'package:meta/meta.dart';
import 'package:rota_plus/features/semaphore/domain/entities/ride_offer.dart';

/// Veredicto do semáforo para uma oferta de corrida.
enum RideVerdict {
  /// Corrida acima das metas: aceitar.
  accept,

  /// Corrida no limiar das metas: avaliar.
  think,

  /// Corrida abaixo do custo ou com critério eliminatório violado: recusar.
  reject;

  /// Texto exibido no cartão do overlay.
  ///
  /// O cartão sempre mostra ícone **e** texto: cor como único significante
  /// exclui quem tem daltonismo.
  String get label => switch (this) {
    RideVerdict.accept => 'ACEITAR',
    RideVerdict.think => 'PENSE',
    RideVerdict.reject => 'RECUSAR',
  };
}

/// O que o motorista de fato fez com a oferta.
///
/// Separado de [RideVerdict] de propósito: o veredicto é o que o app
/// recomendou, o desfecho é o que aconteceu. A divergência entre os dois é o
/// dado mais interessante do produto — mostra se o motorista confia no app.
enum RideOutcome {
  /// Corrida aceita.
  accepted,

  /// Corrida recusada.
  rejected,

  /// Oferta expirou sem decisão.
  expired,

  /// Desfecho não observado.
  unknown;

  /// Texto exibido na UI.
  String get label => switch (this) {
    RideOutcome.accepted => 'Aceita',
    RideOutcome.rejected => 'Recusada',
    RideOutcome.expired => 'Expirada',
    RideOutcome.unknown => 'Sem registro',
  };
}

/// Motivo pelo qual uma oferta foi recusada ou marcada como limítrofe.
///
/// Serve para explicar o veredicto na UI e no TTS: "recusar" sem motivo não
/// ensina o motorista a decidir melhor.
enum RejectionReason {
  /// R$/km abaixo do custo operacional: a corrida dá prejuízo.
  belowOperatingCost,

  /// R$/km abaixo da meta configurada.
  belowKmGoal,

  /// R$/hora abaixo da meta configurada.
  belowHourGoal,

  /// Nota do passageiro abaixo do mínimo aceito.
  lowPassengerRating,

  /// Deslocamento até o embarque acima do máximo aceito.
  pickupTooFar;

  /// Explicação curta para a UI.
  String get label => switch (this) {
    RejectionReason.belowOperatingCost => 'Abaixo do seu custo por km',
    RejectionReason.belowKmGoal => 'R\$/km abaixo da meta',
    RejectionReason.belowHourGoal => 'R\$/hora abaixo da meta',
    RejectionReason.lowPassengerRating => 'Nota do passageiro baixa',
    RejectionReason.pickupTooFar => 'Embarque muito longe',
  };
}

/// Resultado da avaliação de uma oferta de corrida.
@immutable
final class RideEvaluation {
  /// Cria o resultado de uma avaliação.
  const RideEvaluation({
    required this.offer,
    required this.verdict,
    required this.rsPerKm,
    required this.rsPerHour,
    required this.costPerKmUsed,
    required this.operatingCost,
    required this.realProfit,
    required this.marginPercent,
    this.reasons = const <RejectionReason>[],
    this.clientId,
    this.outcome = RideOutcome.unknown,
    this.workSessionClientId,
  });

  /// UUID gerado no dispositivo quando a avaliação é persistida.
  ///
  /// Nulo enquanto a avaliação existe só em memória — é o caso do simulador,
  /// que avalia sem registrar.
  final String? clientId;

  /// O que o motorista fez com a oferta.
  final RideOutcome outcome;

  /// Sessão de trabalho à qual a corrida pertence.
  final String? workSessionClientId;

  /// Oferta avaliada.
  final RideOffer offer;

  /// Veredicto do semáforo.
  final RideVerdict verdict;

  /// Receita por quilômetro total.
  final Decimal rsPerKm;

  /// Receita por hora comprometida.
  final Decimal rsPerHour;

  /// Custo por km do perfil ativo, usado nesta avaliação.
  final Decimal costPerKmUsed;

  /// Custo operacional estimado da corrida, em reais.
  final Decimal operatingCost;

  /// Lucro real: tarifa menos custo operacional.
  final Decimal realProfit;

  /// Margem sobre a tarifa, em percentual.
  final Decimal marginPercent;

  /// Motivos que pesaram contra a oferta, em ordem de relevância.
  final List<RejectionReason> reasons;

  /// Indica se a corrida dá prejuízo.
  bool get isLoss => realProfit < Decimal.zero;

  /// Motivo principal, usado no cartão e no TTS.
  RejectionReason? get primaryReason => reasons.isEmpty ? null : reasons.first;

  /// Retorna uma cópia com identidade de persistência e desfecho.
  RideEvaluation copyWith({
    String? clientId,
    RideOutcome? outcome,
    String? workSessionClientId,
  }) => RideEvaluation(
    offer: offer,
    verdict: verdict,
    rsPerKm: rsPerKm,
    rsPerHour: rsPerHour,
    costPerKmUsed: costPerKmUsed,
    operatingCost: operatingCost,
    realProfit: realProfit,
    marginPercent: marginPercent,
    reasons: reasons,
    clientId: clientId ?? this.clientId,
    outcome: outcome ?? this.outcome,
    workSessionClientId: workSessionClientId ?? this.workSessionClientId,
  );
}
