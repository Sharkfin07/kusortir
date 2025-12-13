part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

/// Triggered on app start or when we need to refresh the session state.
final class AuthCheckRequested extends AuthEvent {}

/// User requests sign-in with email/password.
final class SignInRequested extends AuthEvent {
  SignInRequested({required this.email, required this.password});
  final String email;
  final String password;
}

/// User requests sign-up with email/password.
final class SignUpRequested extends AuthEvent {
  SignUpRequested({required this.email, required this.password});
  final String email;
  final String password;
}

/// User taps logout.
final class SignOutRequested extends AuthEvent {}

/// User requests password reset email.
final class PasswordResetRequested extends AuthEvent {
  PasswordResetRequested({required this.email});
  final String email;
}
