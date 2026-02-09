import 'package:dartz/dartz.dart';
import 'package:shared_core/domain/entities/user_entity.dart';
import 'package:shared_core/error/failure.dart';

abstract class UserDetailsRepository {
  Future<Either<Failure, UserEntity>> getLoggedInUserDetails();
  Future<Either<Failure, void>> clearUserDetails();
}