import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../app/theme/app_cores.dart';
import '../../../app/theme/app_medidas.dart';
import '../../../app/theme/app_tipografia.dart';
import '../../auth/data/auth_service.dart';
import '../data/checkin_service.dart';
import '../data/qr_payload.dart';
import 'permissao_camera_negada.dart';
import 'resultado_checkin_page.dart';

/// Botão "Ler QR code" do início e do detalhe.
Future<void> abrirLeitor(BuildContext context) {
  return Navigator.of(context)
      .push<void>(MaterialPageRoute(builder: (_) => const ScannerPage()));
}

/// Leitor de QR code (docs/design/mobile/06-leitor-de-qr-code.png).
/// A câmera aparece só dentro da mira. Só a primeira leitura é processada:
/// o leitor fica pausado enquanto registra o check-in e até o retorno ser
/// fechado.
class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> with WidgetsBindingObserver {
  final _camera = MobileScannerController(formats: [BarcodeFormat.qrCode]);
  var _processando = false;
  var _foiParaConfiguracoes = false;

  /// Criado na primeira leitura: a sessão anônima já existe desde a abertura.
  late final _checkins = CheckinService(AuthService().uid);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_camera.dispose());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Na volta das configurações, tenta abrir a câmera de novo.
    if (state == AppLifecycleState.resumed && _foiParaConfiguracoes) {
      _foiParaConfiguracoes = false;
      _iniciarCamera();
    }
  }

  void _iniciarCamera() {
    unawaited(
      _camera.start().catchError((Object erro) {
        debugPrint('Falha ao iniciar a câmera: $erro');
      }),
    );
  }

  Future<void> _aoDetectar(BarcodeCapture captura) async {
    final texto = captura.barcodes.firstOrNull?.rawValue;
    if (_processando || texto == null) return;
    _processando = true;
    await _camera.pause();
    if (!mounted) return;

    final navegador = Navigator.of(context);
    final estandeId = parseQrPayload(texto);
    while (true) {
      final resultado = estandeId == null
          ? const ResultadoCheckin(TipoResultado.qrInvalido)
          : await _checkins.registrar(estandeId);
      if (!mounted) return;

      final acao = await navegador.push<AcaoRetorno>(
        MaterialPageRoute(
          builder: (_) => ResultadoCheckinPage(resultado: resultado),
        ),
      );
      if (!mounted) return;
      switch (acao) {
        case AcaoRetorno.tentarDeNovo:
          continue;
        case AcaoRetorno.voltarAoInicio:
          navegador.popUntil((rota) => rota.isFirst);
          return;
        case AcaoRetorno.lerOutro || null:
          _processando = false;
          _iniciarCamera();
          return;
      }
    }
  }

  void _abrirConfiguracoes() {
    _foiParaConfiguracoes = true;
    unawaited(abrirConfiguracoesDoApp());
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<MobileScannerState>(
      valueListenable: _camera,
      builder: (context, estado, _) {
        final semPermissao =
            estado.error?.errorCode == MobileScannerErrorCode.permissionDenied;
        // O leitor continua montado por baixo: o controlador da câmera
        // precisa do widget MobileScanner para iniciar.
        return Stack(
          children: [
            _Leitor(camera: _camera, estado: estado, aoDetectar: _aoDetectar),
            if (semPermissao)
              PermissaoCameraNegada(
                aoAbrirConfiguracoes: _abrirConfiguracoes,
                aoVoltar: () =>
                    Navigator.of(context).popUntil((rota) => rota.isFirst),
              ),
          ],
        );
      },
    );
  }
}

class _Leitor extends StatelessWidget {
  const _Leitor({
    required this.camera,
    required this.estado,
    required this.aoDetectar,
  });

  final MobileScannerController camera;
  final MobileScannerState estado;
  final ValueChanged<BarcodeCapture> aoDetectar;

  @override
  Widget build(BuildContext context) {
    const lado = AppForaDaEscala.mira;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppCores.surfaceInverse,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                // Botão fechar com 48px de área de toque, como o voltar.
                padding: const EdgeInsets.fromLTRB(
                  AppEspacos.s2,
                  AppEspacos.s3,
                  AppEspacos.s4,
                  0,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      tooltip: 'Fechar',
                      icon: const Icon(Symbols.close_rounded),
                      iconSize: AppIcones.botao,
                      color: AppCores.onInverse,
                      constraints: const BoxConstraints.tightFor(
                        width: AppAlturas.touchMin,
                        height: AppAlturas.touchMin,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(width: AppEspacos.s1),
                    Text(
                      'Ler QR code',
                      style: AppTipografia.subtitle.copyWith(
                        color: AppCores.onInverse,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox.square(
                        dimension: lado,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(AppRaios.lg),
                              child: MobileScanner(
                                controller: camera,
                                onDetect: aoDetectar,
                                // Lê só o que aparece dentro da mira.
                                scanWindow: const Rect.fromLTWH(
                                  0,
                                  0,
                                  lado,
                                  lado,
                                ),
                                placeholderBuilder: (_) => const SizedBox(),
                                errorBuilder: (_, _) => const SizedBox(),
                              ),
                            ),
                            const Positioned.fill(
                              child: CustomPaint(painter: _MiraPainter()),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppForaDaEscala.miraTexto),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppForaDaEscala.respiro,
                        ),
                        child: Text(
                          'Aponte a câmera para o QR code impresso no estande.',
                          textAlign: TextAlign.center,
                          style: AppTipografia.bodyLg.copyWith(
                            color: AppCores.onInverse,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _BotaoLanterna(camera: camera, estado: estado),
              const SizedBox(height: AppForaDaEscala.respiro),
            ],
          ),
        ),
      ),
    );
  }
}

/// Quatro cantos de 48px, borda de 4px em glow e raio de 20px.
class _MiraPainter extends CustomPainter {
  const _MiraPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const traco = AppBordas.mira;
    const canto = AppForaDaEscala.cantoMira;
    const raio = AppRaios.lg - traco / 2;
    final pincel = Paint()
      ..color = AppCores.glow
      ..style = PaintingStyle.stroke
      ..strokeWidth = traco;

    // A linha fica centrada no traço: recua meio traço das bordas.
    final area = (Offset.zero & size).deflate(traco / 2);
    const perna = canto - traco / 2;

    // Canto superior esquerdo, desenhado e espelhado para os outros três.
    final caminho = Path()
      ..moveTo(area.left, area.top + perna)
      ..lineTo(area.left, area.top + raio)
      ..arcToPoint(
        Offset(area.left + raio, area.top),
        radius: const Radius.circular(raio),
      )
      ..lineTo(area.left + perna, area.top);

    final centro = size.center(Offset.zero);
    for (final (sx, sy) in [
      (1.0, 1.0),
      (-1.0, 1.0),
      (1.0, -1.0),
      (-1.0, -1.0),
    ]) {
      canvas
        ..save()
        ..translate(centro.dx, centro.dy)
        ..scale(sx, sy)
        ..translate(-centro.dx, -centro.dy)
        ..drawPath(caminho, pincel)
        ..restore();
    }
  }

  @override
  bool shouldRepaint(_MiraPainter oldDelegate) => false;
}

/// Botão redondo de 64px: surface com a lanterna desligada, glow ligada.
/// Some (mantendo o espaço) quando o aparelho não tem lanterna.
class _BotaoLanterna extends StatelessWidget {
  const _BotaoLanterna({required this.camera, required this.estado});

  final MobileScannerController camera;
  final MobileScannerState estado;

  @override
  Widget build(BuildContext context) {
    final ligada = estado.torchState == TorchState.on;
    return Visibility(
      visible: estado.torchState != TorchState.unavailable,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: Column(
        children: [
          Semantics(
            button: true,
            toggled: ligada,
            label: 'Lanterna',
            excludeSemantics: true,
            child: Material(
              color: ligada ? AppCores.glow : AppCores.surface,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => unawaited(camera.toggleTorch()),
                child: SizedBox.square(
                  dimension: AppForaDaEscala.lanterna,
                  child: Icon(
                    ligada
                        ? Symbols.flashlight_on_rounded
                        : Symbols.flashlight_off_rounded,
                    size: AppIcones.lg,
                    color: AppCores.ink,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppEspacos.s2),
          Text(
            ligada ? 'Lanterna ligada' : 'Lanterna desligada',
            style: AppTipografia.caption.copyWith(color: AppCores.onInverse),
          ),
        ],
      ),
    );
  }
}
