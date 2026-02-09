import 'package:shared_core/domain/entities/user_entity.dart';

class AuthSessionEntity {
  final String accessToken;
  final String refreshToken;
  final UserEntity user;

  const AuthSessionEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });
}
