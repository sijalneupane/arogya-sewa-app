import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  final bool isLoading;
  final String? error;

  const AuthState({this.isLoading = false, this.error});

  @override
  List<Object?> get props => [isLoading, error];
}

class AuthInitial extends AuthState {
  final bool obscure;
  const AuthInitial({this.obscure = true});
  
  @override
  List<Object?> get props => [obscure, ...super.props];
}

class AuthLoading extends AuthState {
  const AuthLoading() : super(isLoading: true);
}

class Authenticated extends AuthState {
  const Authenticated();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  const AuthError(String error) : super(error: error);
}