import 'package:shared_core/auth/models/auth_session_model.dart';
import 'package:shared_core/auth/models/login_model.dart';
import 'package:shared_core/models/api_models.dart';
abstract class AuthService {
  Future<ApiResult<AuthSessionModel>> login(LoginModel payload) ;
  Future<void> saveToken(String token);
}