part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthAuthenticated extends AuthState {
  AuthAuthenticated({required this.email});
  final String email;
}

final class AuthUnauthenticated extends AuthState {}

final class AuthFailure extends AuthState {
  AuthFailure({required this.message});
  final String message;
}
