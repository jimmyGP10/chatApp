import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthAPI {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<AuthResult> signInWithEmailAndPassword(email, password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<AuthResult> createUserWithEmailAndPassword(
      String email, String password) {
    return _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    final res = await _auth.signOut();
    return res;
  }
}
