import 'package:flutter_test/flutter_test.dart';
import 'package:rota_plus/core/money/money_input.dart';

import '../support/fixtures.dart';

void main() {
  group('MoneyInput.tryParse', () {
    test('aceita vírgula como separador decimal (pt-BR)', () {
      expect(MoneyInput.tryParse('12,50'), d('12.50'));
      expect(MoneyInput.tryParse('0,99'), d('0.99'));
    });

    test('aceita ponto como separador decimal', () {
      expect(MoneyInput.tryParse('12.50'), d('12.50'));
      expect(MoneyInput.tryParse('6.0'), d('6'));
    });

    test('aceita inteiro sem separador', () {
      expect(MoneyInput.tryParse('150'), d('150'));
    });

    test('ignora símbolo de moeda e espaços', () {
      expect(MoneyInput.tryParse(r'R$ 12,50'), d('12.50'));
      expect(MoneyInput.tryParse('  150 '), d('150'));
    });

    test('trata ponto de milhar com vírgula decimal', () {
      expect(MoneyInput.tryParse('1.234,56'), d('1234.56'));
      expect(MoneyInput.tryParse('12.345,00'), d('12345'));
    });

    test('trata vírgula de milhar com ponto decimal', () {
      expect(MoneyInput.tryParse('1,234.56'), d('1234.56'));
    });

    test('ponto com três decimais é separador de milhar', () {
      // O caso que quebra a implementação ingênua: `1.234` precisa ser mil
      // duzentos e trinta e quatro, não um real e vinte e três.
      expect(MoneyInput.tryParse('1.234'), d('1234'));
      expect(MoneyInput.tryParse('84.000'), d('84000'));
    });

    test('múltiplos pontos são todos de milhar', () {
      expect(MoneyInput.tryParse('1.234.567'), d('1234567'));
    });

    test('rejeita texto vazio ou sem dígito', () {
      expect(MoneyInput.tryParse(''), isNull);
      expect(MoneyInput.tryParse('   '), isNull);
      expect(MoneyInput.tryParse('abc'), isNull);
      expect(MoneyInput.tryParse(r'R$'), isNull);
    });

    test('rejeita valor negativo', () {
      // Despesa negativa não existe no domínio; quem quis dizer outra coisa
      // precisa escolher outra categoria.
      expect(MoneyInput.tryParse('-10'), isNull);
    });

    test('aceita zero', () {
      expect(MoneyInput.tryParse('0'), d('0'));
    });
  });
}
