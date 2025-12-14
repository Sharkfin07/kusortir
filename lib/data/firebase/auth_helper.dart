import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

User? currentUser() => _auth.currentUser;

Future<UserCredential> signInWithEmail(String email, String password) {
  return _auth.signInWithEmailAndPassword(email: email, password: password);
}

Future<UserCredential> signUpWithEmail(String email, String password) {
  return _auth.createUserWithEmailAndPassword(email: email, password: password);
}

Future<void> signOut() => _auth.signOut();

Future<void> sendPasswordReset(String email) =>
    _auth.sendPasswordResetEmail(email: email);
