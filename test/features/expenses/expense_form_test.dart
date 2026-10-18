import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rota_plus/app/theme/app_theme.dart';
import 'package:rota_plus/features/expenses/domain/entities/expense.dart';
import 'package:rota_plus/features/expenses/presentation/widgets/expense_form.dart';

import '../../support/fixtures.dart';

void main() {
  Future<ExpenseDraft?> pumpForm(
    WidgetTester tester, {
    Expense? initial,
    double textScale = 1,
  }) async {
    ExpenseDraft? submitted;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
          child: Scaffold(
            body: ExpenseForm(
              initial: initial,
              onSubmit: (draft) => submitted = draft,
            ),
          ),
        ),
      ),
    );

    return submitted;
  }

  Future<ExpenseDraft?> submitWith(
    WidgetTester tester,
    String amount, {
    Expense? initial,
  }) async {
    ExpenseDraft? submitted;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: ExpenseForm(
            initial: initial,
            onSubmit: (draft) => submitted = draft,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).first, amount);
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    return submitted;
  }

  group('ExpenseForm · validação', () {
    testWidgets('não envia com valor vazio', (tester) async {
      final submitted = await submitWith(tester, '');

      expect(submitted, isNull);
      expect(find.text('Informe um valor válido'), findsOneWidget);
    });

    testWidgets('não envia com valor zero', (tester) async {
      final submitted = await submitWith(tester, '0');

      expect(submitted, isNull);
      expect(find.text('O valor precisa ser maior que zero'), findsOneWidget);
    });

    testWidgets('não envia com texto não numérico', (tester) async {
      final submitted = await submitWith(tester, 'abc');

      expect(submitted, isNull);
    });

    testWidgets('aceita valor em formato pt-BR', (tester) async {
      final submitted = await submitWith(tester, '12,50');

      expect(submitted, isNotNull);
      expect(submitted!.amount, d('12.50'));
    });
  });

  group('ExpenseForm · campos por categoria', () {
    testWidgets('abastecimento mostra litros e odômetro', (tester) async {
      await pumpForm(tester);

      // Combustível é a categoria inicial.
      expect(find.text('Litros (opcional)'), findsOneWidget);
      expect(find.text('Odômetro (opcional)'), findsOneWidget);
    });

    testWidgets('outras categorias escondem litros e odômetro', (tester) async {
      await pumpForm(tester);

      await tester.tap(find.byType(DropdownButtonFormField<ExpenseCategory>));
      await tester.pumpAndSettle();
      await tester.tap(find.text(ExpenseCategory.parking.label).last);
      await tester.pumpAndSettle();

      expect(find.text('Litros (opcional)'), findsNothing);
      expect(find.text('Odômetro (opcional)'), findsNothing);
    });
  });

  group('ExpenseForm · edição', () {
    testWidgets('pré-carrega os dados da despesa existente', (tester) async {
      final expense = Expense(
        clientId: 'abc',
        category: ExpenseCategory.food,
        amount: d('32.50'),
        occurredAt: DateTime.utc(2026, 10, 17, 13),
        description: 'Almoço',
      );

      await pumpForm(tester, initial: expense);

      expect(find.text('Editar despesa'), findsOneWidget);
      expect(find.text('32.5'), findsOneWidget);
      expect(find.text('Almoço'), findsOneWidget);
    });
  });

  group('ExpenseForm · acessibilidade', () {
    testWidgets('não estoura o layout com textScaler 2.0', (tester) async {
      await pumpForm(tester, textScale: 2);

      expect(tester.takeException(), isNull);
      expect(find.text('Nova despesa'), findsOneWidget);
    });
  });
}
