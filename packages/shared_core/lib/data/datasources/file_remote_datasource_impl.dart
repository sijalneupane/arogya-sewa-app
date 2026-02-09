import 'package:shared_core/constants/arogya_sewa_api_const.dart';
import 'package:shared_core/constants/arogya_sewa_string_const.dart';
import 'package:shared_core/data/datasources/file_remote_datasource.dart';
import 'package:shared_core/data/models/file_update_model.dart';
import 'package:shared_core/data/models/file_upload_model.dart';
import 'package:shared_core/data/models/file_model.dart';
import 'package:shared_core/error/datasource_exception_handler.dart';
import 'package:shared_core/network/api_client.dart';

class FileRemoteDataSourceImpl implements FileRemoteDataSource {
  final ApiClient apiClient;
  FileRemoteDataSourceImpl({required this.apiClient});
  @override
  Future<FileModel> updateFile(FileUpdateModel model) async {
    try {
      final formData = model.toFormData();
      final response = await apiClient.dio.patch(
        ArogyaSewaApiConst.fileUpdateUrl,
        data: formData,
        queryParameters: {'image_id': model.fileId},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = FileModel.fromJson(response.data);
        return data;
      }
      throw returnKnownDioException(response, fileUpdateFailedString);
    } catch (e) {
      throw handleDataSourceDioException(e, path: ArogyaSewaApiConst.fileUpdateUrl);
    }
  }

  @override
  Future<FileModel> uploadFile(FileUploadModel model) async {
    try {
      final formData = model.toFormData();
      final response = await apiClient.dio.post(
        ArogyaSewaApiConst.fileUploadUrl,
        data: formData,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = FileModel.fromJson(response.data);
        return data;
      }
      throw returnKnownDioException(response, fileUploadFailedString);
    } catch (e) {
      throw handleDataSourceDioException(e, path: ArogyaSewaApiConst.fileUploadUrl);
    }
  }
}
