import 'package:dio/dio.dart';
import 'package:shared_core/domain/entities/file_upload_entity.dart';
import 'package:shared_core/enum/file_type_enum.dart';

class FileUploadModel extends FileUploadEntity {
  FileUploadModel({required super.file, required super.filetype});
  factory FileUploadModel.fromEntity(FileUploadEntity entity) {
    return FileUploadModel(file: entity.file, filetype: entity.filetype);
  }
  FormData toFormData() {
    return FormData.fromMap({
      'file': MultipartFile.fromFileSync(
        file.path,
        filename: file.path.split('/').last,
      ),
      'type': filetype.value,
    });
  }
}
