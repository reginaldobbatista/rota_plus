import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rota_plus/app/providers.dart';
import 'package:rota_plus/app/router.dart';
import 'package:rota_plus/app/theme/breakpoints.dart';
import 'package:rota_plus/core/formatters/formatters.dart';
import 'package:rota_plus/features/vehicle/data/repositories/config_repository.dart';
import 'package:rota_plus/features/vehicle/domain/entities/work_profile.dart';

/// T08 — Perfis de trabalho.
///
/// Permite ao motorista alternar critérios conforme o cenário: rodar de dia na
/// cidade não tem as mesmas metas de uma madrugada de tarifa dinâmica.
class ProfilesScreen extends ConsumerWidget {
  /// Cria a tela.
  const ProfilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(workProfilesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Perfis de trabalho')),
      floatingActionButton: profiles.value == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _create(context, ref, profiles.value!),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Novo perfil'),
            ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.readableWidth,
            ),
            child: switch (profiles) {
              AsyncValue(hasError: true) => const _Empty(
                icon: Icons.error_outline_rounded,
                text: 'Não foi possível ler os perfis.',
              ),
              AsyncValue(:final value?) when value.isEmpty => const _Empty(
                icon: Icons.tune_rounded,
                text:
                    'Nenhum perfil ainda. Cadastre um veículo para o app criar '
                    'o primeiro automaticamente.',
              ),
              AsyncValue(:final value?) => _ProfileList(profiles: value),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
        ),
      ),
    );
  }

  Future<void> _create(
    BuildContext context,
    WidgetRef ref,
    List<WorkProfile> existing,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final repo = ref.read(configRepositoryProvider);
    final vehicleId = existing
        .map((p) => p.vehicleClientId)
        .firstWhere((id) => id != null, orElse: () => null);

    try {
      final id = await repo.saveProfile(
        WorkProfile.initial(
          name: 'Perfil ${existing.length + 1}',
          vehicleClientId: vehicleId,
        ),
      );
      if (!context.mounted) return;
      // Leva direto para as metas: um perfil sem critérios próprios não serve
      // para nada, e criar sem editar seria um passo vazio.
      context.push('${AppRoute.profiles.path}/$id');
    } on ConfigFailure catch (failure) {
      messenger.showSnackBar(SnackBar(content: Text(failure.message)));
    }
  }
}

class _ProfileList extends ConsumerWidget {
  const _ProfileList({required this.profiles});

  final List<WorkProfile> profiles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 96),
      itemCount: profiles.length + 1,
      itemBuilder: (context, index) {
        if (index == profiles.length) return _LimitHint(count: profiles.length);
        return _ProfileTile(profile: profiles[index]);
      },
    );
  }
}

class _ProfileTile extends ConsumerWidget {
  const _ProfileTile({required this.profile});

  final WorkProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final goals = profile.goals;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Card(
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          onTap: () =>
              context.push('${AppRoute.profiles.path}/${profile.clientId}'),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        profile.name,
                        style: theme.textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (profile.isActive)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(
                          label: const Text('Em uso'),
                          visualDensity: VisualDensity.compact,
                          backgroundColor: theme.colorScheme.primary.withValues(
                            alpha: 0.14,
                          ),
                          side: BorderSide.none,
                        ),
                      ),
                    _ProfileMenu(profile: profile),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${Fmt.perKm(goals.minRsPerKm)}/km · '
                  '${Fmt.perHour(goals.minRsPerHour)}/h · '
                  'nota ${Fmt.rating(goals.minPassengerRating)} · '
                  'até ${Fmt.km(goals.maxPickupKm)}',
                  style: theme.textTheme.bodySmall,
                ),
                if (!profile.isActive) ...[
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => ref
                        .read(configRepositoryProvider)
                        .activateProfile(profile.clientId!),
                    child: const Text('Usar este perfil'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileMenu extends ConsumerWidget {
  const _ProfileMenu({required this.profile});

  final WorkProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      tooltip: 'Opções do perfil',
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'edit', child: Text('Editar metas')),
        PopupMenuItem(value: 'duplicate', child: Text('Duplicar')),
        PopupMenuItem(value: 'delete', child: Text('Excluir')),
      ],
      onSelected: (action) => _handle(context, ref, action),
    );
  }

  Future<void> _handle(
    BuildContext context,
    WidgetRef ref,
    String action,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final repo = ref.read(configRepositoryProvider);
    final id = profile.clientId!;

    try {
      switch (action) {
        case 'edit':
          await context.push('${AppRoute.profiles.path}/$id');
        case 'duplicate':
          await repo.duplicateProfile(id);
        case 'delete':
          final confirmed = await _confirmDelete(context);
          if (confirmed) await repo.removeProfile(id);
      }
    } on ConfigFailure catch (failure) {
      messenger.showSnackBar(SnackBar(content: Text(failure.message)));
    }
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Excluir "${profile.name}"?'),
        content: const Text(
          'As corridas já registradas com este perfil continuam no histórico.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

class _LimitHint extends StatelessWidget {
  const _LimitHint({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remaining = ConfigRepository.maxProfiles - count;

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        remaining > 0
            ? '$count de ${ConfigRepository.maxProfiles} perfis usados.'
            : 'Você atingiu o limite de ${ConfigRepository.maxProfiles} perfis.',
        textAlign: TextAlign.center,
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
