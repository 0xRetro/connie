# Provider Standards and Patterns

## Overview
Providers are the core state management solution using Riverpod. They manage application state, handle data flow, and coordinate between UI and services.

## Provider Types

### 1. State Providers
```dart
@riverpod
class ThemeState extends _$ThemeState {
  @override
  ThemeMode build() => ThemeMode.system;
  
  void setThemeMode(ThemeMode mode) => state = mode;
}
```

### 2. Async State Providers
```dart
@riverpod
class FirstRunState extends _$FirstRunState {
  @override
  Future<bool> build() async {
    return _loadFirstRunState();
  }
  
  bool get isFirstRun => state.value ?? true;
}
```

### 3. Notifier Providers
```dart
@riverpod
class ErrorNotifier extends _$ErrorNotifier {
  @override
  List<AppError> build() => [];
  
  void addError(AppError error) {
    state = [...state, error];
  }
}
```

### 4. Service Providers
```dart
@riverpod
DatabaseService databaseService(DatabaseServiceRef ref) {
  return DatabaseService(ref);
}
```

## Implementation Guidelines

### 1. Provider Definition
```dart
// DO: Use code generation
@riverpod
class MyState extends _$MyState {
  @override
  Type build() => initialValue;
}

// DON'T: Use manual provider definition
final myProvider = StateProvider<Type>((ref) => initialValue);  // Wrong
```

### 2. State Updates
```dart
// DO: Use immutable state updates
void addItem(Item item) {
  state = [...state, item];
}

// DON'T: Mutate state directly
void addItem(Item item) {  // Wrong
  state.add(item);
}
```

### 3. Error Handling
```dart
// DO: Use AsyncValue for async operations
@override
Future<User> build() async {
  try {
    return await _loadUser();
  } catch (e, st) {
    return AsyncError(e, st);
  }
}

// DON'T: Swallow errors
@override
Future<User?> build() async {  // Wrong
  try {
    return await _loadUser();
  } catch (_) {
    return null;
  }
}
```

### 4. Dependencies
```dart
// DO: Watch dependencies that affect state
@override
Stream<List<Message>> build() {
  final user = ref.watch(userProvider);
  return _messageService.watchMessages(user.id);
}

// DON'T: Read dependencies that should be watched
@override
Stream<List<Message>> build() {  // Wrong
  final user = ref.read(userProvider);
  return _messageService.watchMessages(user.id);
}
```

## State Management Patterns

### 1. Loading States
```dart
// DO: Use AsyncValue for loading states
@riverpod
class DataState extends _$DataState {
  @override
  Future<Data> build() async {
    state = const AsyncLoading();
    return _loadData();
  }
}

// DO: Handle loading in UI
Consumer(
  builder: (context, ref, child) {
    final state = ref.watch(dataStateProvider);
    return state.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => ErrorDisplay(error: error),
      data: (data) => DataView(data: data),
    );
  },
)
```

### 2. Error States
```dart
// DO: Use AsyncValue for error states
@riverpod
class UserState extends _$UserState {
  @override
  Future<User> build() async {
    try {
      return await _loadUser();
    } catch (e, st) {
      _logError(e, st);
      rethrow;
    }
  }
}

// DO: Handle errors in UI
ref.listen(userStateProvider, (previous, next) {
  next.whenOrNull(
    error: (error, stack) => showErrorDialog(context, error),
  );
});
```

### 3. Caching
```dart
// DO: Implement caching when needed
@riverpod
class CachedData extends _$CachedData {
  Timer? _cacheTimer;
  
  @override
  Future<Data> build() async {
    _cacheTimer?.cancel();
    _cacheTimer = Timer(const Duration(minutes: 5), () {
      ref.invalidateSelf();
    });
    return _fetchData();
  }
  
  @override
  void dispose() {
    _cacheTimer?.cancel();
    super.dispose();
  }
}
```

### 4. State Dependencies
```dart
// DO: Use computed states
@riverpod
bool isLoading(IsLoadingRef ref) {
  final state1 = ref.watch(provider1);
  final state2 = ref.watch(provider2);
  return state1.isLoading || state2.isLoading;
}

// DON'T: Duplicate state logic
@riverpod  // Wrong
class LoadingState extends _$LoadingState {
  @override
  bool build() {
    final state1 = ref.watch(provider1);
    final state2 = ref.watch(provider2);
    return state1.isLoading || state2.isLoading;
  }
}
```

## Testing Requirements

### 1. Unit Tests
```dart
test('updates theme mode', () {
  final container = ProviderContainer();
  addTearDown(container.dispose);
  
  final notifier = container.read(themeStateProvider.notifier);
  notifier.setThemeMode(ThemeMode.dark);
  
  expect(
    container.read(themeStateProvider),
    equals(ThemeMode.dark),
  );
});
```

### 2. Integration Tests
```dart
test('loads user data', () async {
  final container = ProviderContainer(
    overrides: [
      userServiceProvider.overrideWithValue(MockUserService()),
    ],
  );
  addTearDown(container.dispose);
  
  final future = container.read(userStateProvider.future);
  await expectLater(future, completes);
});
```

## Performance Guidelines

### 1. State Updates
- Minimize unnecessary rebuilds
- Use select() for granular watching
- Implement proper equality
- Cache computed values
- Dispose resources properly

### 2. Dependencies
- Watch only needed dependencies
- Use family modifiers for parameterization
- Implement proper scoping
- Handle autoDispose appropriately

## Review Checklist

Before implementing providers:
- [ ] Uses code generation
- [ ] Implements proper error handling
- [ ] Handles loading states
- [ ] Manages resources correctly
- [ ] Implements proper testing
- [ ] Documents state changes
- [ ] Handles dependencies properly
- [ ] Uses appropriate provider type
- [ ] Implements proper logging
- [ ] Manages lifecycle correctly
``` 