import 'package:shared_core/data/models/file_model.dart';
import 'package:shared_core/data/models/user_role_model.dart';
import 'package:shared_core/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.phoneNumber,
    required super.role,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
    super.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      role: UserRoleModel.fromJson(json['role']),
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      profileImage: json['profile_img'] != null
          ? FileModel.fromJson(json['profile_img'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone_number': phoneNumber,
      'role': (role as UserRoleModel).toJson(),
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'profile_img': profileImage != null ? (profileImage as FileModel).toJson() : null,
    };
  }
}
