import 'package:flutter/material.dart';

import 'app_cores.dart';
import 'app_tipografia.dart';

/// Tema do app. O ColorScheme é montado à mão a partir dos tokens,
/// sem fromSeed, como pede o design.
abstract final class AppTheme {
  static const _esquema = ColorScheme(
    brightness: Brightness.light,
    primary: AppCores.primary,
    onPrimary: AppCores.onPrimary,
    primaryContainer: AppCores.primarySoft,
    onPrimaryContainer: AppCores.primaryPressed,
    secondary: AppCores.primaryDeep,
    onSecondary: AppCores.onPrimary,
    tertiary: AppCores.missao,
    onTertiary: AppCores.onMissao,
    tertiaryContainer: AppCores.missaoSoft,
    onTertiaryContainer: AppCores.missaoInk,
    error: AppCores.error,
    onError: AppCores.onPrimary,
    errorContainer: AppCores.errorSoft,
    onErrorContainer: AppCores.error,
    surface: AppCores.surface,
    onSurface: AppCores.ink,
    onSurfaceVariant: AppCores.inkMuted,
    surfaceContainerHighest: AppCores.surfaceSunken,
    outline: AppCores.lineStrong,
    outlineVariant: AppCores.line,
    inverseSurface: AppCores.surfaceInverse,
    onInverseSurface: AppCores.onInverse,
    inversePrimary: AppCores.glow,
    scrim: AppCores.scrim,
    shadow: AppCores.ink,
    // Sem a camada de cor que o Material 3 aplica sobre superfícies elevadas.
    surfaceTint: Colors.transparent,
  );

  static const _textos = TextTheme(
    displaySmall: AppTipografia.display,
    headlineMedium: AppTipografia.titleLg,
    titleLarge: AppTipografia.title,
    titleMedium: AppTipografia.subtitle,
    bodyLarge: AppTipografia.bodyLg,
    bodyMedium: AppTipografia.body,
    bodySmall: AppTipografia.caption,
    labelLarge: AppTipografia.label,
    labelSmall: AppTipografia.overline,
  );

  static final claro = ThemeData(
    useMaterial3: true,
    colorScheme: _esquema,
    fontFamily: AppTipografia.familia,
    textTheme: _textos.apply(
      bodyColor: AppCores.ink,
      displayColor: AppCores.ink,
    ),
    scaffoldBackgroundColor: AppCores.surfacePage,
    // Material Symbols Rounded: wght 500, GRAD 0, opsz 24, FILL 0.
    iconTheme: const IconThemeData(
      weight: 500,
      grade: 0,
      opticalSize: 24,
      fill: 0,
    ),
  );
}
