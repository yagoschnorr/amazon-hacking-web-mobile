import 'package:flutter/material.dart';

/// Escala tipográfica do sistema de design (docs/design/tokens.md).
/// Uma família só, Figtree, empacotada em assets/fonts.
abstract final class AppTipografia {
  static const familia = 'Figtree';

  /// Contagens, tempos e códigos usam algarismos tabulares.
  static const tabular = [FontFeature.tabularFigures()];

  // 40/44, 800, −0,01em
  static const display = TextStyle(
    fontFamily: familia,
    fontSize: 40,
    height: 44 / 40,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.4,
  );

  // 28/34, 700, −0,005em
  static const titleLg = TextStyle(
    fontFamily: familia,
    fontSize: 28,
    height: 34 / 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.14,
  );

  // 22/28, 700
  static const title = TextStyle(
    fontFamily: familia,
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w700,
  );

  // 18/24, 600
  static const subtitle = TextStyle(
    fontFamily: familia,
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
  );

  // 16/24, 400: corpo no app
  static const bodyLg = TextStyle(
    fontFamily: familia,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
  );

  // 15/22, 400
  static const body = TextStyle(
    fontFamily: familia,
    fontSize: 15,
    height: 22 / 15,
    fontWeight: FontWeight.w400,
  );

  // 15/20, 700: botões e rótulos
  static const label = TextStyle(
    fontFamily: familia,
    fontSize: 15,
    height: 20 / 15,
    fontWeight: FontWeight.w700,
  );

  // 13/18, 500: ajuda, localização no cartão, legendas
  static const caption = TextStyle(
    fontFamily: familia,
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w500,
  );

  // 12/16, 700, 0,12em. O texto vai em caixa alta no widget (toUpperCase).
  static const overline = TextStyle(
    fontFamily: familia,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.44,
  );

  // 17/22, 700: botão principal do app (AppButton)
  static const appButton = TextStyle(
    fontFamily: familia,
    fontSize: 17,
    height: 22 / 17,
    fontWeight: FontWeight.w700,
  );

  // Tamanhos internos dos componentes e fora da escala (tokens.md)

  // Selo "Visitado às 10h42": 13/18, 700
  static const selo = TextStyle(
    fontFamily: familia,
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w700,
    fontFeatures: tabular,
  );

  // Iniciais do avatar do estande: 18px, 800, 0,02em
  static const iniciais = TextStyle(
    fontFamily: familia,
    fontSize: 18,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.36,
  );

  // Avatar grande no detalhe do app: 22px, 800
  static const iniciaisGrande = TextStyle(
    fontFamily: familia,
    fontSize: 22,
    fontWeight: FontWeight.w800,
  );

  // Detalhe do app: descrição, 18/26, 400
  static const descricaoDetalhe = TextStyle(
    fontFamily: familia,
    fontSize: 18,
    height: 26 / 18,
    fontWeight: FontWeight.w400,
  );

  // Detalhe do app: valor das linhas de informação, 16/24, 600
  static const valorInfo = TextStyle(
    fontFamily: familia,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
  );

  // Tela de retorno: sobretítulo 12/16, 800, 0,12em (caixa alta no widget)
  static const sobretituloRetorno = TextStyle(
    fontFamily: familia,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.44,
  );

  // Tela de retorno: título 28/34, 800, −0,005em
  static const tituloRetorno = TextStyle(
    fontFamily: familia,
    fontSize: 28,
    height: 34 / 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.14,
  );

  // Tela de retorno: detalhe (chip do estande) 14/20, 600
  static const detalheRetorno = TextStyle(
    fontFamily: familia,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
  );

  // Missão: sobretítulo do banner e do topo, 12/16, 800, 0,12em
  static const sobretituloMissao = sobretituloRetorno;

  // Banner da missão: título 22/28, 800
  static const tituloBanner = TextStyle(
    fontFamily: familia,
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w800,
  );

  // Tempo da missão (banner e chip do topo): 14/20, 700, tabular
  static const tempoMissao = TextStyle(
    fontFamily: familia,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w700,
    fontFeatures: tabular,
  );

  // Faixa "Missão surpresa" no cartão: 12/16, 800, 0,1em
  static const faixaMissao = TextStyle(
    fontFamily: familia,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.2,
  );

  // Topo da missão: título 28/34, 800
  static const tituloMissao = TextStyle(
    fontFamily: familia,
    fontSize: 28,
    height: 34 / 28,
    fontWeight: FontWeight.w800,
  );
}
