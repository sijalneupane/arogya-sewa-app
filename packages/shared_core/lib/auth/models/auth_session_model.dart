import 'package:shared_core/models/user_model.dart';

class AuthSessionModel {
  UserModel userModel;
  String accessToken;
  String refreshToken;
  AuthSessionModel({
    required this.userModel,
    required this.accessToken,
    required this.refreshToken,
  });
  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      userModel: UserModel.fromJson(json['user']),
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}
