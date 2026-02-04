import 'package:dio/dio.dart';
import 'package:shared_core/models/api_models.dart';

class ApiHandler {
  static Future<ApiResult<T>> handle<T>(
    Future<Response<T>> Function() apiCall,
  ) async {
    try {
      final response = await apiCall();

      // Treat 2xx as success
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        return ApiResult.success(response.data!, statusCode: response.statusCode);
      } else {
        final message = _extractErrorMessage(response.data) ??
            _mapStatusCodeToMessage(response.statusCode) ??
            'Request failed';
        return ApiResult.failure(message, statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        return ApiResult.failure('No internet connection');
      } else if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return ApiResult.failure('Request timed out');
      } else if (e.response != null) {
        final status = e.response!.statusCode;
        final message = _extractErrorMessage(e.response?.data) ??
            _mapStatusCodeToMessage(status) ??
            'Something went wrong';
        return ApiResult.failure(message, statusCode: status);
      } else {
        return ApiResult.failure('Network error. Please check your connection.');
      }
    } catch (e) {
      return ApiResult.failure('Unexpected error: ${e.toString()}');
    }
  }

  static String? _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['error'] ?? data['message'] ?? data['detail'] ?? data['msg'];
    }
    return null;
  }

  static String? _mapStatusCodeToMessage(int? code) {
    switch (code) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Session expired. Please log in again.';
      case 403:
        return 'Access denied';
      case 404:
        return 'Not found';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return null;
    }
  }
}