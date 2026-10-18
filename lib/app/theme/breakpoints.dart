import 'package:flutter/widgets.dart';

/// Larguras de janela que mudam o layout.
///
/// São larguras de **janela**, não de aparelho: em tela dividida, janela
/// flutuante ou foldable, o aparelho mente e a janela não.
abstract final class Breakpoints {
  /// A partir daqui cabe navegação lateral e grid de 2 colunas.
  static const double medium = 600;

  /// A partir daqui cabe o padrão lista/detalhe lado a lado.
  static const double expanded = 840;

  /// Largura máxima confortável para formulário e texto corrido.
  static const double readableWidth = 560;

  /// Largura máxima do cartão do semáforo.
  static const double overlayCardWidth = 420;
}

/// Classe de largura da janela.
enum WindowSize {
  /// Menos de 600 dp: coluna única.
  compact,

  /// De 600 a 839 dp: navegação lateral.
  medium,

  /// 840 dp ou mais: lista e detalhe lado a lado.
  expanded;

  /// Classifica uma largura em dp.
  static WindowSize fromWidth(double width) {
    if (width >= Breakpoints.expanded) return WindowSize.expanded;
    if (width >= Breakpoints.medium) return WindowSize.medium;
    return WindowSize.compact;
  }

  /// Indica se há espaço para layouts de duas colunas.
  bool get isWide => this != WindowSize.compact;
}

/// Acesso à classe de largura a partir do contexto.
extension WindowSizeX on BuildContext {
  /// Classe de largura da janela atual.
  ///
  /// Usa `MediaQuery.sizeOf`, que só reconstrói quando o tamanho muda — ao
  /// contrário de `MediaQuery.of(context).size`, que reconstrói também quando
  /// o teclado abre.
  WindowSize get windowSize =>
      WindowSize.fromWidth(MediaQuery.sizeOf(this).width);
}
