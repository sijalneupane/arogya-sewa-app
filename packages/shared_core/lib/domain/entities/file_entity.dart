class FileEntity {
  final String fileId;
  final String fileUrl;
  final String publicId;
  final String type;
  final String metaType;
  final DateTime createdAt;
  final DateTime updatedAt;

  FileEntity({
    required this.fileId,
    required this.fileUrl,
    required this.publicId,
    required this.type,
    required this.metaType,
    required this.createdAt,
    required this.updatedAt,
  });
}
