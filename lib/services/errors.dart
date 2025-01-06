/// Base error class for all application errors
abstract class AppError implements Exception {
  final String message;
  final Object? originalError;
  final StackTrace? stackTrace;

  const AppError(
    this.message, {
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => '${runtimeType}: $message';
}

/// Base class for service-specific errors
abstract class ServiceError extends AppError {
  const ServiceError(
    super.message, {
    super.originalError,
    super.stackTrace,
  });
}

/// Error for API request failures
class ApiError extends ServiceError {
  final int? statusCode;
  final String endpoint;

  const ApiError(
    super.message, {
    required this.endpoint,
    this.statusCode,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'ApiError: $message (Endpoint: $endpoint, Status: $statusCode)';
}

/// Error for configuration issues
class ConfigError extends ServiceError {
  const ConfigError(
    super.message, {
    super.originalError,
    super.stackTrace,
  });
}

/// Error for rate limiting
class RateLimitError extends ServiceError {
  final Duration retryAfter;

  const RateLimitError(
    super.message, {
    required this.retryAfter,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'RateLimitError: $message (Retry after: $retryAfter)';
}

/// Error for stream operations
class StreamError extends ServiceError {
  final String connectionUrl;

  const StreamError(
    super.message, {
    required this.connectionUrl,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'StreamError: $message (URL: $connectionUrl)';
}

/// Error for parsing responses
class ParseError extends ServiceError {
  final String responseData;

  const ParseError(
    super.message, {
    required this.responseData,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'ParseError: $message (Response: $responseData)';
}

/// Error for database operations
class DatabaseError extends ServiceError {
  final String operation;
  final String? table;

  const DatabaseError(
    super.message, {
    required this.operation,
    this.table,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'DatabaseError: $message (Operation: $operation${table != null ? ', Table: $table' : ''})';
}

/// Error for UI rendering issues
class UIError extends AppError {
  final String? widget;
  final String? screen;

  const UIError(
    super.message, {
    this.widget,
    this.screen,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'UIError: $message${widget != null ? ' (Widget: $widget)' : ''}${screen != null ? ' (Screen: $screen)' : ''}';
}

/// Error for business logic validation
class ValidationError extends AppError {
  final String field;
  final String? value;

  const ValidationError(
    super.message, {
    required this.field,
    this.value,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'ValidationError: $message (Field: $field${value != null ? ', Value: $value' : ''})';
} 