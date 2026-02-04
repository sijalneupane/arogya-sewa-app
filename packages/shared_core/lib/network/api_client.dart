import 'package:dio/dio.dart';
import 'package:shared_core/network/interceptors/secure_pref_interceptors.dart';
import 'package:shared_core/network/network_info.dart';
import 'package:shared_core/storage/secure_storage.dart';

class ApiClient {
  final Dio dio;

  ApiClient({
    required NetworkInfo networkInfo,
    required SecurePref securePref,
  }) : dio = Dio() {
    dio
      ..options = BaseOptions(
        baseUrl: 'https://70e0887a0be8.ngrok-free.app/api/v1',
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        validateStatus: (_) => true, // Let ApiHandler decide success/failure
      )
      ..interceptors.add(SecureApiInterceptor(
        securePref: securePref,
        networkInfo: networkInfo,
      ));
  }
}