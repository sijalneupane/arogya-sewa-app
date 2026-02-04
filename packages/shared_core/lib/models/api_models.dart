import 'package:meta/meta.dart';

@immutable
sealed class ApiResult<T> {
  final T? data;
  final String? errorMessage;
  final int? statusCode;

  const ApiResult._({
    this.data,
    this.errorMessage,
    this.statusCode,
  });

  factory ApiResult.success(T data, {int? statusCode}) = ApiSuccess<T>;
  factory ApiResult.failure(String errorMessage, {int? statusCode}) = ApiFailure<T>;
}

final class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(T data, {int? statusCode}) : super._(data: data, statusCode: statusCode);
}

final class ApiFailure<T> extends ApiResult<T> {
  const ApiFailure(String errorMessage, {int? statusCode})
      : super._(errorMessage: errorMessage, statusCode: statusCode);
}