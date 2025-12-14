part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

// Mengecek status pengguna saat open
final class AuthCheck extends AuthEvent {}

final class SignInEvent extends AuthEvent {
  SignInEvent({required this.email, required this.password});
  final String email;
  final String password;
}

final class SignUpEvent extends AuthEvent {
  SignUpEvent({required this.email, required this.password});
  final String email;
  final String password;
}

final class SignOutEvent extends AuthEvent {}

// omaigot
