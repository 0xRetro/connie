# Application Preferences Service

Manages persistent application preferences and state using SharedPreferences, with a primary focus on tracking the application's initialization state and first-run behavior.

## File Location
`lib/services/app_preferences.dart`

## Key Patterns & Principles
- Uses singleton pattern with private constructor
- Implements initialization verification pattern
- Provides structured error handling
- Uses async/await pattern
- Follows Single Responsibility Principle
- Implements proper resource cleanup
- Uses null-safety patterns
- Provides testability support

## Responsibilities
Does:
- Manage first-run state
- Track initialization state
- Handle preference persistence
- Verify initialization status
- Log state changes
- Manage resource lifecycle
- Handle initialization errors
- Provide testing utilities
- Ensure thread safety
- Manage instance cleanup

Does Not:
- Handle user settings
- Manage runtime configuration
- Store sensitive data
- Handle complex state
- Cache application data
- Configure environment
- Manage UI state
- Handle database operations

## Component Connections
- [x] Config Layer
  - [ ] Theme
  - [ ] Routes
  - [x] Environment
  - [ ] Constants
- [x] Service Layer
  - [ ] Database
  - [ ] API
  - [x] Logger
  - [x] Initialization
- [ ] State Layer
  - [ ] Providers
  - [ ] Notifiers
  - [ ] Models
- [ ] UI Layer
  - [ ] Screens
  - [ ] Widgets
  - [ ] Layouts
- [x] Util Layer
  - [x] Testing
  - [ ] Extensions
  - [ ] Types

## Execution Pattern
- [x] Has Initialization Order
  1. Instance creation (singleton)
  2. SharedPreferences acquisition
  3. Initialization verification
  4. First run check
  5. State persistence
  6. Resource cleanup

## Dependencies
- `shared_preferences`: Persistent storage
- `logger_service.dart`: Logging functionality

## Integration Points
- `initialization_service.dart`: First run detection
- `logger_service.dart`: State logging
- `main.dart`: App initialization

## Additional Details

### Key Methods
```dart
Future<void> initialize()
Future<bool> get isFirstRun
Future<void> setFirstRunCompleted()
Future<void> resetFirstRun()
Future<void> dispose()
```

### Initialization Flow
1. Singleton instance creation
2. SharedPreferences initialization
3. First run state check
4. Logging of state changes
5. Resource cleanup on dispose

### Error Handling
```dart
try {
  _prefs = await SharedPreferences.getInstance();
  LoggerService.debug('AppPreferences initialized');
} catch (e, stack) {
  LoggerService.error(
    'Failed to initialize AppPreferences',
    error: e,
    stackTrace: stack,
  );
  rethrow;
}
```

### State Management
- First run state tracking
- Initialization state verification
- Resource state management
- Cleanup state handling

### Testing Support
- Reset capabilities
- State verification
- Error simulation
- Resource cleanup

### Constants
```dart
static const String _firstRunKey = 'first_run';
```

### Resource Management
- Proper initialization
- Null safety checks
- Resource disposal
- State cleanup 