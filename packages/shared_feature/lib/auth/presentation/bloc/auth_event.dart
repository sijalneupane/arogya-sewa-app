import 'package:shared_feature/auth/data/models/login_model.dart';

abstract class AuthEvent {}

class AuthLoginInitiated extends AuthEvent {
  final LoginModel loginModel;
  AuthLoginInitiated(this.loginModel);
}
class AuthPasswordToggled extends AuthEvent {
  final bool obscure;
  AuthPasswordToggled({required this.obscure});
}
class AuthLogoutRequested extends AuthEvent {}