import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firestore.dart';

class CheckinRepository {
  final _db = FirebaseFirestore.instance;

  /// Check-ins do próprio visitante em tempo real: ID do estande → horário
  /// da visita. O horário fica nulo enquanto o servidor não confirma a
  /// gravação.
  Stream<Map<String, DateTime?>> visitas(String visitanteId) {
    return _db
        .collection(Colecoes.checkins)
        .where(CamposCheckin.visitanteId, isEqualTo: visitanteId)
        .snapshots()
        .map(
          (snapshot) => {
            for (final doc in snapshot.docs)
              doc.data()[CamposCheckin.estandeId] as String:
                  (doc.data()[CamposCheckin.criadoEm] as Timestamp?)?.toDate(),
          },
        );
  }
}
