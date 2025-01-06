# Application Error System

Comprehensive error handling system for the application, providing structured error types with context and recovery information for all services and features.

## File Location
`lib/services/errors.dart`

## Key Patterns & Principles
- Hierarchical error structure
- Context-rich error messages
- Stack trace preservation
- Error type specialization
- Recovery information
- Structured logging support
- Service-specific error types
- Consistent error handling patterns

## Responsibilities
Does:
- Define base error hierarchy
- Define service-specific error types
- Capture error context
- Preserve original errors
- Track stack traces
- Provide recovery hints
- Support error reporting
- Enable structured logging

Does Not:
- Handle error recovery
- Manage error state
- Store error history
- Handle UI presentation
- Manage logging
- Handle retry logic
- Implement recovery strategies

## Component Connections
- [x] Config Layer
  - [ ] Theme
  - [ ] Routes
  - [x] Environment
  - [x] Constants
- [x] Service Layer
  - [x] Database
  - [x] API
  - [x] Logger
  - [x] Initialization
- [x] State Layer
  - [x] Models
  - [x] Notifiers
  - [x] Providers
- [x] UI Layer
  - [x] Error Screens
  - [x] Error Widgets
  - [x] Error Boundaries
- [x] Util Layer
  - [x] Error Formatting
  - [x] Error Extensions
  - [x] Error Types

## Execution Pattern
- [ ] Has Initialization Order
- [x] Has No Specific Order
  - Instantiated as needed
  - No initialization required
  - Stateless error types

## Dependencies
- No external package dependencies
- Used throughout the application:
  - All services
  - Error handlers
  - Logging system
  - UI components
  - State management

## Integration Points
- All service files
- All provider files
- Error boundary widgets
- Logger service
- Error screens and widgets

## Additional Details

### Error Hierarchy
```dart
/// Base error class for all application errors
abstract class AppError implements Exception {
  final String message;
  final Object? originalError;
  final StackTrace? stackTrace;
}

/// Service-specific errors extend AppError
abstract class ServiceError extends AppError {
  // Additional service context
}

/// API-related errors
class ApiError extends ServiceError {
  final int? statusCode;
  final String endpoint;
}

/// Configuration errors
class ConfigError extends ServiceError {}

/// Rate limiting errors
class RateLimitError extends ServiceError {
  final Duration retryAfter;
}

/// Stream operation errors
class StreamError extends ServiceError {
  final String connectionUrl;
}

/// Data parsing errors
class ParseError extends ServiceError {
  final String responseData;
}

/// Database errors
class DatabaseError extends ServiceError {
  final String operation;
  final String? table;
}
```

### Error Categories
1. Service Errors
   - API failures
   - Configuration issues
   - Rate limiting
   - Stream operations
   - Parse failures
   - Database operations

2. UI Errors
   - Rendering failures
   - Navigation errors
   - Input validation
   - State inconsistencies

3. Business Logic Errors
   - Validation failures
   - Process failures
   - State transitions
   - Data consistency

### Error Context
Each error type includes:
- Descriptive message
- Original error (if any)
- Stack trace
- Type-specific context
- Recovery hints
- Service context

### Usage Examples
```dart
// API Error
try {
  await api.call();
} catch (e, stack) {
  throw ApiError(
    'Failed to connect',
    endpoint: '/api/endpoint',
    statusCode: 500,
    originalError: e,
    stackTrace: stack,
  );
}

// Database Error
try {
  await db.query();
} catch (e, stack) {
  throw DatabaseError(
    'Failed to read data',
    operation: 'SELECT',
    table: 'users',
    originalError: e,
    stackTrace: stack,
  );
}
```

### Error Recovery
- RateLimitError includes retry timing
- ApiError includes status codes
- ParseError includes problematic data
- StreamError includes connection details
- DatabaseError includes operation context

### Error Handling Best Practices
1. Always include original error and stack trace
2. Use specific error types over generic ones
3. Include relevant context in error messages
4. Follow consistent error patterns
5. Consider error recovery options
6. Log errors appropriately
7. Present user-friendly messages

## Review Checklist
- [x] Title and description are clear and concise
- [x] Key patterns & principles are documented
- [x] Responsibilities are well-defined
- [x] Component connections are accurately marked
- [x] Execution pattern is specified
- [x] Dependencies are accurately listed
- [x] Integration points are verified
- [x] Additional details match component connections
- [x] Format is consistent
- [x] Links are valid 