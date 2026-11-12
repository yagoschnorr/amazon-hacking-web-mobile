import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firestore.dart';
import 'estande.dart';

/// Sem dados do servidor e sem nada salvo no aparelho.
class SemConexaoException implements Exception {
  const SemConexaoException();
}

class EstandeRepository {
  final _db = FirebaseFirestore.instance;

  /// Estandes ativos em tempo real, ordenados por nome.
  ///
  /// Sem rede, o Firestore entrega o que tem no cache do aparelho. Lista
  /// vazia vinda só do cache vira [SemConexaoException], para a tela mostrar
  /// "Sem conexão" e não "Nenhum estande ativo". Quando a rede volta, o
  /// mesmo stream entrega a lista do servidor.
  Stream<List<Estande>> estandesAtivos() {
    return _db
        .collection(Colecoes.estandes)
        .where(CamposEstande.ativo, isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty && snapshot.metadata.isFromCache) {
            throw const SemConexaoException();
          }
          return snapshot.docs.map(Estande.fromFirestore).toList()..sort(
            (a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()),
          );
        });
  }
}
