import 'package:shared_core/domain/entities/file_entity.dart';

class FileModel extends FileEntity {
  FileModel({
    required super.fileId,
    required super.fileUrl,
    required super.publicId,
    required super.type,
    required super.metaType,
    required super.createdAt,
    required super.updatedAt,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      fileId: json['file_id'],
      fileUrl: json['fileUrl'],
      publicId: json['publicId'],
      type: json['type'],
      metaType: json['metaType'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'file_id': fileId,
      'fileUrl': fileUrl,
      'publicId': publicId,
      'type': type,
      'metaType': metaType,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}