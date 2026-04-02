import 'package:equatable/equatable.dart';
import 'package:shared_core/domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// App is checking persisted session on startup.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Checking persisted token / validating session.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// A valid session exists — user is logged in.
class AuthAuthenticated extends AuthState {
  final UserEntity userData;
  const AuthAuthenticated({required this.userData});

  @override
  List<Object?> get props => [userData];
}

/// No valid session — user must log in.
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}
