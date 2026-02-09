import 'package:shared_feature/auth/domain/entity/login_entity.dart';

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
  
  factory LoginModel.fromEntity(LoginEntity entity) {
    return LoginModel(
      email: entity.email,
      password: entity.password,
      fcmToken: entity.fcmToken,
    );
  }
}