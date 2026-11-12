import 'package:flutter/material.dart';

/// Espaços, raios, alturas e sombras do sistema de design
/// (docs/design/tokens.md). Grade de 4px.
abstract final class AppEspacos {
  static const s1 = 4.0;
  static const s2 = 8.0;
  static const s3 = 12.0;
  // Margem lateral do app; padding do cartão
  static const s4 = 16.0;
  static const s5 = 20.0;
  static const s6 = 24.0;
  static const s8 = 32.0;
  static const s12 = 48.0;
  static const s16 = 64.0;
}

abstract final class AppRaios {
  static const sm = 8.0;
  static const md = 12.0;
  // Cartões do app, banner da missão
  static const lg = 20.0;
  // Cantos inferiores do topo do app
  static const xl = 28.0;
  static const full = 9999.0;
}

abstract final class AppAlturas {
  static const controlSm = 36.0;
  static const controlMd = 44.0;
  // Botão principal do app (AppButton)
  static const controlLg = 56.0;
  // Menor área tocável no app
  static const touchMin = 48.0;
}

abstract final class AppBordas {
  // Contorno de cartões, divisórias
  static const fina = 1.0;
  // Campos de texto, botão tonal do app
  static const media = 1.5;
  // Cantos da moldura de mira
  static const mira = 4.0;

  /// Cartão destacado pela missão.
  static const missao = 2.0;
}

abstract final class AppSombras {
  // Cartões em repouso
  static const sm = [
    BoxShadow(color: Color(0x0F111418), offset: Offset(0, 1), blurRadius: 2),
    BoxShadow(color: Color(0x0A111418), offset: Offset(0, 1), blurRadius: 3),
  ];

  // Banner e cartão da missão, botão principal do app
  static const md = [
    BoxShadow(color: Color(0x14111418), offset: Offset(0, 4), blurRadius: 12),
  ];

  static const lg = [
    BoxShadow(color: Color(0x29111418), offset: Offset(0, 12), blurRadius: 32),
  ];
}

abstract final class AppIcones {
  // Etiquetas, localização no cartão
  static const xs = 16.0;
  // Selo Visitado, linha de progresso no topo do app
  static const sm = 18.0;
  // Padrão
  static const md = 20.0;
  // Botão principal do app, voltar e fechar
  static const botao = 24.0;
  // Avatar "visitado"
  static const lg = 28.0;
  // Ícone do banner da missão
  static const banner = 26.0;
  // Lista vazia e sem conexão
  static const estado = 48.0;
  // Telas de retorno e de permissão
  static const retorno = 64.0;
}

/// Medidas fora da escala usadas nas telas (tokens.md, última seção).
abstract final class AppForaDaEscala {
  // Padding superior do topo do app; inferior no topo do detalhe
  static const topoApp = 28.0;
  // Entre ícone e texto no topo do app e no selo Visitado
  static const iconeTexto = 6.0;
  // Padding horizontal das etiquetas (lado do texto)
  static const etiqueta = 10.0;
  // Entre nome, descrição e localização no cartão do estande
  static const textoCartao = 6.0;
  // Entre o ícone e o texto da instrução de leitura no detalhe
  static const iconeInstrucao = 10.0;
  // Altura das etiquetas e do selo Visitado
  static const alturaEtiqueta = 26.0;
  // Avatar do estande: 52px no cartão, 64px no detalhe
  static const avatar = 52.0;
  static const avatarGrande = 64.0;
  // Círculo do ícone nas linhas de informação do detalhe
  static const circuloInfo = 40.0;
  // Respiros da abertura
  static const respiro = 40.0;
  // Traço glow da abertura
  static const tracoLargura = 40.0;
  static const tracoAltura = 4.0;
  // Indicador de carregamento: anel de 40px com traço de 4px
  static const indicador = 40.0;
  static const indicadorTraco = 4.0;
  // Entre o texto da abertura e o indicador de carregamento
  static const abertura = 56.0;
  // Altura do logo do Amazon Hacking na abertura
  static const logoAbertura = 32.0;
  // Círculo do ícone na tela sem conexão
  static const circuloEstado = 96.0;
  // Círculo do ícone nas telas de retorno e de permissão
  static const circuloRetorno = 112.0;
  // Leitor de QR: mira de 256px com cantos de 48px e raio de 20px
  static const mira = 256.0;
  static const cantoMira = 48.0;
  // Entre a mira e a instrução de leitura
  static const miraTexto = 28.0;
  // Botão redondo da lanterna
  static const lanterna = 64.0;
  // Lista de passos da permissão de câmera: coluna dos números
  static const numeroPasso = 16.0;

  /// Círculo do ícone no banner da missão.
  static const circuloBanner = 44.0;

  /// Altura da faixa "Missão surpresa" no cartão, sem a borda.
  static const faixaMissao = 32.0;

  /// Barra de progresso do topo da missão.
  static const barraProgresso = 8.0;
}
