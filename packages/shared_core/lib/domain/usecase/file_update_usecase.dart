import 'package:dartz/dartz.dart';
import 'package:shared_core/domain/entities/file_update_entity.dart';
import 'package:shared_core/domain/entities/file_entity.dart';
import 'package:shared_core/domain/repository/file_repository.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/usecase/usecase.dart';

class FileUpdateUsecase extends UseCase<FileEntity, FileUpdateEntity> {
  final FileRepository repo;
  FileUpdateUsecase(this.repo);
  @override
  Future<Either<Failure, FileEntity>> call(FileUpdateEntity params) async {
    return await repo.updateFile(params);
  }
}
