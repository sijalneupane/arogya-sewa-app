import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_core/constants/arogya_sewa_string_const.dart';
import 'package:shared_core/data/datasources/file_remote_datasource.dart';
import 'package:shared_core/data/models/file_model.dart';
import 'package:shared_core/data/models/file_update_model.dart';
import 'package:shared_core/data/models/file_upload_model.dart';
import 'package:shared_core/domain/entities/file_entity.dart';
import 'package:shared_core/domain/entities/file_update_entity.dart';
import 'package:shared_core/domain/entities/file_upload_entity.dart';
import 'package:shared_core/domain/repository/file_repository.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/error/repository_exception_handler.dart';
import 'package:shared_core/network/network_info.dart';

class FileRepositoryImpl implements FileRepository {
  final FileRemoteDataSource remote;
  final NetworkInfo networkInfo;

  FileRepositoryImpl({required this.remote, required this.networkInfo});

  @override
  Future<Either<Failure, FileEntity>> updateFile(
    FileUpdateEntity payload,
  ) async {
    final online = await networkInfo.isConnected;
    if (!online) return left(NetworkFailure(noInternetConnectionString));
    final validFileSize = await this.validateFileSize(
      payload.file,
      2 * 1024 * 1024,
    );
    if (!validFileSize) return left(UnknownFailure(fileSizeExceedString));
    try {
      final model = FileUpdateModel.fromEntity(payload);
      final fileId = await remote.updateFile(model);
      return right(fileId);
    } on DioException catch (e) {
      return handleRepositoryException(e, unknownError: fileUpdateFailedString);
    }
  }

  @override
  Future<Either<Failure, FileModel>> uploadFile(
    FileUploadEntity payload,
  ) async {
    final online = await networkInfo.isConnected;
    if (!online) return left(NetworkFailure(noInternetConnectionString));
    final validFileSize = await this.validateFileSize(
      payload.file,
      2 * 1024 * 1024,
    );
    if (!validFileSize) return left(UnknownFailure(fileSizeExceedString));
    try {
      final model = FileUploadModel.fromEntity(payload);
      final file = await remote.uploadFile(model);
      return right(file);
    } on DioException catch (e) {
      return handleRepositoryException(e, unknownError: fileUploadFailedString);
    }
  }

  Future<bool> validateFileSize(File file, int maxSizeInBytes) async {
    int fileSize = await file.length();
    return fileSize <= maxSizeInBytes;
  }
}
