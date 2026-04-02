import 'package:equatable/equatable.dart';
import 'package:shared_feature/auth/domain/entity/login_entity.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when user submits login form.
class LoginSubmitted extends LoginEvent {
  final LoginEntity loginEntity;
  const LoginSubmitted(this.loginEntity);

  @override
  List<Object?> get props => [loginEntity];
}

/// Fired when user toggles password visibility.
class LoginPasswordToggled extends LoginEvent {
  final bool obscure;
  const LoginPasswordToggled(this.obscure);

  @override
  List<Object?> get props => [obscure];
}
