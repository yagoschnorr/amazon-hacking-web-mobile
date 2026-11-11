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
