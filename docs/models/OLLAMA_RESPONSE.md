# OllamaResponse

Data model representing responses from the Ollama API, supporting both native Ollama and OpenAI-compatible response formats with performance metrics.

## File Location
`lib/models/ollama_response.dart`

## Key Patterns & Principles
- Immutable data structure using Freezed
- Factory pattern for parsing responses
- Robust error handling
- Format compatibility layer
- Performance metrics tracking
- JSON serialization with code generation
- Pattern matching support via Freezed

## Responsibilities
Does:
- Parse API responses from multiple formats
- Validate response data structure
- Extract performance metrics
- Handle streaming and non-streaming responses
- Provide JSON serialization
- Track response metadata
- Support pattern matching and copying
- Generate equality comparisons

Does Not:
- Handle API communication
- Manage state
- Handle error recovery
- Store historical responses
- Manage response lifecycle

## Component Connections
- [x] Config Layer
  - [ ] Theme
  - [ ] Routes
  - [ ] Environment
  - [ ] Constants
- [x] Service Layer
  - [ ] Database
  - [x] API (Response parsing)
  - [ ] Logger
  - [ ] Initialization
- [x] State Layer
  - [x] Models
  - [ ] Notifiers
  - [ ] Providers
- [ ] UI Layer
  - [ ] Screens
  - [ ] Widgets
  - [ ] Layouts
- [x] Util Layer
  - [x] JSON Parsing
  - [ ] Extensions
  - [ ] Types

## Execution Pattern
- [x] Has Initialization Order
  1. Parse JSON input
  2. Detect response format
  3. Extract required fields
  4. Collect performance metrics
  5. Create immutable instance

## Dependencies
- `freezed_annotation`: Immutable model generation
- `json_serializable`: JSON serialization
- Internal dependencies:
  - ParseError: Error handling
  - JSON serialization

## Integration Points
- `lib/services/ollama_service.dart`: Primary consumer
- `lib/services/errors.dart`: Error definitions
- Used by stream handlers and response processors

## Additional Details

### Data Structure
```dart
@freezed
class OllamaResponse with _$OllamaResponse {
  const factory OllamaResponse({
    required String model,        // Model identifier
    required String response,     // Generated text
    required bool done,          // Completion status
    DateTime? createdAt,         // Timestamp
    Map<String, dynamic>? metrics, // Performance data
  }) = _OllamaResponse;

  factory OllamaResponse.fromJson(Map<String, dynamic> json) => _$OllamaResponseFromJson(json);
}
```

### Generated Features
- Immutable data structure
- Copy with functionality
- Equality comparison
- toString implementation
- Pattern matching support
- JSON serialization
- Null safety

### Response Formats
1. OpenAI Compatible:
```json
{
  "choices": [{
    "delta": { "content": "..." },
    "finish_reason": "stop"
  }],
  "model": "model-name",
  "created": 1234567890
}
```

2. Native Ollama:
```json
{
  "model": "model-name",
  "response": "...",
  "done": true,
  "total_duration": 1234,
  "load_duration": 100,
  "prompt_eval_count": 10,
  "eval_count": 50,
  "eval_duration": 500
}
```

### Performance Metrics
- total_duration: Overall processing time
- load_duration: Model loading time
- prompt_eval_count: Prompt token count
- eval_count: Generated token count
- eval_duration: Generation time

### Error Handling
- Validates required fields
- Throws ParseError for invalid formats
- Provides detailed error context
- Handles missing optional fields

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