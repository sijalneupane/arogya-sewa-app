import 'package:dartz/dartz.dart';
import 'package:shared_core/domain/entities/file_entity.dart';
import 'package:shared_core/domain/entities/file_update_entity.dart';
import 'package:shared_core/domain/entities/file_upload_entity.dart';
import 'package:shared_core/error/failure.dart';

abstract class FileRepository {
  Future<Either<Failure, FileEntity>> updateFile(FileUpdateEntity payload);
  Future<Either<Failure, FileEntity>> uploadFile(FileUploadEntity payload);
}
