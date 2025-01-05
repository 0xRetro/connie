# Ollama Service Configuration

Type-safe configuration model that provides validated settings for the Ollama service integration, with support for global configuration and JSON serialization.

## File Location
`lib/config/ollama_service_config.dart`

## Key Patterns & Principles
- Freezed for immutable data structures
- Factory pattern for configuration creation
- Validation through assertions
- Error handling with logging
- JSON serialization
- Global configuration integration

## Responsibilities

Does:
- Provide type-safe configuration for Ollama service
- Validate configuration values
- Handle configuration serialization
- Integrate with global configuration
- Log configuration errors
- Enforce configuration constraints

Does Not:
- Store configuration values (delegated to global config)
- Handle configuration persistence
- Manage configuration state
- Handle service initialization
- Manage API connections

## Component Connections
- [x] Config Layer
  - [x] Environment (via global config)
  - [x] Constants (validation values)
  - [ ] Routes
  - [ ] Theme
- [x] Service Layer
  - [ ] Database
  - [ ] API
  - [x] Logger
  - [ ] Initialization
- [x] State Layer
  - [x] Providers (ollamaConfigProvider)
  - [ ] Notifiers
  - [x] Models (OllamaServiceConfig)
- [ ] UI Layer
  - [ ] Screens
  - [ ] Widgets
  - [ ] Layouts
- [ ] Util Layer
  - [ ] Helpers
  - [ ] Extensions
  - [ ] Types

## Execution Pattern
- [x] Has Initialization Order
  1. Load global configuration
  2. Validate configuration values
  3. Create configuration instance
  4. Initialize service with config

- [ ] Has No Specific Order

## Dependencies
- `freezed_annotation`: Immutable class generation
- `ollama_config.dart`: Global configuration values
- `logger_service.dart`: Error and debug logging

## Integration Points
- `lib/services/ollama_service.dart`: Consumes configuration for API setup
- `lib/providers/ollama_provider.dart`: Uses config for service initialization
- `lib/config/ollama_config.dart`: Provides global configuration values

## Additional Details

### Configuration
- Required Values:
  ```dart
  {
    baseUrl: String,
    model: String,
    contextLength: int,
    temperature: double,
    topP: double,
    topK: int,
    stream: bool,
    connectionTimeout: int,
    enableDebugLogs: bool,
    trackPerformance: bool
  }
  ```

- Validation Rules:
  - temperature: 0.0 to 1.0
  - topP: 0.0 to 1.0
  - topK: > 0
  - contextLength: > 0
  - connectionTimeout: ≥ 1000ms

### State Management
- Configuration is immutable
- Updates require new instance creation
- Changes propagate through provider system
- Error states handled through AsyncValue

### Services
- Error Handling:
  - Validation errors through assertions
  - JSON parsing errors with logging
  - Global config errors with context
  - Type errors with detailed messages

- Logging Strategy:
  - Configuration creation errors
  - Validation failures
  - Parse errors with data context
  - Global config integration issues

### Factory Methods
```dart
// From JSON
final config = OllamaServiceConfig.fromJson(jsonData);

// From Global Config (recommended)
final config = OllamaServiceConfig.fromGlobalConfig();

// Direct Creation
final config = OllamaServiceConfig(
  baseUrl: 'http://localhost:11434',
  model: 'llama2',
  // ... other required values
);
```

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