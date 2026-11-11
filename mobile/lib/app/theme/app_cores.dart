import 'package:flutter/material.dart';

/// Cores do sistema de design (docs/design/tokens.md). Só tema claro.
abstract final class AppCores {
  // Ação
  static const primary = Color(0xFF0165B7);
  static const primaryHover = Color(0xFF01589F);
  static const primaryPressed = Color(0xFF024A85);
  static const primarySoft = Color(0xFFE6F0FA);
  static const primaryDeep = Color(0xFF0A4E8F);
  static const onPrimary = Color(0xFFFFFFFF);

  // Superfícies
  static const surfacePage = Color(0xFFF3F6FA);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceSunken = Color(0xFFE9EEF4);
  static const surfaceInverse = Color(0xFF111214);
  static const onInverse = Color(0xFFFFFFFF);
  // Ciano do logo: só sobre surfaceInverse.
  static const glow = Color(0xFF06E2FF);

  // Texto e linhas
  static const ink = Color(0xFF111418);
  static const inkMuted = Color(0xFF475467);
  static const inkSubtle = Color(0xFF5F6B7A);
  static const line = Color(0xFFD6DDE6);
  static const lineStrong = Color(0xFF7B8796);
  // Trilho do indicador de carregamento sobre surfaceInverse. Pendência do
  // tokens.md resolvida na M3: o #2a2d32 das telas virou token.
  static const lineInverse = Color(0xFF2A2D32);

  // Estados
  static const success = Color(0xFF127A3F);
  static const successSoft = Color(0xFFE4F5EB);
  static const warning = Color(0xFFA14A00);
  static const warningSoft = Color(0xFFFFF0DE);
  static const error = Color(0xFFC0211D);
  static const errorSoft = Color(0xFFFDECEA);
  static const errorHover = Color(0xFFA01B18);

  // Missão surpresa (exclusivas dela)
  static const missao = Color(0xFFFFB81C);
  static const missaoSoft = Color(0xFFFFF5D6);
  static const missaoInk = Color(0xFF6E4600);
  static const onMissao = ink;

  // ink a 40%
  static const scrim = Color(0x66111418);
}
