import 'package:flutter/material.dart';

import '../../app/theme/app_cores.dart';
import '../../app/theme/app_medidas.dart';

/// Rodapé fixo do app: surface-page, borda superior de 1px em line e
/// padding 12px 16px 16px em volta do AppButton.
class RodapeFixo extends StatelessWidget {
  const RodapeFixo({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Container soma a espessura da borda ao padding, como no CSS.
    return Container(
      decoration: const BoxDecoration(
        color: AppCores.surfacePage,
        border: Border(top: BorderSide(color: AppCores.line)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppEspacos.s4,
            AppEspacos.s3,
            AppEspacos.s4,
            AppEspacos.s4,
          ),
          child: child,
        ),
      ),
    );
  }
}
