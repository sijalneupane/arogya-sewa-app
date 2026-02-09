import 'package:shared_core/data/models/user_model.dart';
import 'package:shared_feature/auth/domain/entity/auth_session_entity.dart';

class AuthSessionModel extends AuthSessionEntity {
  AuthSessionModel({
    required super.user,
    required super.accessToken,
    required super.refreshToken,
  });
  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      user: UserModel.fromJson(json['user']),
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}
