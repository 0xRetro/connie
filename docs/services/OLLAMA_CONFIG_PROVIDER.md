# Ollama Configuration Provider

## File Location
`lib/providers/ollama/ollama_config_provider.dart`

## Purpose
Manages Ollama service configuration with persistent storage and state management using Riverpod.

## Key Features
- Persistent configuration storage using SharedPreferences
- Default configuration values
- Connection testing
- Settings validation
- Real-time state updates

## Configuration Parameters
- `baseUrl`: Ollama API endpoint (default: 'http://localhost:11434')
- `model`: Model name (default: 'llama2')
- `contextLength`: Maximum context length (default: 4096)
- `temperature`: Generation temperature (default: 0.7)
- `topP`: Top-p sampling (default: 0.9)
- `topK`: Top-k sampling (default: 40)
- `stream`: Enable streaming responses (default: true)
- `connectionTimeout`: Connection timeout in ms (default: 30000)
- `enableDebugLogs`: Enable debug logging (default: true)
- `trackPerformance`: Enable performance tracking (default: true)

## Usage Example
```dart
// Read configuration
final config = ref.watch(ollamaConfigProvider);

// Update settings
final notifier = ref.read(ollamaConfigProvider.notifier);
notifier.updateBaseUrl('http://localhost:11434');
notifier.updateModelName('llama2');
notifier.updateTemperature(0.7);

// Save settings
await notifier.saveSettings();

// Test connection
final isConnected = await notifier.testConnection();
```

## State Management
- Uses AsyncNotifierProvider for handling async state
- Provides loading, error, and data states
- Maintains configuration persistence
- Handles configuration updates

## Methods
- `saveSettings()`: Persist current settings
- `testConnection()`: Test Ollama API connection
- `updateBaseUrl(String)`: Update API endpoint
- `updateModelName(String)`: Update model name
- `updateTemperature(double)`: Update temperature (0.0-1.0)
- `updateContextLength(int)`: Update context length
- `resetToDefaults()`: Reset to default settings

## Error Handling
- Validates temperature range (0.0-1.0)
- Validates positive context length
- Handles connection failures
- Manages persistence errors

## Dependencies
- `riverpod_annotation`
- `shared_preferences`
- `dio`

## Integration Points
- Used by `OllamaSettingsCard` for UI configuration
- Consumed by `OllamaService` for API configuration
- Integrated with app preferences system

## Best Practices
1. Always use the provider through Riverpod's ref system
2. Handle loading and error states in UI
3. Validate settings before saving
4. Test connection after configuration changes
5. Use proper error handling for async operations 