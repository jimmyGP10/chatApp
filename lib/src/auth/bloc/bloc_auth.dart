import 'package:chat_app/src/auth/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class AuthBloc implements Bloc {
  final _authRepository = AuthRepository();

  final _loadingSubject = BehaviorSubject<bool>();
  Stream<bool> get loadingStream => _loadingSubject.stream;
  void setIsLoading(bool loading) => _loadingSubject.add(loading);

  final _userFields = BehaviorSubject<Map<String, dynamic>>();
  Stream<Map<String, dynamic>> get getUserFields => _userFields.stream;
  Map<String, dynamic> get userFormFields => _userFields.value;
  setUserFormFields(Map<String, dynamic> userFormFields) {
    _userFields.add(userFormFields);
  }

  Future<AuthResult> signInWithEmailAndPassword(String email, String password) {
    return _authRepository.signInWithEmailAndPassword(email, password);
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _authRepository.sendPasswordResetEmail(email);
  }

  Future<AuthResult> createUserWithEmailAndPassword(
      String email, String password) {
    return _authRepository.createUserWithEmailAndPassword(email, password);
  }

  Future<void> signOut() {
    return _authRepository.signOut();
  }

  @override
  void dispose() {
    _userFields.close();
    _loadingSubject.close();
    // TODO: implement dispose
  }
}

final authBloc = AuthBloc();
