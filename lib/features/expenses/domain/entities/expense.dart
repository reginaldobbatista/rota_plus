import 'package:decimal/decimal.dart';
import 'package:meta/meta.dart';

/// Categoria de despesa do expediente.
enum ExpenseCategory {
  /// Abastecimento.
  fuel,

  /// Alimentação.
  food,

  /// Lavagem do veículo.
  carWash,

  /// Estacionamento.
  parking,

  /// Manutenção avulsa.
  maintenance,

  /// Pedágio.
  toll,

  /// Multa.
  fine,

  /// Aluguel do veículo.
  rent,

  /// Outras despesas.
  other;

  /// Nome exibido na UI.
  String get label => switch (this) {
    ExpenseCategory.fuel => 'Combustível',
    ExpenseCategory.food => 'Alimentação',
    ExpenseCategory.carWash => 'Lavagem',
    ExpenseCategory.parking => 'Estacionamento',
    ExpenseCategory.maintenance => 'Manutenção',
    ExpenseCategory.toll => 'Pedágio',
    ExpenseCategory.fine => 'Multa',
    ExpenseCategory.rent => 'Aluguel',
    ExpenseCategory.other => 'Outros',
  };

  /// Indica se a categoria aceita litros e odômetro.
  ///
  /// Só o abastecimento permite aferir o consumo real contra o configurado.
  bool get tracksFuelVolume => this == ExpenseCategory.fuel;
}

/// Despesa registrada pelo motorista.
@immutable
final class Expense {
  /// Cria uma despesa.
  const Expense({
    required this.clientId,
    required this.category,
    required this.amount,
    required this.occurredAt,
    this.liters,
    this.odometerKm,
    this.description,
    this.workSessionClientId,
  });

  /// UUID gerado no dispositivo, base da idempotência de sincronização.
  final String clientId;

  /// Categoria da despesa.
  final ExpenseCategory category;

  /// Valor pago.
  final Decimal amount;

  /// Litros abastecidos, quando aplicável.
  final Decimal? liters;

  /// Leitura do odômetro, quando aplicável.
  final Decimal? odometerKm;

  /// Descrição livre.
  final String? description;

  /// Momento da despesa.
  final DateTime occurredAt;

  /// Sessão de trabalho à qual a despesa pertence.
  final String? workSessionClientId;

  /// Preço por litro deste abastecimento, quando há valor e litros.
  ///
  /// Serve para comparar com o preço configurado no veículo e avisar o
  /// motorista quando o custo por km está defasado.
  Decimal? get pricePerLiter {
    final volume = liters;
    if (volume == null || volume == Decimal.zero) return null;
    return (amount / volume).toDecimal(scaleOnInfinitePrecision: 4);
  }

  /// Retorna uma copia com os campos informados substituídos.
  Expense copyWith({
    ExpenseCategory? category,
    Decimal? amount,
    Decimal? liters,
    Decimal? odometerKm,
    String? description,
    DateTime? occurredAt,
    String? workSessionClientId,
  }) => Expense(
    clientId: clientId,
    category: category ?? this.category,
    amount: amount ?? this.amount,
    liters: liters ?? this.liters,
    odometerKm: odometerKm ?? this.odometerKm,
    description: description ?? this.description,
    occurredAt: occurredAt ?? this.occurredAt,
    workSessionClientId: workSessionClientId ?? this.workSessionClientId,
  );
}
