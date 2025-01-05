# Application Providers

## Overview
Documentation of all providers in the application, their responsibilities, and usage patterns.

## Core Providers

### FirstRunProvider
`first_run_provider.dart`

Manages the application's first-run state.

#### Implementation
```dart
@riverpod
class FirstRunStateNotifier extends _$FirstRunStateNotifier {
  @override
  Future<bool> build() async {
    return _loadFirstRunState();
  }

  bool get isFirstRun => state.value ?? true;
  
  Future<void> resetFirstRun() async {
    state = const AsyncData(false);
  }
}
```

#### Usage
```dart
// Check first run state
final isFirstRun = ref.watch(firstRunStateProvider).value ?? true;

// Reset first run state
await ref.read(firstRunStateProvider.notifier).resetFirstRun();
```

### ThemeProvider
`theme_provider.dart`

Manages application theme settings.

#### Implementation
```dart
@riverpod
class ThemeState extends _$ThemeState {
  @override
  ThemeMode build() => ThemeMode.system;
  
  void setThemeMode(ThemeMode mode) => state = mode;
}
```

#### Usage
```dart
// Get current theme
final themeMode = ref.watch(themeStateProvider);

// Update theme
ref.read(themeStateProvider.notifier).setThemeMode(ThemeMode.dark);
```

### AppPreferencesProvider
`app_preferences_provider.dart`

Manages application preferences and settings.

#### Implementation
```dart
@riverpod
class AppPreferencesNotifier extends _$AppPreferencesNotifier {
  @override
  AppPreferences build() => const AppPreferences();
  
  Future<void> updatePreferences(AppPreferences preferences) async {
    state = preferences;
  }
}
```

#### Usage
```dart
// Get preferences
final preferences = ref.watch(appPreferencesProvider);

// Update preferences
await ref.read(appPreferencesProvider.notifier)
  .updatePreferences(newPreferences);
```

### NavigationProvider
`navigation_provider.dart`

Manages application navigation state and history.

#### Implementation
```dart
@riverpod
class NavigationState extends _$NavigationState {
  @override
  NavigationStack build() => NavigationStack.empty();
  
  void pushRoute(String route) {
    state = state.push(route);
  }
  
  void popRoute() {
    state = state.pop();
  }
}
```

#### Usage
```dart
// Navigate to route
ref.read(navigationProvider.notifier).pushRoute('/settings');

// Go back
ref.read(navigationProvider.notifier).popRoute();
```

### ErrorProvider
`error_provider.dart`

Manages application-wide error state and error handling.

#### Implementation
```dart
@riverpod
class ErrorNotifier extends _$ErrorNotifier {
  @override
  List<AppError> build() => [];
  
  void addError(AppError error) {
    state = [...state, error];
  }
  
  void clearErrors() {
    state = [];
  }
}
```

#### Usage
```dart
// Add error
ref.read(errorProvider.notifier).addError(error);

// Clear errors
ref.read(errorProvider.notifier).clearErrors();
```

## Provider Dependencies

### Service Dependencies
- `DatabaseService` → `FirstRunProvider`
- `LoggerService` → All providers
- `NavigationService` → `NavigationProvider`

### State Dependencies
- `ThemeProvider` → `AppPreferencesProvider`
- `ErrorProvider` → All providers
- `FirstRunProvider` → `SetupWorkflowProvider`

## Testing

### Unit Tests
```dart
test('FirstRunProvider loads state', () async {
  final container = ProviderContainer(
    overrides: [
      databaseServiceProvider.overrideWithValue(MockDatabase()),
    ],
  );
  
  final firstRun = await container.read(firstRunStateProvider.future);
  expect(firstRun, isTrue);
});
```

### Integration Tests
```dart
test('AppPreferences updates theme', () async {
  final container = ProviderContainer();
  
  await container.read(appPreferencesProvider.notifier)
    .updatePreferences(darkThemePreferences);
    
  final themeMode = container.read(themeStateProvider);
  expect(themeMode, equals(ThemeMode.dark));
});
```

## Best Practices

### 1. State Updates
- Use immutable state updates
- Implement proper error handling
- Handle loading states
- Manage dependencies correctly

### 2. Error Handling
- Use AsyncValue for async operations
- Implement proper error propagation
- Log errors appropriately
- Handle edge cases

### 3. Testing
- Test all state transitions
- Mock dependencies
- Test error cases
- Verify state updates

### 4. Performance
- Minimize rebuilds
- Use proper scoping
- Implement caching when needed
- Handle disposal correctly

## Review Checklist

Before modifying providers:
- [ ] Follows provider standards
- [ ] Implements proper error handling
- [ ] Handles loading states
- [ ] Manages dependencies correctly
- [ ] Includes comprehensive tests
- [ ] Documents state changes
- [ ] Uses appropriate provider type
- [ ] Implements proper logging
``` 