import 'package:chat_app/src/auth/repository/auth_firebase_api.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final _firebaseAuthAPI = FirebaseAuthAPI();

  Future<AuthResult> signInWithEmailAndPassword(
          String email, String password) =>
      _firebaseAuthAPI.signInWithEmailAndPassword(email, password);

  Future<void> sendPasswordResetEmail(String email) =>
      _firebaseAuthAPI.sendPasswordResetEmail(email);

  Future<AuthResult> createUserWithEmailAndPassword(
          String email, String password) =>
      _firebaseAuthAPI.createUserWithEmailAndPassword(email, password);
}
