import 'package:shared_core/models/file_model.dart';

class UserModel {
  String name;
  String email;
  String id;
  String phoneNumber;
  FileModel? profileImage;
  UserModel({
    required this.name,
    required this.email,
    required this.id,
    required this.phoneNumber,
    this.profileImage,
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
      phoneNumber: json['phoneNumber'],
      profileImage: json['profileImage'] != null
          ? FileModel.fromJson(json['profileImage'])
          : null,
    );
  }
}
