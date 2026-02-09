import 'package:dio/dio.dart';
import 'package:shared_core/constants/arogya_sewa_string_const.dart';

/// Handles API response validation for void methods
/// Throws DioException if the response status is not successful
DioException returnKnownDioException(Response response, String errorMessage) {
  /* Check for HTML content type which indicates a server error page 
  and return a generic server error message
  As dio does not automatically handle this based on status code on some case
  */
  final contentType = response.headers.value('content-type');
  if (contentType!.contains('text/html')) {
    return DioException(
      requestOptions: RequestOptions(path: response.requestOptions.path),
      response: Response(
        data: {'message': serverErrorString},
        requestOptions: RequestOptions(path: response.requestOptions.path),
        statusCode: 502,
      ),
      type: DioExceptionType.unknown,
      error: '$unknownErrorString:$serverErrorString',
    );
  }
  return DioException(
    requestOptions: response.requestOptions,
    response: response,
    type: DioExceptionType.badResponse,
    error: errorMessage,
    message: response.data is Map<String, dynamic>
        ? response.data is List
            ?( response.data["message"]?.join(", ") ?? errorMessage)
            : (response.data['message'] ?? errorMessage)
        : errorMessage,
  );
}

/// Handles unknown exceptions by converting them to DioException
/// If the exception is already a DioException, it re-throws it
/// Otherwise, it wraps the exception in a DioException with unknown type
DioException handleDataSourceDioException(dynamic e, {String? path}) {
  if (e is DioException) {
    return e;
  }
  return DioException(
    requestOptions: RequestOptions(path: path ?? ''),
    response: Response(
      data: {'message': e.toString()},
      requestOptions: RequestOptions(path: path ?? ''),
      statusCode: 0,
    ),
    type: DioExceptionType.unknown,
    error: '$unknownErrorString: ${e.toString()}',
  );
}
