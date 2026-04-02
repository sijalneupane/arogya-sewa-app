class LoginEntity {
  final String email;
  final String password;
  final String fcmToken;
  final bool rememberMe;

  const LoginEntity({
    required this.email,
    required this.password,
    required this.fcmToken,
    this.rememberMe = false,
  });
}
