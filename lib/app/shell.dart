import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rota_plus/app/theme/breakpoints.dart';

/// Um destino da navegação principal.
@immutable
final class ShellDestination {
  /// Cria o destino.
  const ShellDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  /// Rótulo exibido.
  final String label;

  /// Ícone no estado normal.
  final IconData icon;

  /// Ícone no estado selecionado.
  final IconData selectedIcon;
}

/// Destinos da navegação principal, na ordem em que aparecem.
const List<ShellDestination> kShellDestinations = [
  ShellDestination(
    label: 'Início',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded,
  ),
  ShellDestination(
    label: 'Histórico',
    icon: Icons.history_outlined,
    selectedIcon: Icons.history_rounded,
  ),
  ShellDestination(
    label: 'Caixa',
    icon: Icons.account_balance_wallet_outlined,
    selectedIcon: Icons.account_balance_wallet_rounded,
  ),
  ShellDestination(
    label: 'Ajustes',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings_rounded,
  ),
];

/// Casca de navegação do app.
///
/// Troca entre barra inferior e trilho lateral pela **largura da janela**, não
/// pelo tipo de aparelho: em tela dividida ou foldable o aparelho mente e a
/// janela não.
class AppShell extends StatelessWidget {
  /// Cria a casca.
  const AppShell({required this.navigationShell, super.key});

  /// Shell do go_router, que preserva o estado de cada aba.
  final StatefulNavigationShell navigationShell;

  void _onDestination(int index) {
    navigationShell.goBranch(
      index,
      // Tocar na aba já ativa volta para a raiz dela, que é o comportamento
      // esperado em qualquer app com navegação por abas.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= Breakpoints.medium;

        if (wide) {
          return Scaffold(
            body: Row(
              children: [
                _Rail(
                  selectedIndex: navigationShell.currentIndex,
                  onSelected: _onDestination,
                  extended: constraints.maxWidth >= Breakpoints.expanded,
                ),
                const VerticalDivider(width: 1),
                Expanded(child: navigationShell),
              ],
            ),
          );
        }

        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _onDestination,
            destinations: [
              for (final d in kShellDestinations)
                NavigationDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selectedIcon),
                  label: d.label,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _Rail extends StatelessWidget {
  const _Rail({
    required this.selectedIndex,
    required this.onSelected,
    required this.extended,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final bool extended;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        // O trilho precisa rolar: com fonte grande os rótulos não cabem na
        // altura da tela e estourariam.
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight:
                MediaQuery.sizeOf(context).height -
                MediaQuery.viewPaddingOf(context).vertical,
          ),
          child: IntrinsicHeight(
            child: NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: onSelected,
              extended: extended,
              labelType: extended
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all,
              destinations: [
                for (final d in kShellDestinations)
                  NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: Text(d.label),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
