import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rota_plus/features/vehicle/presentation/screens/vehicle_screen.dart';

import '../../support/app_harness.dart';

void main() {
  late AppHarness harness;

  setUp(() => harness = AppHarness());
  tearDown(() => harness.dispose());

  /// Monta a tela numa superfície alta o bastante para o formulário inteiro.
  ///
  /// O padrão de 600×800 corta o formulário, e widget fora da viewport não é
  /// construído — o teste então falharia por não encontrar o campo, não por um
  /// defeito real. A responsividade em tela pequena é verificada à parte.
  Future<void> pumpScreen(WidgetTester tester, {double textScale = 1}) async {
    tester.view
      ..physicalSize = const Size(1000, 4000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      harness.wrap(const VehicleScreen(), textScale: textScale),
    );
    await tester.pumpAndSettle();
  }

  /// Localiza um campo pelo rótulo visível.
  Finder fieldWithLabel(String label) =>
      find.ancestor(of: find.text(label), matching: find.byType(TextFormField));

  group('VehicleScreen · cálculo ao vivo', () {
    testWidgets('mostra o custo por km a partir dos valores padrão', (
      tester,
    ) async {
      await pumpScreen(tester);

      // 6,09 / 11 ≈ 0,5536 de combustível + 0,08 manutenção + 0,12
      // depreciação = R$ 0,75/km, sem custos fixos.
      expect(find.textContaining('/ km'), findsWidgets);
      expect(find.text('Seu custo por quilômetro'), findsOneWidget);
    });

    testWidgets('recalcula quando o preço do combustível muda', (tester) async {
      await pumpScreen(tester);

      final before = tester
          .widgetList<Text>(find.textContaining(r'R$'))
          .map((t) => t.data)
          .toList();

      await tester.enterText(fieldWithLabel('Preço do litro'), '12,00');
      await tester.pumpAndSettle();

      final after = tester
          .widgetList<Text>(find.textContaining(r'R$'))
          .map((t) => t.data)
          .toList();

      // Dobrar o preço do litro precisa mudar o custo exibido; se não mudar,
      // o preview parou de refletir o que está digitado.
      expect(after, isNot(equals(before)));
    });

    testWidgets('não calcula com consumo zerado', (tester) async {
      await pumpScreen(tester);

      await tester.enterText(fieldWithLabel('Consumo médio'), '0');
      await tester.pumpAndSettle();

      expect(
        find.text('Preencha consumo, preço e ritmo de trabalho para calcular.'),
        findsOneWidget,
      );
    });
  });

  group('VehicleScreen · validação', () {
    testWidgets('exige o apelido', (tester) async {
      await pumpScreen(tester);

      await tester.enterText(fieldWithLabel('Apelido'), '');
      await tester.tap(find.text('Salvar veículo'));
      await tester.pumpAndSettle();

      expect(find.text('Campo obrigatório'), findsOneWidget);
    });

    testWidgets('aceita valor em formato pt-BR', (tester) async {
      await pumpScreen(tester);

      await tester.enterText(fieldWithLabel('Consumo médio'), '13,5');
      await tester.pumpAndSettle();

      expect(find.text('Valor inválido'), findsNothing);
    });
  });

  group('VehicleScreen · custos editáveis', () {
    testWidgets('adiciona e remove item de manutenção', (tester) async {
      await pumpScreen(tester);

      await tester.tap(find.text('Adicionar item'));
      await tester.pumpAndSettle();

      expect(find.text('Item'), findsOneWidget);
      expect(find.text('A cada'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close_rounded).first);
      await tester.pumpAndSettle();

      expect(find.text('Item'), findsNothing);
    });
  });

  group('VehicleScreen · acessibilidade', () {
    testWidgets('não estoura o layout com textScaler 2.0', (tester) async {
      await pumpScreen(tester, textScale: 2);

      expect(tester.takeException(), isNull);
    });
  });
}
