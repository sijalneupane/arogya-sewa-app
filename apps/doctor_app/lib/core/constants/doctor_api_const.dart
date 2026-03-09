class DoctorApiConst {
  static const String baseUrl = 'https://fc11-2400-1a00-3b80-83cc-397f-1d76-47ec-b555.ngrok-free.app/api/v1';
  static const String login = '$baseUrl/auth/login';
  static const String biometricRegister='$baseUrl/auth/biometrics/register';
  static const String biometricAuthenticate='$baseUrl/auth/biometrics/login';
  static const String biometricRevoke='$baseUrl/auth/biometrics/revoke';
}
