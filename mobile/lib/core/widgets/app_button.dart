import 'package:flutter/material.dart';

import '../../app/theme/app_cores.dart';
import '../../app/theme/app_medidas.dart';
import '../../app/theme/app_tipografia.dart';

/// Botão principal do app (AppButton do design), variação primary:
/// 56px de altura, largura total, formato de pílula e shadow-md.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        shape: StadiumBorder(),
        shadows: AppSombras.md,
      ),
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style:
            FilledButton.styleFrom(
              foregroundColor: AppCores.onPrimary,
              minimumSize: const Size.fromHeight(AppAlturas.controlLg),
              shape: const StadiumBorder(),
              textStyle: AppTipografia.appButton,
              iconSize: AppIcones.botao,
            ).copyWith(
              // Pressionado escurece para primary-pressed, sem véu do Material.
              backgroundColor: WidgetStateProperty.resolveWith(
                (estados) => estados.contains(WidgetState.pressed)
                    ? AppCores.primaryPressed
                    : AppCores.primary,
              ),
              overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            ),
      ),
    );
  }
}
