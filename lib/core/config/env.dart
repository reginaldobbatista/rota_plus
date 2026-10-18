/// Configuração de ambiente, injetada em tempo de build.
///
/// Nada aqui vem de arquivo versionado. Em CI os valores entram por
/// `--dart-define-from-file=env/prod.json`, gerado a partir dos *secrets* do
/// runner.
///
/// **Nunca** adicione aqui a `service_role` do Supabase, chave secreta do
/// Stripe ou chave secreta do RevenueCat: tudo que é compilado no app pode ser
/// extraído do APK. Privilégio de servidor vive em Edge Function.
abstract final class Env {
  /// URL do projeto Supabase.
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');

  /// Chave publicável do Supabase (antes chamada de `anon key`).
  ///
  /// É segura no cliente **apenas** porque toda tabela tem RLS. Se uma tabela
  /// nova subir sem RLS, esta chave passa a ler o banco inteiro.
  ///
  /// O nome do define continua `SUPABASE_ANON_KEY`, que é como o painel do
  /// Supabase e os exemplos de CI a identificam.
  static const String supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
  );

  /// DSN do Sentry. Vazio desliga o envio de erros.
  static const String sentryDsn = String.fromEnvironment('SENTRY_DSN');

  /// Chave pública do SDK do RevenueCat.
  static const String revenueCatPublicKey = String.fromEnvironment(
    'REVENUECAT_PUBLIC_KEY',
  );

  /// Indica se há credenciais do Supabase para inicializar o cliente.
  ///
  /// Sem elas o app roda em modo local: o núcleo de cálculo e a UI funcionam,
  /// e nada de sincronização é tentado. É o que permite desenvolver a feature
  /// principal antes de o backend existir.
  static bool get hasSupabase =>
      supabaseUrl.isNotEmpty && supabasePublishableKey.isNotEmpty;

  /// Indica se o Sentry deve ser inicializado.
  static bool get hasSentry => sentryDsn.isNotEmpty;
}
