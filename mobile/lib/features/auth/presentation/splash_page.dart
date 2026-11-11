import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/theme/app_cores.dart';
import '../../../app/theme/app_medidas.dart';
import '../../../app/theme/app_tipografia.dart';
import '../../../core/widgets/tela_sem_conexao.dart';

/// Abertura do app (docs/design/mobile/01-abertura.png). Fica na tela
/// enquanto a sessão anônima é criada; se falhar, mostra a tela sem conexão.
class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key,
    required this.garantirSessao,
    required this.destino,
  });

  final Future<void> Function() garantirSessao;

  /// Tela aberta depois que a sessão existe.
  final WidgetBuilder destino;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  var _falhou = false;

  @override
  void initState() {
    super.initState();
    _iniciarSessao();
  }

  Future<void> _iniciarSessao() async {
    try {
      await widget.garantirSessao();
    } catch (erro) {
      debugPrint('Falha ao criar a sessão anônima: $erro');
      if (mounted) setState(() => _falhou = true);
      return;
    }
    if (!mounted) return;
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: widget.destino));
  }

  void _tentarDeNovo() {
    setState(() => _falhou = false);
    _iniciarSessao();
  }

  @override
  Widget build(BuildContext context) {
    if (_falhou) return TelaSemConexao(aoTentarDeNovo: _tentarDeNovo);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppCores.surfaceInverse,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppForaDaEscala.respiro,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: AppForaDaEscala.tracoLargura,
                        height: AppForaDaEscala.tracoAltura,
                        decoration: const ShapeDecoration(
                          color: AppCores.glow,
                          shape: StadiumBorder(),
                        ),
                      ),
                      const SizedBox(height: AppEspacos.s4),
                      Text(
                        'Circuito de Descobertas',
                        textAlign: TextAlign.center,
                        style: AppTipografia.display.copyWith(
                          color: AppCores.onInverse,
                        ),
                      ),
                      const SizedBox(height: AppEspacos.s4),
                      Text(
                        'Visite os estandes e registre cada descoberta.',
                        textAlign: TextAlign.center,
                        style: AppTipografia.bodyLg.copyWith(
                          color: AppCores.onInverse,
                        ),
                      ),
                      const SizedBox(height: AppForaDaEscala.abertura),
                      const _IndicadorCarregamento(),
                      const SizedBox(height: AppEspacos.s3),
                      Text(
                        'Carregando estandes…',
                        textAlign: TextAlign.center,
                        style: AppTipografia.caption.copyWith(
                          color: AppCores.onInverse,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppForaDaEscala.respiro,
                  ),
                  child: Image.asset(
                    'assets/images/logo_amazon_hacking.png',
                    height: AppForaDaEscala.logoAbertura,
                    semanticLabel: 'Amazon Hacking',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Anel de 40px com traço de 4px: trilho em lineInverse e um arco de um
/// quarto em glow, girando em 0,9s (2,4s com movimento reduzido).
class _IndicadorCarregamento extends StatefulWidget {
  const _IndicadorCarregamento();

  @override
  State<_IndicadorCarregamento> createState() => _IndicadorCarregamentoState();
}

class _IndicadorCarregamentoState extends State<_IndicadorCarregamento>
    with SingleTickerProviderStateMixin {
  late final _giro = AnimationController(vsync: this);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduzido = MediaQuery.disableAnimationsOf(context);
    _giro
      ..duration = Duration(milliseconds: reduzido ? 2400 : 900)
      ..repeat();
  }

  @override
  void dispose() {
    _giro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _giro,
      child: const CustomPaint(
        size: Size.square(AppForaDaEscala.indicador),
        painter: _AnelPainter(),
      ),
    );
  }
}

class _AnelPainter extends CustomPainter {
  const _AnelPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const traco = AppForaDaEscala.indicadorTraco;
    final centro = size.center(Offset.zero);
    final raio = size.width / 2 - traco;
    final pincel = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = traco;

    canvas.drawCircle(centro, raio, pincel..color = AppCores.lineInverse);
    canvas.drawArc(
      Rect.fromCircle(center: centro, radius: raio),
      -math.pi / 2,
      math.pi / 2,
      false,
      pincel
        ..color = AppCores.glow
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_AnelPainter oldDelegate) => false;
}
