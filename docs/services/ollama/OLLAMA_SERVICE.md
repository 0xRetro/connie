# Ollama Service

## File Location
`lib/services/ollama_service.dart`

## Purpose
Provides core API communication with Ollama server, handling requests, responses, streaming, and agent management.

## Key Components

### OllamaResponse
```dart
@freezed
class OllamaResponse with _$OllamaResponse {
  const factory OllamaResponse({
    required String model,
    required String response,
    required bool done,
    double? totalDuration,
    double? loadDuration,
    double? promptEvalCount,
    double? evalCount,
    double? evalDuration,
  }) = _OllamaResponse;
}
```

### Service Methods
- `generate`: Single response generation
- `generateStream`: Streaming response generation
- `createAgent`: Create new agent
- `getAgent`: Retrieve agent details
- `listAgents`: List all agents
- `deleteAgent`: Remove an agent

## Error Handling
- API communication errors
- WebSocket connection errors
- Response parsing errors
- Agent management errors

## Performance Tracking
- Request duration logging
- Evaluation metrics tracking
- Stream performance monitoring

## Integration Points
- Uses `OllamaServiceConfig` for configuration
- Uses `LoggerService` for logging
- Provides providers for DI:
  - `ollamaServiceProvider`
  - `ollamaConfigProvider`

## Usage Examples

### Basic Generation
```dart
final service = ref.read(ollamaServiceProvider);
final response = await service.generate(
  prompt: "Hello, how are you?",
);
print(response.response);
```

### Streaming Generation
```dart
final service = ref.read(ollamaServiceProvider);
service.generateStream(
  prompt: "Tell me a story",
).listen((response) {
  print(response.response);
});
```

### Agent Management
```dart
final service = ref.read(ollamaServiceProvider);

// Create agent
await service.createAgent(
  name: "assistant",
  systemPrompt: "You are a helpful assistant",
);

// List agents
final agents = await service.listAgents();

// Delete agent
await service.deleteAgent("assistant");
```

## Best Practices
1. Always handle stream cleanup
2. Implement proper error handling
3. Use logging for debugging
4. Track performance metrics
5. Handle connection timeouts
6. Validate inputs
7. Clean up resources

## Required Improvements
1. Implement retry logic
2. Add rate limiting
3. Create custom error types
4. Move providers to separate file
5. Add input validation
6. Enhance error handling
7. Add request cancellation
8. Implement connection pooling

## Dependencies
- `dio`: HTTP client
- `web_socket_channel`: WebSocket support
- `freezed`: Immutable models
- `riverpod`: State management
- `uuid`: ID generation

## Testing
- Unit tests for response parsing
- Integration tests for API calls
- Mock tests for error cases
- Stream testing
- Agent management testing 