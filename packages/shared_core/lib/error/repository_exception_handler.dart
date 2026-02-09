import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_core/constants/arogya_sewa_string_const.dart';
import 'package:shared_core/error/failure.dart';

// Helper function for extracting error messages
String getErrorMessage(dynamic data, String defaultMessage) {
  if (data is Map<String, dynamic> && data.containsKey("message")) {
    final message = data["message"];
    if (message is List) {
      return message.join(", ");
    }
    if (message is String && message.isNotEmpty) {
      return message;
    }
  }
  return defaultMessage;
}

// ignore: unintended_html_in_doc_comment
/// A generic handler for DioExceptions, returning an Either<Failure, T>.
///
/// This function centralizes error handling for DioExceptions from repositories. It maps common
/// HTTP status codes to specific ServerFailure instances, providing
/// a cleaner way to manage error responses.
///
/// [e] The DioException to handle.
/// [statusMessage] An optional map to override default messages for
/// specific status codes.
/// [unknownError] An optional custom message for unknown errors.
Either<Failure, T> handleRepositoryException<T>(
  DioException e, {
  Map<int, String>? statusMessage,
  String unknownError = unknownErrorString,
}) {
  final statusCode = e.response?.statusCode;
  final responseData = e.response?.data;
  final message = e.message;

  // Define a map of default error strings for specific status codes.
  final defaultMessages = {
    0: unknownErrorString,
    400: badRequestString,
    401: notAuthenticatedString,
    403: forbiddenString,
    404: notFoundString,
    500: internalServerErrorString,
    502: badGatewayString,
    503: serviceUnavailableString,
    504: gatewayTimeoutString,
  };

  // Get the default message, checking for a status-specific override.
  final defaultMessage =
      statusMessage?[statusCode] ?? defaultMessages[statusCode];

  if (defaultMessage != null) {
    final errorMessage = getErrorMessage(responseData, defaultMessage);
    return left(ServerFailure(message ?? errorMessage));
  }

  // Return an UnknownFailure for unhandled status codes.
  return left(UnknownFailure('$unknownError'));
}
