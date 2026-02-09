import 'package:dartz/dartz.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/usecase/usecase.dart';
import 'package:shared_feature/splash/domain/repositories/splash_repository.dart';

class FetchAppVersionUsecase implements UseCase<String, NoParams> {
  final SplashRepository repo;
  FetchAppVersionUsecase(this.repo);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await repo.fetchAppVersion();
  }
}
