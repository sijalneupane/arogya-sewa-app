import 'package:shared_feature/auth/domain/entity/login_entity.dart';

abstract class AuthEvent {}

class AuthLoginInitiated extends AuthEvent {
  final LoginEntity loginEntity;
  AuthLoginInitiated(this.loginEntity);
}
class AuthPasswordToggled extends AuthEvent {
  final bool obscure;
  AuthPasswordToggled({required this.obscure});
}
class AuthLogoutRequested extends AuthEvent {}