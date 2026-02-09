import 'package:shared_feature/auth/data/models/auth_session_model.dart';
import 'package:shared_feature/auth/data/models/login_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthSessionModel> login(LoginModel payload);
  // Future<void> passwordResetOtp(String email);
  // Future<void> verifyOtp(OtpVerificationModel payload);
  // Future<void> setNewPassword(SetNewPasswordModel payload);
}
