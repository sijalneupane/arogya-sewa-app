class LoginModel {
  String email;
  String password;
  String fcmToken;
  LoginModel({
    required this.email,
    required this.password,
    required this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'fcm_token': fcmToken,
    };
  }
  
}