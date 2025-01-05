# Database Service

## Overview
The Database Service provides a high-level interface for database operations, managing the lifecycle of the database connection, and coordinating data access across the application.

## Location
`lib/services/database_service.dart`

## Responsibilities

### Primary
- Database initialization and configuration
- Connection lifecycle management
- Transaction coordination
- Error handling and recovery
- Migration management
- Health monitoring
- Backup coordination

### Secondary
- Performance optimization
- Resource cleanup
- State management
- Event dispatching
- Logging coordination

## Implementation

### 1. Service Definition
```dart
@riverpod
class DatabaseService extends _$DatabaseService {
  late final AppDatabase _db;
  late final LoggerService _logger;
  
  @override
  Future<void> build() async {
    await _initialize();
  }
}
```

### 2. Initialization
```dart
Future<void> _initialize() async {
  try {
    _db = await _createDatabase();
    await _configureDatabase();
    await _verifyConnection();
  } catch (e, st) {
    _logger.error('Database initialization failed', e, st);
    rethrow;
  }
}
```

### 3. Configuration
```dart
Future<void> _configureDatabase() async {
  await _db.customStatement('''
    PRAGMA foreign_keys = ON;
    PRAGMA journal_mode = WAL;
    PRAGMA synchronous = NORMAL;
  ''');
}
```

### 4. Transaction Management
```dart
Future<T> transaction<T>(Future<T> Function() action) async {
  try {
    return await _db.transaction(action);
  } catch (e, st) {
    _logger.error('Transaction failed', e, st);
    rethrow;
  }
}
```

## Usage Patterns

### 1. Basic Operations
```dart
// DO: Use service for database operations
final db = ref.read(databaseServiceProvider);
await db.transaction(() async {
  await userDao.updateUser(user);
});

// DON'T: Access database directly
final database = AppDatabase();  // Wrong
await database.updateUser(user);
```

### 2. Error Handling
```dart
// DO: Handle specific database errors
try {
  await db.transaction(() async {
    await userDao.createUser(user);
  });
} on SqliteException catch (e) {
  if (e.isUniqueConstraintError) {
    throw UserAlreadyExistsError(user.email);
  }
  rethrow;
}

// DON'T: Catch generic exceptions
try {
  await db.transaction(() async {
    await userDao.createUser(user);
  });
} catch (e) {  // Wrong - too broad
  print(e);
}
```

### 3. Resource Management
```dart
// DO: Clean up resources
@override
void dispose() {
  _db.close();
  super.dispose();
}

// DO: Handle connection issues
Future<void> _verifyConnection() async {
  try {
    await _db.customSelect('SELECT 1').get();
  } catch (e) {
    await _handleConnectionError(e);
  }
}
```

## Event Handling

### 1. Database Events
```dart
// DO: Dispatch database events
void _onDatabaseError(DatabaseError error) {
  ref.read(errorHandlerProvider.notifier).handleDatabaseError(error);
}

// DO: Listen for database events
@override
void didUpdateProvider(DatabaseEvent event) {
  if (event is DatabaseErrorEvent) {
    _onDatabaseError(event.error);
  }
}
```

### 2. State Updates
```dart
// DO: Notify state changes
Future<void> clearData() async {
  await _db.transaction(() async {
    await _db.delete(users).go();
    ref.invalidate(userListProvider);
  });
}
```

## Performance Guidelines

### 1. Connection Management
```dart
// DO: Reuse connections
late final AppDatabase _db;

// DON'T: Create multiple connections
AppDatabase _getDatabase() {  // Wrong
  return AppDatabase();
}
```

### 2. Query Optimization
```dart
// DO: Use efficient queries
Future<List<User>> getUsers() async {
  return _db.transaction(() async {
    return await (select(users)
      ..orderBy([
        (u) => OrderingTerm(
          expression: u.id,
          mode: OrderingMode.desc,
        ),
      ])
      ..limit(50))
        .get();
  });
}

// DON'T: Load unnecessary data
Future<List<User>> getUsers() async {  // Wrong
  final allUsers = await select(users).get();
  return allUsers.take(50).toList();
}
```

## Testing Requirements

### 1. Unit Tests
```dart
test('database service initializes correctly', () async {
  final service = await ref.read(databaseServiceProvider.future);
  expect(service, isNotNull);
});

test('transaction handles errors', () async {
  final service = await ref.read(databaseServiceProvider.future);
  
  expect(
    () => service.transaction(() => throw Exception()),
    throwsException,
  );
});
```

### 2. Integration Tests
```dart
test('service manages resources properly', () async {
  final service = await ref.read(databaseServiceProvider.future);
  
  await service.transaction(() async {
    await userDao.createUser(user);
  });
  
  service.dispose();
  
  expect(
    () => service.transaction(() => null),
    throwsStateError,
  );
});
```

## Review Checklist

Before modifying the database service:
- [ ] Follows singleton pattern
- [ ] Implements proper error handling
- [ ] Manages resources correctly
- [ ] Uses efficient queries
- [ ] Handles transactions properly
- [ ] Includes comprehensive tests
- [ ] Documents API changes
- [ ] Implements proper logging
``` 