import 'package:circuito_descobertas/app/app.dart';
import 'package:circuito_descobertas/app/theme/app_cores.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app abre a tela inicial com o tema do design', (tester) async {
    await tester.pumpWidget(const CircuitoApp());

    final contexto = tester.element(find.byType(Scaffold));
    final tema = Theme.of(contexto);
    expect(tema.scaffoldBackgroundColor, AppCores.surfacePage);
    expect(tema.colorScheme.primary, AppCores.primary);
    expect(tema.textTheme.bodyMedium?.fontFamily, 'Figtree');
  });
}
