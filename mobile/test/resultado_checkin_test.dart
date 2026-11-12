import 'package:circuito_descobertas/app/theme/app_theme.dart';
import 'package:circuito_descobertas/features/checkin/data/checkin_service.dart';
import 'package:circuito_descobertas/features/checkin/presentation/resultado_checkin_page.dart';
import 'package:circuito_descobertas/features/estandes/data/estande.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const estande = Estande(
  id: 'E01',
  nome: 'Estande Teste',
  descricao: 'Descrição de teste',
  localizacao: 'Corredor X',
);

/// Abre o retorno sobre uma tela vazia e devolve a ação com que ele fechou.
Future<AcaoRetorno?> Function(String botao) montar(
  WidgetTester tester,
  ResultadoCheckin resultado,
) {
  AcaoRetorno? acao;
  return (botao) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.claro,
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              acao = await Navigator.of(context).push<AcaoRetorno>(
                MaterialPageRoute(
                  builder: (_) => ResultadoCheckinPage(resultado: resultado),
                ),
              );
            },
            child: const Text('abrir'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(botao));
    await tester.pumpAndSettle();
    return acao;
  };
}

void main() {
  test('mensagemFaltam trata zero, um e vários', () {
    expect(mensagemFaltam(0), 'Você completou o circuito.');
    expect(mensagemFaltam(1), 'Falta 1 estande para completar o circuito.');
    expect(mensagemFaltam(3), 'Faltam 3 estandes para completar o circuito.');
  });

  testWidgets('sucesso mostra progresso e chip do estande', (tester) async {
    final tocar = montar(
      tester,
      const ResultadoCheckin(
        TipoResultado.sucesso,
        estande: estande,
        faltam: 1,
      ),
    );
    final acao = await tocar('Ler outro QR code');
    expect(acao, AcaoRetorno.lerOutro);

    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    expect(find.text('Visita registrada.'), findsOneWidget);
    expect(
      find.text('Falta 1 estande para completar o circuito.'),
      findsOneWidget,
    );
    expect(find.text('Estande Teste · Corredor X'), findsOneWidget);
  });

  testWidgets('já registrado mostra o horário da visita', (tester) async {
    final tocar = montar(
      tester,
      ResultadoCheckin(
        TipoResultado.jaRegistrado,
        estande: estande,
        registradoEm: DateTime(2026, 11, 11, 10, 42),
      ),
    );
    expect(await tocar('Ver estandes'), AcaoRetorno.voltarAoInicio);

    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    expect(
      find.text('Sua visita foi registrada às 10h42 e conta uma vez só.'),
      findsOneWidget,
    );
  });

  testWidgets('estande inativo sem dados não mostra o chip', (tester) async {
    final tocar = montar(
      tester,
      const ResultadoCheckin(TipoResultado.estandeInativo),
    );
    expect(await tocar('Ler outro QR code'), AcaoRetorno.lerOutro);

    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    expect(find.text('Este estande não está ativo.'), findsOneWidget);
    expect(find.textContaining(' · '), findsNothing);
  });

  testWidgets('erro oferece tentar de novo', (tester) async {
    final tocar = montar(tester, const ResultadoCheckin(TipoResultado.erro));
    expect(await tocar('Tentar de novo'), AcaoRetorno.tentarDeNovo);
  });

  testWidgets('QR inválido volta ao início', (tester) async {
    final tocar = montar(
      tester,
      const ResultadoCheckin(TipoResultado.qrInvalido),
    );
    expect(await tocar('Voltar ao início'), AcaoRetorno.voltarAoInicio);
  });
}
