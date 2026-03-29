import 'package:shared_core/data/models/file_model.dart';
import 'package:shared_core/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.name,
    required super.email,
    required super.id,
    required super.phoneNumber,
    super.profileImage,
  });

  // Map<String, dynamic> toJson() {
  //   return {
  //     'name': name,
  //     'email': email,
  //     'id': id,
  //     'phoneNumber': phoneNumber,
  //     'profileImage': profileImage,
  //   };
  // }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      id: json['id'],
      phoneNumber: json['phone_number'],
      profileImage: json['profile_img'] != null
          ? FileModel.fromJson(json['profile_img'])
          : null,
    );
  }
}
