class FileEntity {
  final String fileId;
  final String fileUrl;
  final String? publicId;
  final String? type;
  final String metaType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FileEntity({
    required this.fileId,
    required this.fileUrl,
    this.publicId,
    this.type,
    required this.metaType,
    this.createdAt,
    this.updatedAt,
  });

  String get fileType => type ?? '';
}
