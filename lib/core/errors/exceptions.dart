library;

import 'package:dio/dio.dart';
import 'error_model.dart';

//!ServerException
class ServerException implements Exception {
  final ErrorModel errorModel;
  ServerException(this.errorModel);
}

//!CacheException
class CacheException implements Exception {
  final String errorMessage;
  CacheException({required this.errorMessage});
}

class BadCertificateException extends ServerException {
  BadCertificateException(super.errorModel);
}

class ConnectionTimeoutException extends ServerException {
  ConnectionTimeoutException(super.errorModel);
}

class BadResponseException extends ServerException {
  BadResponseException(super.errorModel);
}

class ReceiveTimeoutException extends ServerException {
  ReceiveTimeoutException(super.errorModel);
}

class ConnectionErrorException extends ServerException {
  ConnectionErrorException(super.errorModel);
}

class SendTimeoutException extends ServerException {
  SendTimeoutException(super.errorModel);
}

class UnauthorizedException extends ServerException {
  UnauthorizedException(super.errorModel);
}

class ForbiddenException extends ServerException {
  ForbiddenException(super.errorModel);
}

class NotFoundException extends ServerException {
  NotFoundException(super.errorModel);
}

class ConflictException extends ServerException {
  ConflictException(super.errorModel);
}

class CancelException extends ServerException {
  CancelException(super.errorModel);
}

class UnknownException extends ServerException {
  UnknownException(super.errorModel);
}

void handleDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionError:
      throw ConnectionErrorException(_handleError(e, "No internet connection"));
    case DioExceptionType.badCertificate:
      throw BadCertificateException(_handleError(e, "Bad certificate"));
    case DioExceptionType.connectionTimeout:
      throw ConnectionTimeoutException(_handleError(e, "Connection timeout"));
    case DioExceptionType.receiveTimeout:
      throw ReceiveTimeoutException(_handleError(e, "Receive timeout"));
    case DioExceptionType.sendTimeout:
      throw SendTimeoutException(_handleError(e, "Send timeout"));
    case DioExceptionType.cancel:
      throw CancelException(_handleError(e, "Request cancelled"));
    case DioExceptionType.badResponse:
      _handleBadResponse(e);
      break;
    case DioExceptionType.unknown:
    case DioExceptionType.transformTimeout:
    default:
      throw UnknownException(_handleError(e, "Something went wrong"));
  }
}

/// Safely creates an ErrorModel from DioException, handling null responses and unexpected data formats
ErrorModel _handleError(DioException e, String defaultMsg) {
  final responseData = e.response?.data;
  final statusCode = e.response?.statusCode ?? 500;

  if (responseData != null && responseData is Map) {
    // Safely use factory if server returns expected JSON map
    return ErrorModel.fromJson(responseData);
  }

  // Fallback to raw response string, Dio's internal message, or custom default
  return ErrorModel(
    status: statusCode,
    errorMessage: responseData?.toString() ?? e.message ?? defaultMsg,
  );
}

void _handleBadResponse(DioException e) {
  final model = _handleError(e, "Server error");
  switch (e.response?.statusCode) {
    case 400:
      throw BadResponseException(model);
    case 401:
      throw UnauthorizedException(model);
    case 403:
      throw ForbiddenException(model);
    case 404:
      throw NotFoundException(model);
    case 409:
      throw ConflictException(model);
    case 504:
      throw BadResponseException(model);
    default:
      throw UnknownException(model);
  }
}
