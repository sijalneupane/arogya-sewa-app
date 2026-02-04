class FileModel {
  final String fileId;
  final String fileUrl;
  final String publicId;
  final String type;
  final String metaType;
  final DateTime createdAt;
  final DateTime updatedAt;

  FileModel({
    required this.fileId,
    required this.fileUrl,
    required this.publicId,
    required this.type,
    required this.metaType,
    required this.createdAt,
    required this.updatedAt,
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

}
