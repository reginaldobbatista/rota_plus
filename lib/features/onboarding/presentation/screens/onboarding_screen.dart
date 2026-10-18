import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rota_plus/app/providers.dart';
import 'package:rota_plus/app/router.dart';
import 'package:rota_plus/app/theme/app_theme.dart';
import 'package:rota_plus/app/theme/breakpoints.dart';

/// Um passo da apresentação inicial.
@immutable
final class _Slide {
  const _Slide({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;
}

/// T02 — Apresentação inicial.
///
/// Três telas, não mais: o motorista baixou o app para resolver um problema,
/// não para ler. Cada slide responde uma pergunta e sai da frente.
class OnboardingScreen extends ConsumerStatefulWidget {
  /// Cria a tela.
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const List<_Slide> _slides = [
    _Slide(
      icon: Icons.traffic_rounded,
      title: 'Saiba antes de aceitar',
      body:
          'Quando a oferta aparece no Uber, 99 ou inDrive, o Rota Plus mostra '
          'na hora se ela vale a pena: verde para aceitar, amarelo para '
          'avaliar, vermelho para recusar.',
    ),
    _Slide(
      icon: Icons.calculate_rounded,
      title: 'Com o custo do seu carro',
      body:
          'Combustível, manutenção, depreciação e IPVA entram na conta. '
          'O app descobre o seu custo por quilômetro e avisa quando a corrida '
          'fica abaixo dele — ou seja, quando você pagaria para trabalhar.',
    ),
    _Slide(
      icon: Icons.insights_rounded,
      title: 'E mostra o resultado real',
      body:
          'Registre despesas e expediente para ver quanto a hora realmente '
          'rendeu, descontando o tempo parado esperando chamada.',
    ),
  ];

  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isLast => _index == _slides.length - 1;

  Future<void> _finish() async {
    await ref.read(appSettingsRepositoryProvider).completeOnboarding();
    if (!mounted) return;
    // Direto para o cadastro do veículo: sem ele o app não calcula nada, e
    // mandar para o dashboard vazio seria entregar uma tela sem resposta.
    context.go(AppRoute.vehicle.path);
  }

  void _next() {
    if (_isLast) {
      _finish().ignore();
      return;
    }
    _controller.nextPage(
      duration: AppTheme.motion,
      curve: AppTheme.motionCurve,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.readableWidth,
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => _finish().ignore(),
                    child: const Text('Pular'),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    onPageChanged: (i) => setState(() => _index = i),
                    itemCount: _slides.length,
                    itemBuilder: (context, i) => _SlideView(slide: _slides[i]),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < _slides.length; i++)
                      AnimatedContainer(
                        duration: AppTheme.motion,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _index ? 22 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _index
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant.withValues(
                                  alpha: 0.3,
                                ),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: FilledButton(
                    onPressed: _next,
                    child: Text(_isLast ? 'Começar' : 'Próximo'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SlideView extends StatelessWidget {
  const _SlideView({required this.slide});

  final _Slide slide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Rola porque com fonte grande o texto do slide não cabe na altura.
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(slide.icon, size: 56, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 32),
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text(
            slide.body,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
