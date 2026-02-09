class LoginEntity {
  final String email;
  final String password;
  final String fcmToken;

  const LoginEntity({
    required this.email,
    required this.password,
    required this.fcmToken,
  });
}
