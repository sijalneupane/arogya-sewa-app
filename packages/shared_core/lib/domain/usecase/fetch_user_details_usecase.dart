import 'package:dartz/dartz.dart';
import 'package:shared_core/domain/entities/user_entity.dart';
import 'package:shared_core/domain/repository/user_details_repository.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/usecase/usecase.dart';

class FetchUserDetailsUsecase extends UseCase<UserEntity, NoParams>{
  final UserDetailsRepository repo;
  FetchUserDetailsUsecase(this.repo);
  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return repo.getLoggedInUserDetails();
  }
}