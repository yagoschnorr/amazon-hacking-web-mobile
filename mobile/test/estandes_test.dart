import 'package:circuito_descobertas/app/theme/app_theme.dart';
import 'package:circuito_descobertas/features/estandes/data/estande.dart';
import 'package:circuito_descobertas/features/estandes/presentation/estande_card.dart';
import 'package:circuito_descobertas/features/estandes/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Estande estande(String id, String nome) => Estande(
  id: id,
  nome: nome,
  descricao: 'Descrição de teste',
  localizacao: 'Corredor X',
);

void main() {
  group('Estande.iniciais', () {
    test('usa a primeira e a última palavra', () {
      expect(estande('E01', 'Trilha Verde').iniciais, 'TV');
      expect(estande('E02', 'Casa de Farinha').iniciais, 'CF');
      expect(estande('E03', 'maré viva').iniciais, 'MV');
    });

    test('com uma palavra usa as duas primeiras letras', () {
      expect(estande('E04', 'Robótica').iniciais, 'RO');
      expect(estande('E05', 'X').iniciais, 'X');
    });
  });

  test('horaVisita usa o formato 10h42', () {
    expect(horaVisita(DateTime(2026, 11, 11, 10, 42)), '10h42');
    expect(horaVisita(DateTime(2026, 11, 11, 9, 5)), '9h05');
  });

  group('ListaEstandes', () {
    Future<void> montar(
      WidgetTester tester,
      List<Estande> estandes,
      Map<String, DateTime?> visitas,
    ) {
      return tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.claro,
          home: ListaEstandes(
            estandes: estandes,
            visitas: visitas,
            aoTocar: (_) {},
          ),
        ),
      );
    }

    testWidgets('mostra o progresso e marca os visitados', (tester) async {
      await montar(
        tester,
        [estande('E01', 'Maré Viva'), estande('E07', 'Trilha Verde')],
        {'E01': DateTime(2026, 11, 11, 10, 42), 'E99': null},
      );

      expect(find.text('1 de 2 estandes visitados'), findsOneWidget);
      expect(find.text('2 abertos agora'), findsOneWidget);
      expect(find.text('Visitado às 10h42'), findsOneWidget);
      expect(find.text('TV'), findsOneWidget);
    });

    testWidgets('usa o singular com um estande', (tester) async {
      await montar(tester, [estande('E01', 'Maré Viva')], {});

      expect(find.text('0 de 1 estande visitado'), findsOneWidget);
      expect(find.text('1 aberto agora'), findsOneWidget);
    });
  });
}
