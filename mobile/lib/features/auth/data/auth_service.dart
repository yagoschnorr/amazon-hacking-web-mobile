import 'package:firebase_auth/firebase_auth.dart';

/// Sessão anônima do visitante. O uid anônimo é a identidade usada no
/// check-in e fica salvo no aparelho entre aberturas do app.
class AuthService {
  final _auth = FirebaseAuth.instance;

  /// Devolve o usuário atual ou cria uma sessão anônima se não houver.
  Future<User> garantirSessao() async {
    // O primeiro evento traz a sessão restaurada do aparelho, se existir.
    final atual = await _auth.authStateChanges().first;
    if (atual != null) return atual;

    final credencial = await _auth.signInAnonymously();
    return credencial.user!;
  }
}
