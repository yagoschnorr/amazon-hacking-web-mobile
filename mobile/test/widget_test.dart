import 'dart:async';

import 'package:circuito_descobertas/app/theme/app_cores.dart';
import 'package:circuito_descobertas/app/theme/app_theme.dart';
import 'package:circuito_descobertas/features/auth/presentation/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('tema segue os tokens do design', () {
    final tema = AppTheme.claro;
    expect(tema.scaffoldBackgroundColor, AppCores.surfacePage);
    expect(tema.colorScheme.primary, AppCores.primary);
    expect(tema.textTheme.bodyMedium?.fontFamily, 'Figtree');
  });

  group('SplashPage', () {
    Widget montar(Future<void> Function() garantirSessao) {
      return MaterialApp(
        theme: AppTheme.claro,
        home: SplashPage(
          garantirSessao: garantirSessao,
          destino: (_) => const Text('início'),
        ),
      );
    }

    testWidgets('mostra a abertura enquanto a sessão é criada', (tester) async {
      final sessao = Completer<void>();
      await tester.pumpWidget(montar(() => sessao.future));

      expect(find.text('Circuito de Descobertas'), findsOneWidget);
      expect(find.text('Carregando estandes…'), findsOneWidget);
    });

    testWidgets('abre o destino quando a sessão existe', (tester) async {
      await tester.pumpWidget(montar(() async {}));
      await tester.pumpAndSettle();

      expect(find.text('início'), findsOneWidget);
    });

    testWidgets('mostra sem conexão na falha e tenta de novo', (tester) async {
      var tentativas = 0;
      await tester.pumpWidget(
        montar(() async {
          tentativas++;
          if (tentativas == 1) throw Exception('sem rede');
        }),
      );
      await tester.pump();

      expect(
        find.text('Não foi possível carregar os estandes.'),
        findsOneWidget,
      );

      await tester.tap(find.text('Tentar de novo'));
      await tester.pumpAndSettle();

      expect(tentativas, 2);
      expect(find.text('início'), findsOneWidget);
    });
  });
}
