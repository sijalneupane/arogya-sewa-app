import 'package:shared_core/constants/arogya_sewa_api_const.dart';
import 'package:shared_core/constants/arogya_sewa_string_const.dart';
import 'package:shared_core/error/datasource_exception_handler.dart';
import 'package:shared_core/network/api_client.dart';
import 'package:shared_feature/auth/data/datasources/auth_remote_datasource.dart';

import '../models/login_model.dart';
import '../models/auth_session_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  AuthRemoteDataSourceImpl({required this.apiClient});
  
  @override
  Future<AuthSessionModel> login(LoginModel payload) async {
    try {
      final response = await apiClient.dio.post(ArogyaSewaApiConst.loginUrl, data: payload.toJson());

      // If we reach here, response is successful (2xx due to validateStatus config)
      if(response.statusCode == 200 || response.statusCode == 201) {
      if (response.data is Map<String, dynamic>) {
        return AuthSessionModel.fromJson(response.data["data"] as Map<String, dynamic>);
      }
      }
      throw returnKnownDioException(response, unexpectedResponseFormatString);
    } catch (e) {
      throw handleDataSourceDioException(e, path: ArogyaSewaApiConst.loginUrl);
    }
  }
  
  // @override
  // Future<void> passwordResetOtp(String email) async {
  //  try {
  //     final response = await dio.post(ArogyaSewaApiConst.passwordResetOtp, data: {'email': email});
      
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return; // Success - return void
  //     }
  //     throw returnKnownDioException(response, otpRequestFailedString);
  //   } catch (e) {
  //     throw handleDataSourceDioException(e, path: ApiConst.passwordResetOtp);
  //   }
  // }
  
  // @override
  // Future<void> verifyOtp(OtpVerificationModel payload) async {
  //   try {
  //     final response = await dio.post(ApiConst.verifyOtp, data: payload.toJson());
      
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return; // Success - return void
  //     }

  //     throw returnKnownDioException(response, otpVerificationFailedString);
  //   } catch (e) {
  //     throw handleDataSourceDioException(e, path: ApiConst.verifyOtp);
  //   }
  // }

  // @override
  // Future<void> setNewPassword(SetNewPasswordModel payload) async {
  //   try {
  //     final response = await dio.patch(ApiConst.changePassword, data: payload.toJson());
      
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return; // Success - return void
  //     }
      
  //     throw returnKnownDioException(response, passwordResetFailedString);
  //   } catch (e) {
  //     throw handleDataSourceDioException(e, path: ApiConst.changePassword);
  //   }
  // }
}


