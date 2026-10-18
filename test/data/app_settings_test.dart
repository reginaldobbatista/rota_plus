import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rota_plus/core/services/navigation_launcher.dart';
import 'package:rota_plus/data/local/database.dart';
import 'package:rota_plus/features/settings/data/repositories/app_settings_repository.dart';

void main() {
  late AppDatabase db;
  late AppSettingsRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = AppSettingsRepository(dao: db.settingsDao);
  });

  tearDown(() => db.close());

  group('AppSettingsRepository · padrões', () {
    test('banco vazio devolve os padrões do app', () async {
      final settings = await repo.watch().first;

      expect(settings.onboardingDone, isFalse);
      expect(settings.themeMode, ThemeMode.system);
      expect(settings.navigationApp, NavigationApp.waze);
    });

    test('o aviso por voz vem ligado por padrão', () async {
      // É recurso de segurança viária: o padrão precisa favorecer quem está
      // dirigindo, não o silêncio.
      final settings = await repo.watch().first;

      expect(settings.ttsEnabled, isTrue);
      expect(settings.ttsRate, 0.55);
    });
  });

  group('AppSettingsRepository · persistência', () {
    test('conclui o onboarding e lembra disso', () async {
      await repo.completeOnboarding();

      expect((await repo.watch().first).onboardingDone, isTrue);
    });

    test('guarda o tema escolhido', () async {
      await repo.setThemeMode(ThemeMode.dark);

      expect((await repo.watch().first).themeMode, ThemeMode.dark);
    });

    test('guarda o app de navegação preferido', () async {
      await repo.setNavigationApp(NavigationApp.googleMaps);

      expect(
        (await repo.watch().first).navigationApp,
        NavigationApp.googleMaps,
      );
    });

    test('desligar a voz é distinto de nunca ter configurado', () async {
      await repo.setTtsEnabled(enabled: false);

      expect((await repo.watch().first).ttsEnabled, isFalse);
    });

    test('limita a velocidade da fala a uma faixa utilizável', () async {
      await repo.setTtsRate(5);
      expect((await repo.watch().first).ttsRate, 1.0);

      await repo.setTtsRate(0);
      expect((await repo.watch().first).ttsRate, 0.3);
    });

    test('reapresentar o onboarding volta ao estado inicial', () async {
      await repo.completeOnboarding();
      await repo.resetOnboarding();

      expect((await repo.watch().first).onboardingDone, isFalse);
    });

    test('preferências convivem sem se sobrescrever', () async {
      await repo.setThemeMode(ThemeMode.dark);
      await repo.setNavigationApp(NavigationApp.googleMaps);
      await repo.completeOnboarding();

      final settings = await repo.watch().first;

      expect(settings.themeMode, ThemeMode.dark);
      expect(settings.navigationApp, NavigationApp.googleMaps);
      expect(settings.onboardingDone, isTrue);
    });

    test('valor corrompido cai no padrão em vez de quebrar', () async {
      // Uma versão futura pode gravar um nome de tema que esta não conhece.
      await db.settingsDao.write('theme_mode', 'neon');

      expect((await repo.watch().first).themeMode, ThemeMode.system);
    });
  });
}
