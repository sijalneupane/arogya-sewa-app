import 'package:dartz/dartz.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_feature/auth/domain/entity/auth_session_entity.dart';
import 'package:shared_feature/auth/domain/entity/login_entity.dart';
abstract class AuthRepository {
  Future<Either<Failure, AuthSessionEntity>> login(LoginEntity payload);
  // Future<void> saveToken(String token);
}