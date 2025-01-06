# OllamaConfig

Configuration management for Ollama service settings, providing a single source of truth for all Ollama-related configuration.

## File Location
`lib/config/ollama_config.dart`

## Key Patterns & Principles
- Immutable configuration using Freezed
- Default values for all settings
- Type-safe configuration
- Single source of truth pattern
- Serializable for persistence

## Responsibilities
Does:
- Store Ollama connection settings
- Store model configuration
- Store performance settings
- Provide default values
- Support JSON serialization

Does Not:
- Handle persistence (managed by providers)
- Validate server connection (handled by service)
- Manage state updates (handled by provider)
- Handle API communication

## Component Connections
- [x] Config Layer
  - [x] Environment Variables
  - [x] Constants
- [ ] Service Layer
- [x] State Layer
  - [x] OllamaConfigNotifier
- [ ] UI Layer
- [ ] Util Layer

## Execution Pattern
- [ ] Has Initialization Order
- [x] Has No Specific Order
  - Can be instantiated at any time
  - Immutable after creation
  - No initialization requirements

## Dependencies
- `freezed_annotation`: For immutable class generation
- `json_serializable`: For JSON serialization

## Integration Points
- `lib/services/ollama_service.dart`: Uses config for service setup
- `lib/providers/ollama_provider.dart`: Manages config state
- `lib/ui/widgets/ollama_settings_card.dart`: UI for config modification

## Additional Details

### Configuration
```dart
@freezed
class OllamaConfig with _$OllamaConfig {
  const factory OllamaConfig({
    @Default('http://localhost:11434') String baseUrl,
    @Default('llama2:latest') String model,
    @Default(0.7) double temperature,
    @Default(0.9) double topP,
    @Default(40) int topK,
    @Default(true) bool stream,
    @Default(30000) int connectionTimeout,
    @Default(true) bool trackPerformance,
    @Default(const Duration(minutes: 1)) Duration rateLimitInterval,
  }) = _OllamaConfig;
} 