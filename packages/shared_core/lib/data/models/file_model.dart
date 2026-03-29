import 'package:shared_core/domain/entities/file_entity.dart';

class FileModel extends FileEntity {
  FileModel({
    required super.fileId,
    required super.fileUrl,
    super.publicId,
    super.type,
    required super.metaType,
    super.createdAt,
    super.updatedAt,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic raw) {
      if (raw is String && raw.isNotEmpty) {
        return DateTime.tryParse(raw);
      }
      return null;
    }

    return FileModel(
      fileId: (json['file_id'] ?? json['fileId'] ?? '') as String,
      fileUrl: (json['file_url'] ?? json['fileUrl'] ?? '') as String,
      publicId: json['public_id'] as String? ?? json['publicId'] as String?,
      type: json['file_type'] as String? ?? json['type'] as String?,
      metaType: (json['meta_type'] ?? json['metaType'] ?? '') as String,
      createdAt: parseDate(json['created_at'] ?? json['createdAt']),
      updatedAt: parseDate(json['updated_at'] ?? json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'file_id': fileId,
      'file_url': fileUrl,
      'public_id': publicId,
      'file_type': type,
      'meta_type': metaType,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory FileModel.fromEntity(FileEntity entity) {
    return FileModel(
      fileId: entity.fileId,
      fileUrl: entity.fileUrl,
      publicId: entity.publicId,
      type: entity.type,
      metaType: entity.metaType,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}