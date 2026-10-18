import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rota_plus/core/config/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Guarda a sessão do Supabase no Keystore/Keychain.
///
/// O padrão do SDK é `SharedPreferences`, que é texto plano acessível por
/// backup do dispositivo. Para um app com dado financeiro isso não serve.
final class SecureLocalStorage extends LocalStorage {
  /// Cria o armazenamento seguro de sessão.
  const SecureLocalStorage();

  static const String _key = 'supabase.session';

  // A partir da v10 do flutter_secure_storage o Android já usa armazenamento
  // criptografado por padrão, então não há opção a configurar aqui.
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  Future<void> initialize() async {}

  @override
  Future<String?> accessToken() => _storage.read(key: _key);

  @override
  Future<bool> hasAccessToken() => _storage.containsKey(key: _key);

  @override
  Future<void> persistSession(String persistSessionString) =>
      _storage.write(key: _key, value: persistSessionString);

  @override
  Future<void> removePersistedSession() => _storage.delete(key: _key);
}

/// Inicializa os serviços do app e devolve os overrides do `ProviderScope`.
///
/// Quando não há credenciais do Supabase (`--dart-define` ausente), o app roda
/// em **modo local**: o núcleo de cálculo e a UI funcionam normalmente e nada
/// de rede é tentado. É o que permite desenvolver e testar a feature principal
/// antes de o backend estar provisionado.
Future<List<Override>> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Env.hasSupabase) {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      publishableKey: Env.supabasePublishableKey,
      authOptions: const FlutterAuthClientOptions(
        // Explícito de propósito, embora hoje seja o padrão do SDK: o implicit
        // flow expõe o token na URL de redirect. Se um dia o padrão mudar, esta
        // linha impede a regressão silenciosa.
        // ignore: avoid_redundant_argument_values
        authFlowType: AuthFlowType.pkce,
        localStorage: SecureLocalStorage(),
      ),
    );
  }

  return const <Override>[];
}
