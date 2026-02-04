import 'package:dio/dio.dart';
import 'package:shared_core/auth/models/auth_session_model.dart';
import 'package:shared_core/auth/models/login_model.dart';
import 'package:shared_core/auth/services/auth_service.dart';
import 'package:shared_core/models/api_models.dart';
import 'package:shared_core/network/api_client.dart';
import 'package:shared_core/network/handlers/api_handlers.dart';
import 'package:shared_core/storage/secure_storage.dart';

class AuthServiceImpl extends AuthService {
  final ApiClient apiClient;
  final SecurePref securePref;
  AuthServiceImpl({required this.apiClient, required this.securePref});
  @override
  Future<ApiResult<AuthSessionModel>> login(LoginModel payload) async {
    final result = await ApiHandler.handle<AuthSessionModel>(() async {
      final response = await apiClient.dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: payload.toJson(),
      );
      return response;
      // Parse user from response
      // final userJson = response.data!['data'] as Map<String, dynamic>;
      // final user = AuthSessionModel.fromJson(userJson);

      // return Response<AuthSessionModel>(
      //    data:user,
      //   statusCode: response.statusCode,
      //   requestOptions: response.requestOptions,
      // );
    });
    return result is ApiSuccess<AuthSessionModel>
        ? ApiResult.success(result.data!, statusCode: result.statusCode)
        : result;
  }

  @override
  Future<void> saveToken(String token) async {
    await securePref.saveData(accessTokenKey, token);
  }
}
