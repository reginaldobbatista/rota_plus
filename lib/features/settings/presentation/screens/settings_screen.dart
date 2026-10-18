import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rota_plus/app/providers.dart';
import 'package:rota_plus/app/router.dart';
import 'package:rota_plus/app/theme/breakpoints.dart';
import 'package:rota_plus/core/config/env.dart';

/// T13 — Ajustes.
///
/// Reúne o que não cabe nas abas de operação: configuração do veículo, metas,
/// perfis e o estado da sincronização.
class SettingsScreen extends ConsumerWidget {
  /// Cria a tela.
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(pendingSyncCountProvider).value ?? 0;
    final vehicles = ref.watch(vehiclesProvider).value ?? const [];
    final profile = ref.watch(activeProfileProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.readableWidth,
            ),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                const _SectionTitle('Configuração'),
                _Tile(
                  icon: Icons.directions_car_rounded,
                  title: 'Meu veículo e custos',
                  subtitle: vehicles.isEmpty
                      ? 'Não cadastrado'
                      : vehicles.first.summary,
                  onTap: () => context.push(AppRoute.vehicle.path),
                ),
                _Tile(
                  icon: Icons.flag_rounded,
                  title: 'Metas',
                  subtitle: profile == null
                      ? 'Sem perfil ativo'
                      : 'Perfil "${profile.name}"',
                  onTap: () => context.push(AppRoute.goals.path),
                ),
                _Tile(
                  icon: Icons.layers_rounded,
                  title: 'Perfis de trabalho',
                  subtitle: 'Alternar critérios por cenário',
                  onTap: () => context.push(AppRoute.profiles.path),
                ),

                const _SectionTitle('Operação'),
                _Tile(
                  icon: Icons.insights_rounded,
                  title: 'Estatísticas',
                  subtitle: 'Melhores horários e comparativo de plataformas',
                  onTap: () => context.push(AppRoute.statistics.path),
                ),
                _Tile(
                  icon: Icons.tune_rounded,
                  title: 'Simulador do semáforo',
                  subtitle: 'Calibrar metas e registrar corrida manualmente',
                  onTap: () => context.push(AppRoute.simulator.path),
                ),
                _Tile(
                  icon: Icons.receipt_long_rounded,
                  title: 'Despesas',
                  subtitle: 'Combustível, alimentação, pedágio e outros',
                  onTap: () => context.push(AppRoute.expenses.path),
                ),

                const _SectionTitle('Sistema'),
                _Tile(
                  icon: Icons.verified_user_rounded,
                  title: 'Permissões',
                  subtitle: 'O que o app precisa e por quê',
                  onTap: () => context.push(AppRoute.permissions.path),
                ),

                const _SectionTitle('Sincronização'),
                _SyncTile(pending: pending),

                const _SectionTitle('Sobre'),
                const _Tile(
                  icon: Icons.info_outline_rounded,
                  title: 'Rota Plus',
                  subtitle: 'Versão de desenvolvimento',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Estado da sincronização, descrito sem jargão.
class _SyncTile extends StatelessWidget {
  const _SyncTile({required this.pending});

  final int pending;

  @override
  Widget build(BuildContext context) {
    // O motorista precisa saber que o dado está salvo mesmo sem conexão.
    // Silêncio aqui gera desconfiança no app inteiro.
    final (icon, title, subtitle) = switch ((Env.hasSupabase, pending)) {
      (false, 0) => (
        Icons.phone_android_rounded,
        'Somente neste aparelho',
        'Tudo é salvo localmente. A conta na nuvem ainda não foi ligada.',
      ),
      (false, _) => (
        Icons.phone_android_rounded,
        'Somente neste aparelho',
        '$pending ${pending == 1 ? 'registro aguarda' : 'registros aguardam'} '
            'envio para quando a conta for ligada.',
      ),
      (true, 0) => (
        Icons.cloud_done_outlined,
        'Tudo sincronizado',
        'Nenhum registro pendente.',
      ),
      (true, _) => (
        Icons.cloud_upload_outlined,
        'Aguardando conexão',
        '$pending ${pending == 1 ? 'registro salvo' : 'registros salvos'} '
            'no aparelho, a enviar.',
      ),
    };

    return _Tile(icon: icon, title: title, subtitle: subtitle);
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 24, 4, 8),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: onTap == null
              ? null
              : const Icon(Icons.chevron_right_rounded),
          onTap: onTap,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      ),
    );
  }
}
