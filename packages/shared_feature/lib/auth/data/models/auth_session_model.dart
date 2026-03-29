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
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }
}
// name: json['name'],
//       email: json['email'],
//       id: json['id'],
//       phoneNumber: json['phoneNumber'],
//       profileImage: json['profileImage'] != null
//           ? FileModel.fromJson(json['profileImage'])
//           : null,
//     );
