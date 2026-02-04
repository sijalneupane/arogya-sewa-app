import 'package:dio/dio.dart';
import 'package:shared_core/network/network_info.dart';
import 'package:shared_core/storage/secure_storage.dart';

const String accessTokenKey = 'access_token';

class SecureApiInterceptor extends Interceptor {
  final SecurePref _securePref;
  final NetworkInfo _networkInfo;

  SecureApiInterceptor({
    required SecurePref securePref,
    required NetworkInfo networkInfo,
  })  : _securePref = securePref,
        _networkInfo = networkInfo;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // ✅ 1. Check connectivity
    final hasConnection = await _networkInfo.isConnected;
    if (!hasConnection) {
      return handler.reject(
        DioException(
          error: 'No internet connection',
          requestOptions: options,
          type: DioExceptionType.connectionError,
        ),
      );
    }

    // ✅ 2. Add auth token if exists
    final token = await _securePref.readString(accessTokenKey);
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // ✅ 3. Ensure JSON
    options.headers['Accept'] = 'application/json';

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Let ApiHandler parse errors — don’t handle here
    handler.next(err);
  }
}