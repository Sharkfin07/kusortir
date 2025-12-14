import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kusortir/data/firebase/auth_helper.dart' as auth_helper;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthCheck>(_onCheckRequested);
    on<SignInEvent>(_onSignInRequested);
    on<SignUpEvent>(_onSignUpRequested);
    on<SignOutEvent>(_onSignOutRequested);
  }

  Future<void> _onCheckRequested(
    AuthCheck event,
    Emitter<AuthState> emit,
  ) async {
    final user = auth_helper.currentUser();
    if (user != null) {
      emit(AuthSignedUp(email: user.email ?? ''));
    } else {
      emit(AuthSignedOut());
    }
  }

  Future<void> _onSignInRequested(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final cred = await auth_helper.signInWithEmail(
        event.email,
        event.password,
      );
      emit(AuthSignedUp(email: cred.user?.email ?? event.email));
    } on FirebaseAuthException catch (e) {
      emit(AuthFail(message: e.message!));
      emit(AuthSignedOut());
    } catch (e) {
      emit(AuthFail(message: e.toString()));
      emit(AuthSignedOut());
    }
  }

  Future<void> _onSignUpRequested(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final cred = await auth_helper.signUpWithEmail(
        event.email,
        event.password,
      );
      emit(AuthSignedUp(email: cred.user?.email ?? event.email));
    } on FirebaseAuthException catch (e) {
      emit(AuthFail(message: e.message!));
      emit(AuthSignedOut());
    } catch (e) {
      emit(AuthFail(message: e.toString()));
      emit(AuthSignedOut());
    }
  }

  Future<void> _onSignOutRequested(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    await auth_helper.signOut();
    emit(AuthSignedOut());
  }
}
