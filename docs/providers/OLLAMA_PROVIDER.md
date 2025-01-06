# OllamaProvider

State management for Ollama integration, handling configuration, chat state, and service provision.

## File Location
`lib/providers/ollama_provider.dart`

## Key Patterns & Principles
- Riverpod state management
- StateNotifier pattern for mutable state
- Provider composition
- Immutable state updates
- Clean separation of concerns

## Responsibilities
Does:
- Manage Ollama configuration state
- Handle chat message history
- Manage loading states
- Handle error states
- Provide service instance
- Stream message updates

Does Not:
- Handle API communication (delegated to service)
- Manage UI state (handled by widgets)
- Handle persistence (currently in-memory only)
- Validate configuration (handled by service)

## Component Connections
- [x] Config Layer
  - [x] OllamaConfig
- [x] Service Layer
  - [x] OllamaService
  - [x] LoggerService
- [x] State Layer
  - [x] ChatMessage Model
  - [x] OllamaState
- [ ] UI Layer
- [x] Util Layer
  - [x] UUID Generation

## Execution Pattern
- [x] Has Initialization Order
  1. Create config notifier
  2. Create service provider
  3. Create chat state notifier

## Dependencies
- `flutter_riverpod`: State management
- `uuid`: Message ID generation
- `OllamaConfig`: Configuration model
- `OllamaService`: API communication
- `ChatMessage`: Message model

## Integration Points
- `lib/config/ollama_config.dart`: Configuration model
- `lib/services/ollama_service.dart`: Service integration
- `lib/models/chat_message.dart`: Message model
- `lib/ui/screens/ai_screen.dart`: Main consumer
- `lib/ui/widgets/ollama_settings_card.dart`: Settings management

## Additional Details

### State Management
```dart
// Configuration State
final ollamaConfigProvider = StateNotifierProvider<OllamaConfigNotifier, OllamaConfig>((ref) {
  return OllamaConfigNotifier();
});

// Service Provider
final ollamaServiceProvider = Provider<OllamaService>((ref) {
  final config = ref.watch(ollamaConfigProvider);
  return OllamaService(config: config);
});

// Chat State
final ollamaProvider = StateNotifierProvider<Ollama, OllamaState>((ref) {
  final service = ref.watch(ollamaServiceProvider);
  return Ollama(service);
});
```

### Chat State Structure
```dart
class OllamaState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;
  final String? currentMessageId;
}
```

### Error Handling
- Configuration errors
- Service errors
- Message parsing errors
- Stream errors

### Message Flow
1. User sends message
2. Update local state
3. Send to service
4. Stream response
5. Update messages
6. Handle completion 