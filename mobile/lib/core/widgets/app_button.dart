import 'package:flutter/material.dart';

import '../../app/theme/app_cores.dart';
import '../../app/theme/app_medidas.dart';
import '../../app/theme/app_tipografia.dart';

enum AppButtonVariante { primary, tonal }

/// Botão principal do app (AppButton do design): 56px de altura, largura
/// total e formato de pílula.
/// - `primary`: fundo primary, texto on-primary e shadow-md.
/// - `tonal`: fundo surface, contorno interno de 1,5px e texto em primary.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.variante = AppButtonVariante.primary,
  });

  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final AppButtonVariante variante;

  @override
  Widget build(BuildContext context) {
    final primario = variante == AppButtonVariante.primary;
    final estilo = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(
        Size.fromHeight(AppAlturas.controlLg),
      ),
      shape: WidgetStatePropertyAll(
        primario
            ? const StadiumBorder()
            : const StadiumBorder(
                side: BorderSide(
                  color: AppCores.primary,
                  width: AppBordas.media,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
      ),
      textStyle: const WidgetStatePropertyAll(AppTipografia.appButton),
      iconSize: const WidgetStatePropertyAll(AppIcones.botao),
      foregroundColor: WidgetStatePropertyAll(
        primario ? AppCores.onPrimary : AppCores.primary,
      ),
      iconColor: WidgetStatePropertyAll(
        primario ? AppCores.onPrimary : AppCores.primary,
      ),
      // Pressionado: primary-pressed no primário, sem véu do Material.
      backgroundColor: WidgetStateProperty.resolveWith((estados) {
        if (!primario) return AppCores.surface;
        return estados.contains(WidgetState.pressed)
            ? AppCores.primaryPressed
            : AppCores.primary;
      }),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      elevation: const WidgetStatePropertyAll(0),
    );

    final botao = icon == null
        ? FilledButton(onPressed: onPressed, style: estilo, child: Text(label))
        : FilledButton.icon(
            onPressed: onPressed,
            style: estilo,
            icon: Icon(icon),
            label: Text(label),
          );

    if (!primario) return botao;
    return DecoratedBox(
      decoration: const ShapeDecoration(
        shape: StadiumBorder(),
        shadows: AppSombras.md,
      ),
      child: botao,
    );
  }
}
