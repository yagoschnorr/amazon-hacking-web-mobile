import 'package:circuito_descobertas/app/theme/app_theme.dart';
import 'package:circuito_descobertas/features/estandes/data/estande.dart';
import 'package:circuito_descobertas/features/estandes/presentation/home_page.dart';
import 'package:circuito_descobertas/features/missao/data/missao.dart';
import 'package:circuito_descobertas/features/missao/data/missao_controller.dart';
import 'package:circuito_descobertas/features/missao/presentation/missao_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Estande estande(String id, String nome) => Estande(
  id: id,
  nome: nome,
  descricao: 'Descrição de teste',
  localizacao: 'Corredor $id',
);

final e01 = estande('E01', 'Estande Um');
final e02 = estande('E02', 'Estande Dois');
final e03 = estande('E03', 'Estande Três');

Missao ler({
  bool ativa = true,
  String ids = '["E01","E02"]',
  String inicio = '',
  int duracaoMin = 0,
}) => Missao.ler(
  ativa: ativa,
  estandesIdsJson: ids,
  inicio: inicio,
  duracaoMin: duracaoMin,
);

void main() {
  final agora = DateTime.utc(2026, 11, 11, 13, 50);

  group('Missao.ler', () {
    test('lê a lista de IDs', () {
      expect(ler().estandesIds, ['E01', 'E02']);
    });

    test('JSON malformado ou fora do formato vira lista vazia', () {
      expect(ler(ids: '["E01"').estandesIds, isEmpty);
      expect(ler(ids: '{"id":"E01"}').estandesIds, isEmpty);
      expect(ler(ids: '[1, "E02", ""]').estandesIds, ['E02']);
    });

    test('início e duração válidos dão prazo', () {
      final missao = ler(inicio: '2026-11-11T10:45:00-03:00', duracaoMin: 30);
      expect(missao.inicio, DateTime.utc(2026, 11, 11, 13, 45));
      expect(missao.fim, DateTime.utc(2026, 11, 11, 14, 15));
    });

    test('início inválido ou duração zero deixam sem prazo', () {
      expect(ler(inicio: 'amanhã', duracaoMin: 30).fim, isNull);
      expect(ler(inicio: '2026-11-11T10:45:00-03:00').fim, isNull);
    });
  });

  group('prazo', () {
    final missao = ler(inicio: '2026-11-11T10:45:00-03:00', duracaoMin: 30);

    test('vale só entre o início e o fim', () {
      expect(missao.emVigor(DateTime.utc(2026, 11, 11, 13, 44)), isFalse);
      expect(missao.emVigor(agora), isTrue);
      expect(missao.emVigor(DateTime.utc(2026, 11, 11, 14, 15)), isFalse);
    });

    test('sem prazo, vale enquanto estiver ligada', () {
      expect(ler().emVigor(agora), isTrue);
      expect(ler(ativa: false).emVigor(agora), isFalse);
    });

    test('arredonda os minutos para cima', () {
      expect(missao.minutosRestantes(agora), 25);
      expect(
        missao.minutosRestantes(DateTime.utc(2026, 11, 11, 14, 14, 30)),
        1,
      );
    });
  });

  group('concluidaNoCheckin', () {
    int? concluir(String id, Set<String> visitados, {Missao? missao}) =>
        (missao ?? ler()).concluidaNoCheckin(
          estandeId: id,
          ativos: const {'E01', 'E02', 'E03'},
          visitados: visitados,
          agora: agora,
        );

    test('o último participante pendente conclui a missão', () {
      expect(concluir('E02', {'E01', 'E02'}), 2);
    });

    test('ainda falta participante: não conclui', () {
      expect(concluir('E01', {'E01'}), isNull);
    });

    test('estande fora da missão não conclui de novo', () {
      expect(concluir('E03', {'E01', 'E02', 'E03'}), isNull);
    });

    test('participante inativo não conta e missão desligada não conclui', () {
      expect(concluir('E01', {'E01'}, missao: ler(ids: '["E01","E09"]')), 1);
      expect(
        concluir('E02', {'E01', 'E02'}, missao: ler(ativa: false)),
        isNull,
      );
    });
  });

  group('ResumoMissao', () {
    test('usa só os participantes ativos', () {
      final resumo = ResumoMissao.calcular(ler(ids: '["E02","E09"]'), [
        e01,
        e02,
      ], agora)!;
      expect(resumo.participantes, [e02]);
      expect(resumo.titulo, 'Visite 1 estande');
      expect(resumo.tempo, isNull);
    });

    test('sem participante ativo ou fora de vigor, é nulo', () {
      expect(ResumoMissao.calcular(ler(ids: '[]'), [e01], agora), isNull);
      expect(ResumoMissao.calcular(ler(ativa: false), [e01], agora), isNull);
    });

    test('título e tempo com prazo', () {
      final resumo = ResumoMissao.calcular(
        ler(inicio: '2026-11-11T10:45:00-03:00', duracaoMin: 30),
        [e01, e02],
        agora,
      )!;
      expect(resumo.titulo, 'Visite 2 estandes em 30 min');
      expect(resumo.tempo, 'Faltam 25 min');
    });

    test('mensagem do banner para nenhum, um e vários faltando', () {
      final resumo = ResumoMissao.calcular(ler(), [e01, e02], agora)!;
      expect(resumo.mensagemBanner(const {}), 'Faltam 2 estandes da missão.');
      expect(
        resumo.mensagemBanner({'E01': null}),
        'Falta Estande Dois, no Corredor E02.',
      );
      expect(
        resumo.mensagemBanner({'E01': null, 'E02': null}),
        'Você visitou os 2 estandes da missão.',
      );
    });

    test('concluída: título próprio e sem contagem', () {
      final resumo = ResumoMissao.calcular(
        ler(inicio: '2026-11-11T10:45:00-03:00', duracaoMin: 30),
        [e01, e02],
        agora,
      )!;
      expect(resumo.concluida({'E01': null}), isFalse);
      expect(resumo.tituloPara({'E01': null}), 'Visite 2 estandes em 30 min');
      expect(resumo.tempoPara({'E01': null}), 'Faltam 25 min');

      final todas = {'E01': null, 'E02': null};
      expect(resumo.concluida(todas), isTrue);
      expect(resumo.tituloPara(todas), 'Missão concluída!');
      expect(resumo.tempoPara(todas), isNull);
    });

    test('mensagem de conclusão no singular e no plural', () {
      expect(mensagemConcluida(1), 'Você visitou o estande da missão.');
      expect(mensagemConcluida(3), 'Você visitou os 3 estandes da missão.');
    });

    test('pendentes da missão sobem para o topo', () {
      final resumo = ResumoMissao.calcular(ler(ids: '["E03"]'), [
        e01,
        e02,
        e03,
      ], agora)!;
      expect(resumo.ordenar([e01, e02, e03], const {}), [e03, e01, e02]);
      expect(resumo.ordenar([e01, e02, e03], {'E03': null}), [e01, e02, e03]);
    });
  });

  testWidgets('início mostra banner e faixa só no participante pendente', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.claro,
        home: ListaEstandes(
          estandes: [e01, e02],
          visitas: const {'E01': null},
          aoTocar: (_) {},
          aoLerQrCode: () {},
          missao: ResumoMissao.calcular(ler(), [e01, e02], agora),
          aoVerMissao: () {},
        ),
      ),
    );
    expect(find.text('Visite 2 estandes'), findsOneWidget);
    expect(find.text('Ver missão'), findsOneWidget);
    // Banner e faixa do Estande Dois; o Estande Um já foi visitado.
    expect(find.text('MISSÃO SURPRESA'), findsNWidgets(2));
  });

  testWidgets('tela da missão fecha com aviso quando a missão desliga', (
    tester,
  ) async {
    final missao = MissaoController(relogio: () => agora)..atualizar(ler());
    addTearDown(missao.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.claro,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => MissaoPage(
                    missao: missao,
                    estandes: const Stream.empty(),
                    estandesIniciais: [e01, e02],
                    visitas: const Stream.empty(),
                    visitasIniciais: const {},
                    aoAbrirEstande: (_) {},
                  ),
                ),
              ),
              child: const Text('início'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('início'));
    await tester.pumpAndSettle();
    expect(find.text('Estandes participantes'), findsOneWidget);
    expect(find.text('Falta visitar'), findsNWidgets(2));

    missao.atualizar(Missao.desligada);
    await tester.pumpAndSettle();
    expect(find.text('Estandes participantes'), findsNothing);
    expect(find.text('início'), findsOneWidget);
    expect(find.text('Missão encerrada'), findsOneWidget);
  });
}
