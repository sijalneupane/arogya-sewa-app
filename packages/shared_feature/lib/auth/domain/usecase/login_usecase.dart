import 'package:dartz/dartz.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/usecase/usecase.dart';
import 'package:shared_feature/auth/domain/entity/auth_session_entity.dart';
import 'package:shared_feature/auth/domain/entity/login_entity.dart';
import 'package:shared_feature/auth/domain/repository/auth_repository.dart';

class LoginUsecase implements UseCase<AuthSessionEntity, LoginEntity> {
  
  final AuthRepository repo;
  LoginUsecase(this.repo);

  @override
  Future<Either<Failure, AuthSessionEntity>> call(LoginEntity p) async {
    return await repo.login(p);
  }
}
