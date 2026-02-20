import 'package:equatable/equatable.dart';
import '../../domain/entities/app_user.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String displayName;

  const SignUpRequested({required this.email, required this.password, required this.displayName});

  @override
  List<Object?> get props => [email, password, displayName];
}

class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthStateChanged extends AuthEvent {
  final AppUser? user;

  const AuthStateChanged(this.user);

  @override
  List<Object?> get props => [user];
}
