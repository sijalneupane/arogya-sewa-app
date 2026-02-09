import 'package:shared_core/domain/entities/file_entity.dart';
class UserEntity {
  String name;
  String email;
  String id;
  String phoneNumber;
  FileEntity? profileImage;


   UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.profileImage  
  });
}
