import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota_plus/app/providers.dart';
import 'package:rota_plus/app/theme/breakpoints.dart';
import 'package:rota_plus/features/auth/data/repositories/auth_repository.dart';

/// T03 — Entrar ou criar conta.
///
/// A conta é opcional: serve para sincronizar e não perder os dados ao trocar
/// de aparelho. O app funciona inteiro sem ela, e a tela diz isso.
class LoginScreen extends ConsumerStatefulWidget {
  /// Cria a tela.
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _creatingAccount = false;
  bool _busy = false;
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final repo = ref.read(authRepositoryProvider);
    await _run(() async {
      if (_creatingAccount) {
        await repo.signUp(email: _email.text, password: _password.text);
      } else {
        await repo.signIn(email: _email.text, password: _password.text);
      }
    }, success: _creatingAccount ? 'Conta criada.' : 'Tudo certo.');
  }

  Future<void> _google() =>
      _run(ref.read(authRepositoryProvider).signInWithGoogle, success: null);

  Future<void> _forgotPassword() async {
    if (_email.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite seu e-mail primeiro.')),
      );
      return;
    }

    await _run(
      () => ref.read(authRepositoryProvider).resetPassword(_email.text),
      success: 'Enviamos um link de recuperação para seu e-mail.',
    );
  }

  Future<void> _run(
    Future<void> Function() action, {
    required String? success,
  }) async {
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      await action();
      if (!mounted) return;
      if (success != null) {
        messenger.showSnackBar(SnackBar(content: Text(success)));
      }
      if (navigator.canPop()) navigator.pop();
    } on AuthFailure catch (failure) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(failure.message)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final available = ref.read(authRepositoryProvider).isAvailable;

    return Scaffold(
      appBar: AppBar(title: Text(_creatingAccount ? 'Criar conta' : 'Entrar')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 32 + MediaQuery.viewInsetsOf(context).bottom,
            ),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: Breakpoints.readableWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!available) const _UnavailableCard(),

                      const _PurposeCard(),
                      const SizedBox(height: 24),

                      TextFormField(
                        controller: _email,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          prefixIcon: Icon(Icons.mail_outline_rounded),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          final text = value?.trim() ?? '';
                          if (text.isEmpty) return 'Informe seu e-mail';
                          if (!text.contains('@') || !text.contains('.')) {
                            return 'E-mail inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _password,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            tooltip: _obscure ? 'Mostrar' : 'Ocultar',
                          ),
                        ),
                        obscureText: _obscure,
                        autofillHints: const [AutofillHints.password],
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                        validator: (value) {
                          final text = value ?? '';
                          if (text.isEmpty) return 'Informe sua senha';
                          // O servidor também valida; aqui é só para não
                          // gastar uma ida à rede com senha curta demais.
                          if (_creatingAccount && text.length < 10) {
                            return 'Use pelo menos 10 caracteres';
                          }
                          return null;
                        },
                      ),

                      if (!_creatingAccount) ...[
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _busy ? null : _forgotPassword,
                            child: const Text('Esqueci minha senha'),
                          ),
                        ),
                      ] else
                        const SizedBox(height: 20),

                      FilledButton(
                        onPressed: _busy || !available ? null : _submit,
                        child: Text(
                          _busy
                              ? 'Aguarde…'
                              : _creatingAccount
                              ? 'Criar conta'
                              : 'Entrar',
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: _busy || !available ? null : _google,
                        icon: const Icon(Icons.g_mobiledata_rounded, size: 28),
                        label: const Text('Continuar com Google'),
                      ),

                      const SizedBox(height: 20),
                      Center(
                        child: TextButton(
                          onPressed: _busy
                              ? null
                              : () => setState(
                                  () => _creatingAccount = !_creatingAccount,
                                ),
                          child: Text(
                            _creatingAccount
                                ? 'Já tenho conta'
                                : 'Criar uma conta',
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),
                      Text(
                        'Você pode usar o app sem conta. Ela serve para não '
                        'perder seus dados se trocar de celular.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Explica para que serve a conta, antes de pedir os dados.
class _PurposeCard extends StatelessWidget {
  const _PurposeCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(Icons.cloud_sync_rounded, color: theme.colorScheme.primary),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                'Com uma conta, suas corridas e despesas ficam salvas também '
                'na nuvem — e voltam se você trocar de aparelho.',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Avisa quando o app foi compilado sem backend.
class _UnavailableCard extends StatelessWidget {
  const _UnavailableCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        color: theme.colorScheme.errorContainer,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'Esta versão do app foi compilada sem a conta na nuvem. '
            'Tudo continua salvo no aparelho.',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
