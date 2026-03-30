import 'package:shared_core/domain/entities/file_entity.dart';
import 'package:shared_core/domain/entities/user_role_entity.dart';

class UserEntity {
  final String id;
  final String email;
  final String name;
  final String phoneNumber;
  final UserRoleEntity role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final FileEntity? profileImage;

  UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.profileImage,
  });
}
