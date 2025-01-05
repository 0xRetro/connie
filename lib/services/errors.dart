/// Base class for service-related errors.
/// 
/// This class provides a common base for all service errors, including
/// proper error message handling and stack trace support.
abstract class ServiceError implements Exception {
  /// Creates a new service error.
  ServiceError(this.message, {this.originalError, this.stackTrace});

  /// The error message describing what went wrong.
  final String message;

  /// The original error that caused this error, if any.
  final dynamic originalError;

  /// The stack trace where the error occurred.
  final StackTrace? stackTrace;

  @override
  String toString() => 'ServiceError: $message';
}

/// Error during API communication.
/// 
/// This error occurs when there are issues communicating with an API endpoint,
/// such as network errors, invalid responses, or server errors.
class ApiError extends ServiceError {
  /// Creates a new API error.
  ApiError(
    String message, {
    this.statusCode,
    this.endpoint,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(message, originalError: originalError, stackTrace: stackTrace);

  /// The HTTP status code of the failed request, if available.
  final int? statusCode;

  /// The API endpoint that was being accessed.
  final String? endpoint;

  @override
  String toString() => 'ApiError: $message (Status: $statusCode, Endpoint: $endpoint)';
}

/// Error during WebSocket communication.
/// 
/// This error occurs when there are issues with WebSocket connections,
/// such as connection failures, message parsing errors, or disconnections.
class StreamError extends ServiceError {
  /// Creates a new stream error.
  StreamError(
    String message, {
    this.connectionUrl,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(message, originalError: originalError, stackTrace: stackTrace);

  /// The WebSocket URL that was being connected to.
  final String? connectionUrl;

  @override
  String toString() => 'StreamError: $message (URL: $connectionUrl)';
}

/// Error during response parsing.
/// 
/// This error occurs when there are issues parsing API responses,
/// such as invalid JSON, missing required fields, or type mismatches.
class ParseError extends ServiceError {
  /// Creates a new parse error.
  ParseError(
    String message, {
    this.responseData,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(message, originalError: originalError, stackTrace: stackTrace);

  /// The raw response data that failed to parse.
  final String? responseData;

  @override
  String toString() => 'ParseError: $message';
}

/// Error during rate limiting.
/// 
/// This error occurs when a service has exceeded its rate limit
/// and needs to wait before making more requests.
class RateLimitError extends ServiceError {
  /// Creates a new rate limit error.
  RateLimitError(
    String message, {
    this.retryAfter,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(message, originalError: originalError, stackTrace: stackTrace);

  /// The duration to wait before retrying the request.
  final Duration? retryAfter;

  @override
  String toString() => 'RateLimitError: $message (Retry After: $retryAfter)';
}

/// Error during configuration.
/// 
/// This error occurs when there are issues with service configuration,
/// such as missing required values, invalid settings, or initialization failures.
class ConfigError extends ServiceError {
  /// Creates a new configuration error.
  ConfigError(
    String message, {
    this.configKey,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(message, originalError: originalError, stackTrace: stackTrace);

  /// The configuration key that caused the error.
  final String? configKey;

  @override
  String toString() => 'ConfigError: $message (Config Key: $configKey)';
} 