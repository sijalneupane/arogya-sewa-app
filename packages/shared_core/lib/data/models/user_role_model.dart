import 'package:shared_core/domain/entities/user_role_entity.dart';

class UserRoleModel extends UserRoleEntity {
  UserRoleModel({
    required super.role,
    required super.description,
  });

  factory UserRoleModel.fromJson(Map<String, dynamic> json) {
    return UserRoleModel(
      role: json['role'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'description': description,
    };
  }
}
