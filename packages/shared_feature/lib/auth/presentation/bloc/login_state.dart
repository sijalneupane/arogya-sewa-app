import 'package:equatable/equatable.dart';

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
  const LoginSuccess();
}

/// Login failed with error message.
class LoginFailure extends LoginState {
  final String errorMessage;
  const LoginFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
