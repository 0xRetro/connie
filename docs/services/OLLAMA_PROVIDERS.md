# Ollama Providers

## File Location
`lib/providers/ollama/ollama_providers.dart`

## Key Patterns & Principles
- Riverpod state management
- Async state handling
- Persistent configuration
- Type-safe settings
- Error handling
- Connection management

## Responsibilities

Does:
- Manage Ollama configuration state
- Handle settings persistence
- Validate configuration values
- Test Ollama connectivity
- Provide default values
- Handle async operations

Does Not:
- Handle UI rendering
- Process API responses
- Manage model downloads
- Handle authentication
- Store sensitive data

## Component Connections
- [x] Config Layer
  - [x] SharedPreferences
  - [x] Environment settings
  - [x] Default values
- [x] Service Layer
  - [x] HTTP client
  - [x] Connection testing
  - [x] Error handling
- [x] State Layer
  - [x] AsyncNotifierProvider
  - [x] State persistence
  - [x] Value validation
- [x] UI Layer
  - [x] Settings interface
  - [x] Error display
  - [x] Loading states

## Execution Pattern
- [x] Has Initialization Order
  1. Load SharedPreferences instance
  2. Retrieve stored settings
  3. Apply default values
  4. Initialize state
  5. Handle updates
  6. Persist changes

## Dependencies
- `shared_preferences`: Settings persistence
- `dio`: HTTP client for testing
- `riverpod_annotation`: State management
- `freezed`: Immutable models

## Integration Points
- `ollama_agent.dart`: Configuration models
- `ollama_settings_card.dart`: UI integration
- SharedPreferences: Settings storage
- Dio: Connection testing

## Configuration Keys
```dart
const _kBaseUrlKey = 'ollama_base_url';
const _kModelNameKey = 'ollama_model_name';
const _kTemperatureKey = 'ollama_temperature';
const _kContextLengthKey = 'ollama_context_length';
```

## Usage Example
```dart
final config = ref.read(ollamaConfigProvider.notifier);

// Update settings
config.updateBaseUrl('http://localhost:11434');
config.updateModelName('llama2');
config.updateTemperature(0.7);
config.updateContextLength(4096);

// Save settings
await config.saveSettings();

// Test connection
final isConnected = await config.testConnection();

// Reset to defaults
await config.resetToDefaults();
```

## Error Handling
- Null state protection
- Value validation
- Connection timeouts
- Storage errors
- Type conversion

## Best Practices
1. Always check state.valueOrNull before updates
2. Validate numeric values
3. Handle async operations properly
4. Use const for default values
5. Implement proper error handling
6. Test connection before use
7. Save settings after changes
8. Handle loading states
9. Provide user feedback
10. Document API changes 