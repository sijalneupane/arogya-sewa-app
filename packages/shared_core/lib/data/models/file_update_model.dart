import 'package:dio/dio.dart';
import 'package:shared_core/domain/entities/file_update_entity.dart';

class FileUpdateModel extends FileUpdateEntity {
   FileUpdateModel({required super.fileId, required super.file, required super.fileType});
  factory FileUpdateModel.fromEntity(FileUpdateEntity entity) {
     return FileUpdateModel(fileId: entity.fileId, file: entity.file, fileType: entity.fileType);
   }
  FormData toFormData() {
    return FormData.fromMap({
      'file': MultipartFile.fromFileSync(
        file.path,
        filename: file.path.split('/').last,
      ),
      'type': fileType.name,
    });
   }
}