import 'package:rota_plus/core/config/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Erro de autenticação já traduzido para o motorista.
class AuthFailure implements Exception {
  /// Cria a falha.
  const AuthFailure(this.message);

  /// Mensagem pronta para a UI.
  final String message;

  @override
  String toString() => message;
}

/// Conta do motorista.
///
/// A conta é **opcional**. O app funciona inteiro sem ela: cálculo, histórico,
/// despesas e fechamento vivem no aparelho. Entrar serve para sincronizar e
/// não perder os dados ao trocar de celular.
///
/// Essa escolha é consequência direta do local-first: exigir login de um
/// motorista às cinco da manhã, sem sinal, para ele saber se a corrida vale a
/// pena seria contradizer a premissa do produto.
class AuthRepository {
  /// Cria o repositório.
  AuthRepository({SupabaseClient? client}) : _client = client;

  final SupabaseClient? _client;

  /// Indica se há backend configurado.
  bool get isAvailable => Env.hasSupabase;

  SupabaseClient get _supabase {
    final client =
        _client ?? (Env.hasSupabase ? Supabase.instance.client : null);
    if (client == null) {
      throw const AuthFailure(
        'A conta na nuvem ainda não foi configurada neste app.',
      );
    }
    return client;
  }

  /// Usuário autenticado, ou `null` em modo local.
  User? get currentUser => Env.hasSupabase ? _supabase.auth.currentUser : null;

  /// Observa mudanças de sessão.
  Stream<User?> watchUser() {
    if (!Env.hasSupabase) return Stream.value(null);
    return _supabase.auth.onAuthStateChange.map((event) => event.session?.user);
  }

  /// Entra com e-mail e senha.
  Future<void> signIn({required String email, required String password}) =>
      _guard(
        () => _supabase.auth.signInWithPassword(
          email: email.trim(),
          password: password,
        ),
      );

  /// Cria uma conta com e-mail e senha.
  Future<void> signUp({required String email, required String password}) =>
      _guard(
        () => _supabase.auth.signUp(email: email.trim(), password: password),
      );

  /// Envia o e-mail de recuperação de senha.
  Future<void> resetPassword(String email) => _guard(
    () => _supabase.auth.resetPasswordForEmail(
      email.trim(),
      redirectTo: 'io.r2b.rotaplus://login-callback',
    ),
  );

  /// Entra com Google.
  ///
  /// Usa PKCE com deep link: o fluxo implícito devolveria o token na URL,
  /// onde qualquer app que registre o mesmo esquema poderia lê-lo.
  Future<void> signInWithGoogle() => _guard(
    () => _supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.r2b.rotaplus://login-callback',
      authScreenLaunchMode: LaunchMode.externalApplication,
    ),
  );

  /// Sai da conta.
  ///
  /// Os dados locais **permanecem**: o motorista continua enxergando o próprio
  /// histórico. Apagar tudo ao sair seria destruir dado que é dele.
  Future<void> signOut() => _guard(() => _supabase.auth.signOut());

  /// Executa uma operação traduzindo os erros conhecidos.
  Future<void> _guard(Future<void> Function() operation) async {
    try {
      await operation();
    } on AuthException catch (error) {
      throw AuthFailure(_translate(error));
    } on Object {
      throw const AuthFailure(
        'Não foi possível conectar. Verifique sua internet e tente de novo.',
      );
    }
  }

  /// Traduz o erro do servidor para algo acionável.
  ///
  /// A mensagem crua do GoTrue vem em inglês e fala de "credentials"; o
  /// motorista precisa saber o que fazer, não o que o servidor pensou.
  static String _translate(AuthException error) {
    final code = error.code ?? '';
    final message = error.message.toLowerCase();

    if (code == 'invalid_credentials' ||
        message.contains('invalid login credentials')) {
      return 'E-mail ou senha incorretos.';
    }
    if (code == 'user_already_exists' ||
        message.contains('already registered')) {
      return 'Já existe uma conta com este e-mail. Tente entrar.';
    }
    if (code == 'weak_password' || message.contains('password should be')) {
      return 'Senha muito curta. Use pelo menos 10 caracteres.';
    }
    if (code == 'over_email_send_rate_limit' ||
        message.contains('rate limit')) {
      return 'Muitas tentativas. Aguarde alguns minutos.';
    }
    if (message.contains('email not confirmed')) {
      return 'Confirme seu e-mail antes de entrar.';
    }
    return 'Não foi possível concluir. Tente de novo em instantes.';
  }
}
