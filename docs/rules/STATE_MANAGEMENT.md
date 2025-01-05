# State Management Standards

## Provider Organization

### 1. Provider Types
```dart
// Simple value provider
final counterProvider = Provider<int>((ref) => 0);

// State notifier for complex state
final counterNotifierProvider = NotifierProvider<CounterNotifier, int>(CounterNotifier.new);

// Async data provider
final userDataProvider = FutureProvider.autoDispose<UserData>((ref) async {
  return await fetchUserData();
});

// Family provider for parameterized state
final userProvider = FutureProvider.family<User, String>((ref, userId) async {
  return await fetchUser(userId);
});
```

### 2. Provider Location
```
lib/
├── providers/
│   ├── core/              # App-wide providers
│   │   ├── auth/
│   │   ├── theme/
│   │   └── settings/
│   └── features/          # Feature-specific providers
│       ├── user/
│       ├── products/
│       └── orders/
```

## State Design

### 1. State Classes
```dart
// Use Freezed for immutable state
@freezed
class UserState with _$UserState {
  const factory UserState({
    required String id,
    required String name,
    @Default(false) bool isAdmin,
  }) = _UserState;
}

// Use sealed classes for union types
sealed class AsyncState<T> {
  const AsyncState();
}

final class AsyncData<T> extends AsyncState<T> {
  final T value;
  const AsyncData(this.value);
}

final class AsyncLoading<T> extends AsyncState<T> {
  const AsyncLoading();
}

final class AsyncError<T> extends AsyncState<T> {
  final Object error;
  final StackTrace? stackTrace;
  const AsyncError(this.error, [this.stackTrace]);
}
```

### 2. State Updates
```dart
// Atomic updates
state = state.copyWith(name: newName);

// Batch updates
state = state.copyWith(
  isLoading: false,
  error: null,
  data: newData,
);

// Conditional updates
state = state.copyWith(
  count: count > 0 ? count : state.count,
);
```

## Error Handling

### 1. Error States
```dart
// Include error in state
@freezed
class DataState<T> with _$DataState<T> {
  const factory DataState({
    T? data,
    String? error,
    @Default(false) bool isLoading,
  }) = _DataState;
}

// Handle errors in provider
final dataProvider = NotifierProvider<DataNotifier, DataState>((ref) {
  try {
    // ... logic
  } catch (e, stack) {
    return DataState(error: e.toString());
  }
});
```

### 2. Error Recovery
```dart
// Retry mechanism
final retryableProvider = FutureProvider.autoDispose((ref) async {
  try {
    return await fetchData();
  } catch (e) {
    ref.invalidateSelf();
    rethrow;
  }
});
```

## Performance

### 1. Caching
```dart
// Cache expensive computations
final expensiveProvider = Provider((ref) {
  return ref.cache(
    () => computeExpensiveValue(),
    name: 'expensiveComputation',
  );
});
```

### 2. Selective Updates
```dart
// Use select for granular updates
final nameProvider = Provider((ref) {
  return ref.watch(userProvider.select((user) => user.name));
});
```

## Testing

### 1. Provider Tests
```dart
test('provider updates correctly', () {
  final container = ProviderContainer();
  addTearDown(container.dispose);

  expect(container.read(counterProvider), 0);
  container.read(counterProvider.notifier).increment();
  expect(container.read(counterProvider), 1);
});
```

### 2. Mock Providers
```dart
// Create mock provider
final mockProvider = Provider((ref) => MockService());

// Override in tests
final container = ProviderContainer(
  overrides: [
    serviceProvider.overrideWithValue(mockService),
  ],
);
```

## Best Practices

### 1. Provider Dependencies
- Keep provider dependencies explicit
- Use ref.watch for reactive dependencies
- Use ref.read for one-time reads
- Document provider dependencies

### 2. State Granularity
- Split large state objects
- Use computed properties
- Keep state normalized
- Avoid redundant state

### 3. Lifecycle Management
- Use autoDispose when appropriate
- Clean up resources
- Handle state restoration
- Manage side effects

## Review Checklist

Before submitting state management changes:
- [ ] State is immutable
- [ ] Error handling implemented
- [ ] Tests written
- [ ] Dependencies documented
- [ ] Performance optimized
- [ ] Resources properly disposed
- [ ] Side effects managed
``` 