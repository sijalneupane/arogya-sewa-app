import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_core/constants/arogya_sewa_string_const.dart';
import 'package:shared_core/error/failure.dart';
import 'package:shared_core/error/repository_exception_handler.dart';
import 'package:shared_core/network/network_info.dart';
import 'package:shared_core/services/firebase_notification_service.dart';
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
  final FirebaseNotificationService firebaseNotificationService;
  AuthRepositoryImpl({
    required this.remote,
    required this.securePref,
    required this.networkInfo,
    required this.firebaseNotificationService,
  });
  
  
  @override
  Future<Either<Failure, AuthSessionEntity>> login(LoginEntity payload) async {
    final online = await networkInfo.isConnected;
    if (!online) return left(NetworkFailure(noInternetConnectionString));
    try {
      final deviceFcmToken = await _resolveLoginFcmToken(payload.fcmToken);
      final model = LoginModel(
        email: payload.email,
        password: payload.password,
        fcmToken: deviceFcmToken,
      );
      final session = await remote.login(model);
      await securePref.saveData(accessTokenKey, session.accessToken);
      await securePref.saveData(refreshTokenKey, session.refreshToken);
      // Save remember me preference
      await securePref.saveData(rememberMeKey, payload.rememberMe.toString());
      return right(session);
    } on DioException catch (e) {
      return handleRepositoryException(
        e,
        unknownError: loginFailedStr,
        statusMessage: {401: invalidCredentialsString},
      );
    }
  }

  Future<String> _resolveLoginFcmToken(String fallbackToken) async {
    try {
      final token = await firebaseNotificationService.getDeviceToken();
      if (token != null && token.trim().isNotEmpty) {
        return token.trim();
      }
    } catch (_) {
      // Keep login functional even if FCM token retrieval fails.
    }

    final trimmedFallback = fallbackToken.trim();
    if (trimmedFallback.isEmpty || trimmedFallback.toLowerCase() == 'abc') {
      return '';
    }
    return trimmedFallback;
  }
  
}
