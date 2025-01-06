# OllamaService

Core service for interacting with Ollama's API, providing robust streaming chat completions with support for both native Ollama and OpenAI-compatible endpoints.

## File Location
`lib/services/ollama_service.dart`

## Key Patterns & Principles
- Service-based architecture with dependency injection
- Stream-based response handling with buffer management
- Reactive error handling with custom error types
- Rate limiting with token bucket algorithm
- Exponential backoff for retries
- Connection pooling and resource management
- Performance metrics tracking
- Cancellable operations

## Responsibilities
Does:
- Handle API communication with Ollama server
- Manage streaming responses and message parsing
- Handle rate limiting and request queuing
- Provide connection testing and validation
- Track performance metrics
- Handle both native and OpenAI-compatible endpoints
- Manage connection lifecycle and cleanup
- Support request cancellation
- Log performance metrics

Does Not:
- Store configuration (handled by OllamaConfig)
- Manage UI state (handled by providers)
- Handle persistence (stateless service)
- Manage chat history (handled by providers)
- Handle authentication (not required for Ollama)
- Parse response data (handled by OllamaResponse)

## Component Connections
- [x] Config Layer
  - [x] OllamaConfig
  - [ ] Routes
  - [ ] Environment
  - [x] Constants
- [x] Service Layer
  - [ ] Database
  - [x] API (Dio)
  - [x] Logger
  - [x] Rate Limiter
- [x] State Layer
  - [x] Providers
  - [x] Models (OllamaResponse)
  - [x] Error Types
- [ ] UI Layer
- [x] Util Layer
  - [x] UUID Generation
  - [x] JSON Parsing
  - [x] Stream Transformers

## Execution Pattern
- [x] Has Initialization Order
  1. Create Dio instance
  2. Configure base options and timeouts
  3. Add logging interceptor
  4. Add retry interceptor
  5. Initialize rate limiter
  6. Configure response handling

## Dependencies
- `dio`: HTTP client for API requests
- `uuid`: Generating unique message IDs
- `retry`: Implementing retry logic
- `flutter_riverpod`: Dependency injection
- `OllamaConfig`: Configuration management
- `LoggerService`: Structured logging
- `RateLimiter`: Request rate limiting
- `OllamaResponse`: Response parsing

## Integration Points
- `lib/config/ollama_config.dart`: Configuration source
- `lib/services/rate_limiter.dart`: Rate limiting
- `lib/services/logger_service.dart`: Logging
- `lib/services/errors.dart`: Error definitions
- `lib/providers/ollama_provider.dart`: Service provider

## Additional Details

### Configuration
```dart
BaseOptions(
  baseUrl: config.baseUrl,
  connectTimeout: Duration(milliseconds: config.connectionTimeout),
  receiveTimeout: Duration(milliseconds: config.connectionTimeout),
  sendTimeout: Duration(milliseconds: config.connectionTimeout),
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
  validateStatus: (status) => status != null && status >= 200 && status < 300,
  responseType: ResponseType.json,
  listFormat: ListFormat.multiCompatible,
)
```

### State Management
- Uses Provider pattern for service instance
- Stateless service design
- Reactive stream handling
- Error propagation through custom types

### Services
- Initialization:
  ```dart
  final service = ref.watch(ollamaServiceProvider);
  ```
- Error Handling:
  - Connection errors
  - Timeout errors
  - Rate limit errors
  - Parse errors
  - Stream errors

### API Endpoints
- `/api/tags`: List models (test connection)
- `/v1/chat/completions`: OpenAI-compatible chat
- `/api/generate`: Native Ollama generation

### Stream Response Format
```dart
class OllamaResponse {
  final String model;
  final String response;
  final bool done;
  final DateTime? createdAt;
  final Map<String, dynamic>? metrics;
}
```

### Error Handling
- Connection errors with retry logic
- Timeout handling with configurable limits
- Rate limit management with backoff
- Parse errors with detailed context
- Stream errors with buffer management
- Request cancellation handling
- Resource cleanup on disposal

### Performance Tracking
- Request duration logging
- Stream processing metrics
- Rate limit statistics
- Connection pool usage
- Error rate monitoring
- Response parsing timing

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