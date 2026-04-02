
import 'package:dartz/dartz.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/usecase/usecase.dart';
import 'package:shared_feature/splash/domain/repositories/splash_repository.dart';

class FetchRememberMeUseCase implements UseCase<bool, NoParams> {
  final SplashRepository repo;
  FetchRememberMeUseCase(this.repo);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repo.isRememberMe();
  }
}
