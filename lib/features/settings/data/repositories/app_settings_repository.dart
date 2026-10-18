import 'package:flutter/material.dart';
import 'package:rota_plus/core/services/navigation_launcher.dart';
import 'package:rota_plus/data/local/daos/settings_dao.dart';

/// Preferências do aparelho.
@immutable
final class AppSettings {
  /// Cria as preferências.
  const AppSettings({
    this.onboardingDone = false,
    this.themeMode = ThemeMode.system,
    this.ttsEnabled = true,
    this.ttsRate = 0.55,
    this.navigationApp = NavigationApp.waze,
  });

  /// Indica se o motorista já passou pela apresentação inicial.
  final bool onboardingDone;

  /// Tema escolhido.
  final ThemeMode themeMode;

  /// Indica se o aviso por voz está ligado.
  final bool ttsEnabled;

  /// Velocidade da fala, de 0.3 a 1.0.
  final double ttsRate;

  /// App de navegação preferido.
  final NavigationApp navigationApp;
}

/// Leitura e escrita das preferências do aparelho.
class AppSettingsRepository {
  /// Cria o repositório.
  const AppSettingsRepository({required SettingsDao dao}) : _dao = dao;

  static const String _kOnboardingDone = 'onboarding_done';
  static const String _kThemeMode = 'theme_mode';
  static const String _kTtsEnabled = 'tts_enabled';
  static const String _kTtsRate = 'tts_rate';
  static const String _kNavigationApp = 'navigation_app';

  final SettingsDao _dao;

  /// Observa as preferências.
  Stream<AppSettings> watch() => _dao.watchAll().map(_fromMap);

  /// Marca a apresentação inicial como concluída.
  Future<void> completeOnboarding() => _dao.write(_kOnboardingDone, 'true');

  /// Define o tema.
  Future<void> setThemeMode(ThemeMode mode) =>
      _dao.write(_kThemeMode, mode.name);

  /// Liga ou desliga o aviso por voz.
  Future<void> setTtsEnabled({required bool enabled}) =>
      _dao.write(_kTtsEnabled, '$enabled');

  /// Define a velocidade da fala.
  Future<void> setTtsRate(double rate) =>
      _dao.write(_kTtsRate, rate.clamp(0.3, 1).toString());

  /// Define o app de navegação preferido.
  Future<void> setNavigationApp(NavigationApp app) =>
      _dao.write(_kNavigationApp, app.name);

  /// Reapresenta o onboarding na próxima abertura.
  Future<void> resetOnboarding() => _dao.remove(_kOnboardingDone);

  AppSettings _fromMap(Map<String, String> values) {
    return AppSettings(
      onboardingDone: values[_kOnboardingDone] == 'true',
      themeMode: ThemeMode.values.firstWhere(
        (m) => m.name == values[_kThemeMode],
        orElse: () => ThemeMode.system,
      ),
      // Ausente significa ligado: o aviso por voz é recurso de segurança
      // viária, e o padrão deve favorecer quem está dirigindo.
      ttsEnabled: values[_kTtsEnabled] != 'false',
      ttsRate: double.tryParse(values[_kTtsRate] ?? '') ?? 0.55,
      navigationApp: NavigationApp.values.firstWhere(
        (a) => a.name == values[_kNavigationApp],
        orElse: () => NavigationApp.waze,
      ),
    );
  }
}
