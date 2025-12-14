part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSignedUp extends AuthState {
  final String email;
  AuthSignedUp({required this.email});
}

final class AuthSignedOut extends AuthState {}

final class AuthFail extends AuthState {
  final String message;
  AuthFail({required this.message});
}
