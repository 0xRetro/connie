# Ollama Integration

## File Location
`docs/services/OLLAMA_INTEGRATION.md`

## Key Patterns & Principles
- Service-based architecture for Ollama interaction
- Reactive state management with Riverpod
- Structured agent and workflow management
- Type-safe data models with Freezed
- Streaming response support
- Error handling and state management

## Component Structure
```
lib/
├── services/
│   └── ollama_service.dart         # Core API service
├── providers/
│   └── ollama/
│       ├── ollama_providers.dart    # Chat & agent providers
│       └── ollama_config_provider.dart # Configuration provider
├── models/
│   └── ollama_agent.dart           # Data models
├── config/
│   └── ollama_service_config.dart  # Service configuration
└── ui/
    └── widgets/
        └── ollama_settings_card.dart # Settings UI
```

## Core Components

### OllamaService
- REST API communication
- WebSocket streaming
- Agent management
- Response handling
- Error management

### OllamaConfig Provider
- Configuration management
- Settings persistence
- Connection testing
- Default values
- Runtime updates

### Chat Provider
- Message management
- Conversation history
- Streaming support
- Error handling
- State persistence

### UI Components
- Settings management
- Chat interface
- Error boundaries
- Loading states
- User feedback

## Dependencies
- `dio`: HTTP client
- `riverpod`: State management
- `freezed`: Data models
- `shared_preferences`: Settings storage
- `web_socket_channel`: Streaming
- `uuid`: ID generation

## Usage Examples

### Configuration
```dart
final config = ref.watch(ollamaConfigProvider);
final notifier = ref.read(ollamaConfigProvider.notifier);

// Update settings
notifier.updateBaseUrl('http://localhost:11434');
notifier.updateModelName('llama2');
await notifier.saveSettings();

// Test connection
final isConnected = await notifier.testConnection();
```

### Chat Interaction
```dart
final chat = ref.read(ollamaChatProvider.notifier);

// Send message
await chat.sendMessage('Hello, how are you?');

// Clear chat
await chat.clearChat();
```

### Agent Management
```dart
final agents = ref.read(ollamaAgentsProvider.notifier);

// Create agent
await agents.createAgent(
  'assistant',
  'You are a helpful assistant.',
  metadata: {'type': 'general'},
);

// Delete agent
await agents.deleteAgent('assistant');
```

## Best Practices
1. Use proper error handling
2. Handle loading states
3. Validate inputs
4. Test connections
5. Follow reactive patterns
6. Implement error boundaries
7. Document changes
8. Test edge cases

## Error Handling
- API communication errors
- Configuration errors
- WebSocket errors
- State management errors
- UI feedback

## Security
1. Validate inputs
2. Handle sensitive data
3. Secure communication
4. Rate limiting
5. Error logging

## Testing
- Unit tests
- Integration tests
- UI tests
- Error scenarios
- Edge cases 