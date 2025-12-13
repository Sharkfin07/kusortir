import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kusortir/data/firebase/auth_helper.dart' as auth_helper;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<PasswordResetRequested>(_onPasswordResetRequested);
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = auth_helper.currentUser();
    if (user != null) {
      emit(AuthAuthenticated(email: user.email ?? ''));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final cred = await auth_helper.signInWithEmail(
        event.email,
        event.password,
      );
      emit(AuthAuthenticated(email: cred.user?.email ?? event.email));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(message: _mapFirebaseError(e)));
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final cred = await auth_helper.signUpWithEmail(
        event.email,
        event.password,
      );
      emit(AuthAuthenticated(email: cred.user?.email ?? event.email));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(message: _mapFirebaseError(e)));
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await auth_helper.signOut();
    emit(AuthUnauthenticated());
  }

  Future<void> _onPasswordResetRequested(
    PasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await auth_helper.sendPasswordReset(event.email);
      emit(AuthUnauthenticated());
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(message: _mapFirebaseError(e)));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'Email already in use.';
      case 'weak-password':
        return 'Password too weak.';
      case 'invalid-email':
        return 'Email is invalid.';
      default:
        return e.message ?? 'Authentication error';
    }
  }
}
