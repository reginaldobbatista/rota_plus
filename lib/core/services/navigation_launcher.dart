import 'package:url_launcher/url_launcher.dart';

/// Aplicativo de navegação preferido.
enum NavigationApp {
  /// Waze.
  waze,

  /// Google Maps.
  googleMaps;

  /// Nome exibido na UI.
  String get label => switch (this) {
    NavigationApp.waze => 'Waze',
    NavigationApp.googleMaps => 'Google Maps',
  };
}

/// Abre o destino no app de navegação do motorista.
///
/// Sempre com um plano B: se o app preferido não estiver instalado, tenta o
/// outro; se nenhum estiver, abre no navegador. Um botão que não faz nada é
/// pior do que não existir.
class NavigationLauncher {
  /// Cria o lançador.
  const NavigationLauncher();

  /// Abre uma busca por endereço.
  Future<bool> openAddress(String address, {required NavigationApp prefer}) {
    final query = Uri.encodeComponent(address.trim());
    if (query.isEmpty) return Future.value(false);

    return _openFirstAvailable([
      if (prefer == NavigationApp.waze) 'waze://?q=$query&navigate=yes',
      'google.navigation:q=$query',
      if (prefer == NavigationApp.googleMaps) 'waze://?q=$query&navigate=yes',
      'https://www.google.com/maps/search/?api=1&query=$query',
    ]);
  }

  /// Abre uma coordenada.
  Future<bool> openCoordinates({
    required double latitude,
    required double longitude,
    required NavigationApp prefer,
  }) {
    final coords = '$latitude,$longitude';

    return _openFirstAvailable([
      if (prefer == NavigationApp.waze) 'waze://?ll=$coords&navigate=yes',
      'google.navigation:q=$coords',
      if (prefer == NavigationApp.googleMaps) 'waze://?ll=$coords&navigate=yes',
      'https://www.google.com/maps/dir/?api=1&destination=$coords',
    ]);
  }

  Future<bool> _openFirstAvailable(List<String> urls) async {
    for (final url in urls) {
      final uri = Uri.parse(url);
      // `canLaunchUrl` exige o pacote declarado em <queries> no manifesto.
      // Sem isso o Android responde "não" mesmo com o app instalado.
      if (await canLaunchUrl(uri)) {
        if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          return true;
        }
      }
    }
    return false;
  }
}
