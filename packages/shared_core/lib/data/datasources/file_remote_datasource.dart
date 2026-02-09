import 'package:shared_core/data/models/file_update_model.dart';
import 'package:shared_core/data/models/file_upload_model.dart';
import 'package:shared_core/data/models/file_model.dart';

abstract class FileRemoteDataSource {
  Future<FileModel> updateFile(FileUpdateModel model);
  Future<FileModel> uploadFile(FileUploadModel model);
}
