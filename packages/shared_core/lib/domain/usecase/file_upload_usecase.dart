import 'package:dartz/dartz.dart';
import 'package:shared_core/domain/entities/file_upload_entity.dart';
import 'package:shared_core/domain/entities/file_entity.dart';
import 'package:shared_core/domain/repository/file_repository.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/usecase/usecase.dart';

class FileUploadUsecase extends UseCase<FileEntity, FileUploadEntity> {
  final FileRepository repo;
  FileUploadUsecase(this.repo);
  @override
  Future<Either<Failure, FileEntity>> call(FileUploadEntity params) async {
    return await repo.uploadFile(params);
  }
}
