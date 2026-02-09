import 'package:shared_core/domain/entities/mini_user_entity.dart';

class MiniUserModel extends MiniUserEntity {
  MiniUserModel({required super.id});
  factory MiniUserModel.fromJson(Map<String, dynamic> json) =>
      MiniUserModel(id: json['id'] as String);
}
