import 'dart:async';
import 'package:dio/dio.dart';
import 'package:shared_core/constants/arogya_sewa_api_const.dart';
import 'package:shared_core/storage/secure_storage.dart';

class ApiClient {
  final Dio dio;
  final SecurePref securePref;
  bool isRefreshing = false;
  List<Function(String)> requestQueue = [];

  ApiClient({required this.dio, required this.securePref}) {
    dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: {'Accept': 'application/json'},
      validateStatus: (status) => true,
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await securePref.readString(accessTokenKey);
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },

        onResponse: (response, handler) => handler.next(response),

        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshToken = await securePref.readString(refreshTokenKey);
            if (refreshToken.isEmpty) {
              return handler.next(error);
            }
            if (isRefreshing) {
              final completer = Completer<Response>();
              requestQueue.add((newToken) async {
                error.requestOptions.headers['Authorization'] =
                    'Bearer $newToken';
                final response = await dio.request(
                  error.requestOptions.path,
                  data: error.requestOptions.data,
                  queryParameters: error.requestOptions.queryParameters,
                  options: Options(method: error.requestOptions.method),
                );
                completer.complete(response);
              });
              return handler.resolve(await completer.future);
            }
            isRefreshing = true;

            try {
              final newAccessToken = await _refreshAccessToken(refreshToken);

              for (var callback in requestQueue) {
                await callback(newAccessToken);
              }
              requestQueue.clear();

              error.requestOptions.headers['Authorization'] =
                  'Bearer $newAccessToken';

              final retryResponse = await dio.request(
                error.requestOptions.path,
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
                options: Options(method: error.requestOptions.method),
              );

              return handler.resolve(retryResponse);
            } catch (e) {
              await securePref.clearData();
              return handler.next(error);
            } finally {
              isRefreshing = false;
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  Future<String> _refreshAccessToken(String refreshToken) async {
    final response = await dio.post(
      ArogyaSewaApiConst.refreshTokenUrl,
      data: {'refreshToken': refreshToken},
    );

    if (response.statusCode == 200) {
      final newAccess = response.data['access_token'];
      final newRefresh = response.data['refresh_token'];

      await securePref.saveData(accessTokenKey, newAccess);
      if (newRefresh != null) {
        await securePref.saveData(refreshTokenKey, newRefresh);
      }

      return newAccess;
    }

    throw Exception("failedToRefreshTokenString");
  }
}
