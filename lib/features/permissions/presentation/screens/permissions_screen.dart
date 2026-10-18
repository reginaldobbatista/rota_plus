import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rota_plus/app/theme/breakpoints.dart';

/// Uma permissão exigida pelo app, com o motivo em linguagem do motorista.
@immutable
final class PermissionItem {
  /// Cria o item.
  const PermissionItem({
    required this.title,
    required this.why,
    required this.icon,
    required this.permission,
    this.essential = true,
  });

  /// Nome da permissão.
  final String title;

  /// Por que o app precisa dela.
  ///
  /// Exigido pelo Google Play como *prominent disclosure*, e necessário de
  /// qualquer forma: pedir acesso sem explicar é como o app perde a confiança
  /// do usuário na primeira tela.
  final String why;

  /// Ícone ilustrativo.
  final IconData icon;

  /// Permissão correspondente, quando o `permission_handler` cobre.
  final Permission? permission;

  /// Indica se o app fica inutilizável sem ela.
  final bool essential;
}

/// Permissões que o Rota Plus solicita.
const List<PermissionItem> kPermissions = [
  PermissionItem(
    title: 'Notificações',
    why:
        'Mostra o aviso de que o monitoramento está ativo enquanto você roda. '
        'É exigência do Android para o app continuar funcionando com a tela '
        'desligada.',
    icon: Icons.notifications_rounded,
    permission: Permission.notification,
  ),
  PermissionItem(
    title: 'Sobrepor outros apps',
    why:
        'Permite mostrar o cartão do semáforo por cima do Uber, 99 e inDrive. '
        'Sem isso você precisaria sair do app de corrida para ver o veredicto.',
    icon: Icons.layers_rounded,
    permission: Permission.systemAlertWindow,
  ),
  PermissionItem(
    title: 'Ignorar otimização de bateria',
    why:
        'Impede o Android de encerrar o monitoramento durante o expediente. '
        'Sem isso o app para sozinho depois de algum tempo.',
    icon: Icons.battery_charging_full_rounded,
    permission: Permission.ignoreBatteryOptimizations,
  ),
  PermissionItem(
    title: 'Acessibilidade',
    why:
        'Lê apenas o valor, a distância e o tempo da oferta na tela do Uber, '
        '99 e inDrive, para calcular se vale a pena. O app não lê nenhum outro '
        'aplicativo, não guarda o texto da tela e nada disso sai do aparelho.',
    icon: Icons.accessibility_new_rounded,
    // Não há API de runtime: só é possível abrir a tela de Acessibilidade do
    // sistema e o motorista ativar manualmente.
    permission: null,
  ),
  PermissionItem(
    title: 'Localização',
    why:
        'Opcional. Usada só para mostrar em quais regiões você ganha mais. '
        'A posição é arredondada antes de ser guardada.',
    icon: Icons.place_rounded,
    permission: Permission.locationWhenInUse,
    essential: false,
  ),
];

/// T15 — Permissões e configuração técnica.
class PermissionsScreen extends ConsumerStatefulWidget {
  /// Cria a tela.
  const PermissionsScreen({super.key});

  @override
  ConsumerState<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends ConsumerState<PermissionsScreen>
    with WidgetsBindingObserver {
  Map<String, PermissionStatus> _statuses = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaitedRefresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // O motorista concede a permissão nos Ajustes do sistema e volta. Sem
    // reconsultar aqui, a tela continuaria mostrando "pendente".
    if (state == AppLifecycleState.resumed) unawaitedRefresh();
  }

  void unawaitedRefresh() {
    _refresh().ignore();
  }

  Future<void> _refresh() async {
    final result = <String, PermissionStatus>{};

    for (final item in kPermissions) {
      final permission = item.permission;
      if (permission == null) continue;
      result[item.title] = await permission.status;
    }

    if (!mounted) return;
    setState(() {
      _statuses = result;
      _loading = false;
    });
  }

  Future<void> _request(PermissionItem item) async {
    final permission = item.permission;

    if (permission == null) {
      // Acessibilidade não tem API de runtime: só abrir os Ajustes.
      await openAppSettings();
      return;
    }

    final status = await permission.request();

    if (status.isPermanentlyDenied && mounted) {
      await openAppSettings();
    }
    unawaitedRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Permissões')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.readableWidth,
            ),
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                    children: [
                      const _Intro(),
                      for (final item in kPermissions)
                        _PermissionCard(
                          item: item,
                          status: _statuses[item.title],
                          onRequest: () => _request(item),
                        ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        'O Rota Plus só pede o que precisa para avaliar as corridas. '
        'Cada permissão abaixo explica para que serve.',
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({
    required this.item,
    required this.status,
    required this.onRequest,
  });

  final PermissionItem item;
  final PermissionStatus? status;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final granted = status?.isGranted ?? false;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(item.icon, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(item.title, style: theme.textTheme.titleMedium),
                  ),
                  _StatusChip(granted: granted, essential: item.essential),
                ],
              ),
              const SizedBox(height: 10),
              Text(item.why, style: theme.textTheme.bodySmall),
              if (!granted) ...[
                const SizedBox(height: 14),
                FilledButton(
                  onPressed: onRequest,
                  child: Text(
                    item.permission == null ? 'Abrir Ajustes' : 'Permitir',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.granted, required this.essential});

  final bool granted;
  final bool essential;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Ícone e texto, nunca só a cor: o estado precisa ser legível por quem
    // tem daltonismo e por leitor de tela.
    final (icon, label) = granted
        ? (Icons.check_circle_rounded, 'Concedida')
        : essential
        ? (Icons.error_outline_rounded, 'Pendente')
        : (Icons.remove_circle_outline_rounded, 'Opcional');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
