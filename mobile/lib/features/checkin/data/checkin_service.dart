import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/analytics/analytics_service.dart';
import '../../../core/constants/firestore.dart';
import '../../estandes/data/estande.dart';

enum TipoResultado { sucesso, qrInvalido, estandeInativo, jaRegistrado, erro }

class ResultadoCheckin {
  const ResultadoCheckin(
    this.tipo, {
    this.estande,
    this.registradoEm,
    this.faltam,
  });

  final TipoResultado tipo;

  /// Dados do estande, quando o app conseguiu ler.
  final Estande? estande;

  /// Horário da visita já registrada (resultado `jaRegistrado`).
  final DateTime? registradoEm;

  /// Estandes ativos que ainda faltam visitar (resultado `sucesso`).
  final int? faltam;
}

class CheckinService {
  CheckinService(this.visitanteId);

  final String visitanteId;
  final _db = FirebaseFirestore.instance;
  final _analytics = AnalyticsService();

  /// Sem rede, a gravação fica na fila do Firestore e não confirma.
  static const _limiteGravacao = Duration(seconds: 10);

  /// Registra a visita ao estande lido no QR, nesta ordem:
  /// 1. estande inexistente → `qrInvalido`; leitura negada → `estandeInativo`;
  /// 2. check-in já existente → `jaRegistrado`;
  /// 3. grava `{visitanteId}_{estandeId}` com o horário do servidor;
  /// 4. gravação confirmada → evento `checkin_concluido` e `sucesso`;
  ///    qualquer outra falha → `erro`.
  ///
  /// Quem garante as regras é o Firestore: um estande inativado entre a
  /// leitura e a gravação é barrado e vira `estandeInativo`.
  Future<ResultadoCheckin> registrar(String estandeId) async {
    final refEstande = _db.collection(Colecoes.estandes).doc(estandeId);
    final refCheckin = _db
        .collection(Colecoes.checkins)
        .doc('${visitanteId}_$estandeId');
    Estande? estande;

    try {
      final docEstande = await refEstande.get();
      if (!docEstande.exists) {
        return const ResultadoCheckin(TipoResultado.qrInvalido);
      }
      estande = Estande.fromFirestore(docEstande);
      if (docEstande.data()?[CamposEstande.ativo] != true) {
        return ResultadoCheckin(TipoResultado.estandeInativo, estande: estande);
      }

      final existente = await _checkinExistente(refCheckin, estande);
      if (existente != null) return existente;

      await refCheckin
          .set({
            CamposCheckin.visitanteId: visitanteId,
            CamposCheckin.estandeId: estandeId,
            CamposCheckin.criadoEm: FieldValue.serverTimestamp(),
          })
          .timeout(_limiteGravacao);
      unawaited(_analytics.checkinConcluido(estandeId));

      return ResultadoCheckin(
        TipoResultado.sucesso,
        estande: estande,
        faltam: await _faltam(),
      );
    } on FirebaseException catch (erro) {
      if (erro.code != 'permission-denied') {
        return ResultadoCheckin(TipoResultado.erro, estande: estande);
      }
      // Leitura do estande negada: ele existe, mas está inativo.
      if (estande == null) {
        return const ResultadoCheckin(TipoResultado.estandeInativo);
      }
      // Gravação negada: o estande foi inativado ou a visita acabou de ser
      // registrada (por exemplo, em outra leitura).
      try {
        final existente = await _checkinExistente(refCheckin, estande);
        if (existente != null) return existente;
      } on FirebaseException {
        // Segue como estande inativo.
      }
      return ResultadoCheckin(TipoResultado.estandeInativo, estande: estande);
    } on TimeoutException {
      return ResultadoCheckin(TipoResultado.erro, estande: estande);
    }
  }

  Future<ResultadoCheckin?> _checkinExistente(
    DocumentReference<Map<String, dynamic>> refCheckin,
    Estande estande,
  ) async {
    final doc = await refCheckin.get(
      // Uma gravação ainda não confirmada já traz um horário estimado.
      const GetOptions(serverTimestampBehavior: ServerTimestampBehavior.estimate),
    );
    if (!doc.exists) return null;
    return ResultadoCheckin(
      TipoResultado.jaRegistrado,
      estande: estande,
      registradoEm: (doc.data()?[CamposCheckin.criadoEm] as Timestamp?)
          ?.toDate(),
    );
  }

  /// Quantos estandes ativos o visitante ainda não visitou. Nulo se a
  /// consulta falhar: a visita já foi registrada e o retorno continua valendo.
  Future<int?> _faltam() async {
    try {
      final ativos = await _db
          .collection(Colecoes.estandes)
          .where(CamposEstande.ativo, isEqualTo: true)
          .get();
      final visitas = await _db
          .collection(Colecoes.checkins)
          .where(CamposCheckin.visitanteId, isEqualTo: visitanteId)
          .get();
      final visitados = {
        for (final doc in visitas.docs) doc.data()[CamposCheckin.estandeId],
      };
      return ativos.docs.where((doc) => !visitados.contains(doc.id)).length;
    } on FirebaseException {
      return null;
    }
  }
}
