import 'package:dartz/dartz.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_feature/auth/domain/entity/auth_session_entity.dart';

abstract class UserDetailsRepository {
  Future<Either<Failure, AuthSessionEntity>> getLoggedInUserDetails();
  // Future<Either<Failure, void>> updateUserProfile(EditProfileEntity payload);
  // Future<Either<Failure, void>> clearUserDetails();
}
