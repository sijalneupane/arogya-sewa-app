import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_core/constants/arogya_sewa_string_const.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/error/repository_exception_handler.dart';
import 'package:shared_core/network/network_info.dart';
import 'package:shared_feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:shared_feature/auth/data/models/login_model.dart';
import 'package:shared_feature/auth/domain/entity/auth_session_entity.dart';
import 'package:shared_feature/auth/domain/entity/login_entity.dart';
import 'package:shared_feature/auth/domain/repository/auth_repository.dart';
import 'package:shared_core/storage/secure_storage.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource remote;
  final SecurePref securePref;
  final NetworkInfo networkInfo;
  AuthRepositoryImpl({required this.remote, required this.securePref, required this.networkInfo});
  
  
  @override
  Future<Either<Failure, AuthSessionEntity>> login(LoginEntity payload) async {
    final online = await networkInfo.isConnected;
    if (!online) return left(NetworkFailure(noInternetConnectionString));
    try {
      final model = LoginModel.fromEntity(payload);
      final session = await remote.login(model);
      await securePref.saveData(accessTokenKey, session.accessToken);
      await securePref.saveData(refreshTokenKey, session.refreshToken);
      return right(session);
    } on DioException catch (e) {
      return handleRepositoryException(
        e,
        unknownError: loginFailedStr,
        statusMessage: {401: invalidCredentialsString},
      );
    }
  }
  
}
