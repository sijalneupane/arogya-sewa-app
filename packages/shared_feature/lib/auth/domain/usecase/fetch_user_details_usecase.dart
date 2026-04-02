import 'package:dartz/dartz.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_feature/auth/domain/entity/auth_session_entity.dart';
import 'package:shared_feature/auth/domain/repository/user_details_repository.dart';
import 'package:shared_core/usecase/usecase.dart';

/// Fetches the currently logged-in user's details from the server.
class FetchUserDetailsUsecase implements UseCase<AuthSessionEntity, NoParams> {
  final UserDetailsRepository repository;

  FetchUserDetailsUsecase(this.repository);

  @override
  Future<Either<Failure, AuthSessionEntity>> call(NoParams params) async {
    return await repository.getLoggedInUserDetails();
  }
}
