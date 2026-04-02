import 'package:equatable/equatable.dart';
import 'package:shared_feature/auth/domain/entity/auth_session_entity.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

/// Initial state - form is ready for input.
class LoginInitial extends LoginState {
  final bool obscurePassword;
  const LoginInitial({this.obscurePassword = true});

  @override
  List<Object?> get props => [obscurePassword];
}

/// Login request is in progress.
class LoginLoading extends LoginState {
  const LoginLoading();
}

/// Login successful.
class LoginSuccess extends LoginState {
  final AuthSessionEntity session;
  const LoginSuccess(this.session);
  @override
  List<Object?> get props => [session];
}

/// Login failed with error message.
class LoginFailure extends LoginState {
  final String errorMessage;
  const LoginFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
