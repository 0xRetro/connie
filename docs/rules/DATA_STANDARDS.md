# Data Standards and Management

## Data Layer Architecture

### 1. Layer Structure
```
lib/
├── database/              # Database implementation
│   ├── daos/             # Data Access Objects
│   │   ├── app_dao.dart  # Core application data
│   │   └── dynamic_table_dao.dart # Dynamic tables
│   ├── tables/           # Table definitions
│   │   ├── people_table.dart
│   │   ├── ui_settings_table.dart
│   │   └── plugin_settings_table.dart
│   └── database.dart     # Core database setup
├── providers/            # Riverpod providers
│   ├── people_provider.dart
│   └── settings_provider.dart
├── services/
│   └── database_service.dart # Service layer
└── config/
    └── database_config.dart  # Database configuration
```

### 2. Data Flow Pattern
```
UI Layer → Provider → Service → DAO → Database
↑                                      ↓
UI ← Provider ← Service ← DAO ← Database
```

### 3. Provider Pattern
```dart
// DO: Use Riverpod providers for data access
@riverpod
class PeopleNotifier extends _$PeopleNotifier {
  @override
  Future<List<Person>> build() => 
    ref.watch(databaseProvider).appDao.getAllPeople();

  Future<void> createPerson(String name) async {
    final db = ref.read(databaseProvider);
    await db.appDao.createPerson(
      PersonCompanion.insert(
        name: name,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    ref.invalidateSelf();
  }
}

// DON'T: Access database directly from UI
final people = database.select(peopleTable).get(); // Wrong

// DO: Use provider in UI
final people = ref.watch(peopleNotifierProvider);
```

## Data Access Patterns

### 1. Read Operations
```dart
// DO: Use DAOs for data access
final user = await userDao.getUser(id);

// DO: Use transactions for multiple operations
await database.transaction(() async {
  final user = await userDao.getUser(id);
  final settings = await settingsDao.getUserSettings(id);
  return UserWithSettings(user, settings);
});

// DON'T: Access database directly from UI or service layer
final user = await database.select(users).getSingle(); // Wrong
```

### 2. Write Operations
```dart
// DO: Use atomic operations
await userDao.updateUser(
  UserCompanion(
    id: Value(id),
    updatedAt: Value(DateTime.now()),
  ),
);

// DO: Validate before write
Future<void> updateUser(User user) async {
  if (!user.isValid) throw ValidationError();
  await userDao.updateUser(user);
}

// DON'T: Perform multiple writes without transaction
await userDao.updateUser(user);  // Wrong
await settingsDao.updateSettings(settings);  // Wrong
```

## Data Models

### 1. Table Definitions
```dart
// DO: Include standard fields
@DataClassName('Person')
class PeopleTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

// DON'T: Skip standard fields
class BadTable extends Table {  // Wrong
  IntColumn get id => integer().autoIncrement()();
  TextColumn get data => text()();
}
```

### 2. Data Validation
```dart
// DO: Implement validation rules
class Person {
  final String name;
  
  bool get isValid => name.isNotEmpty;
  
  Person.validate(this.name) {
    if (!isValid) throw ValidationError();
  }
}

// DON'T: Skip validation
await userDao.insertPerson(person); // Wrong - no validation
```

## Data Lifecycle

### 1. Creation
- Always include creation timestamp
- Validate data before insertion
- Use transactions for related data
- Initialize with default values
- Log creation events

### 2. Updates
- Always update timestamp
- Validate changes
- Maintain data integrity
- Use optimistic locking
- Track modification history

### 3. Deletion
- Use soft deletes (isDeleted flag)
- Maintain referential integrity
- Clean up related data
- Archive if necessary
- Log deletion events

## Error Handling

### 1. Database Errors
```dart
// DO: Handle specific database errors
try {
  await userDao.createUser(user);
} on SqliteException catch (e) {
  if (e.isUniqueConstraintError) {
    throw UserAlreadyExistsError();
  }
  rethrow;
}

// DON'T: Catch generic exceptions
try {
  await userDao.createUser(user);
} catch (e) {  // Wrong - too broad
  print(e);
}
```

### 2. Validation Errors
```dart
// DO: Use specific validation errors
class ValidationError extends Error {
  final String field;
  final String message;
  
  ValidationError(this.field, this.message);
}

// DO: Validate at appropriate layer
class UserService {
  Future<void> createUser(User user) async {
    if (!user.isValid) {
      throw ValidationError('user', 'Invalid user data');
    }
    await _dao.createUser(user);
  }
}
```

## Data Migration

### 1. Schema Updates
```dart
// DO: Use version-based migrations
@DriftDatabase(version: 2)
class AppDatabase {
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(users, users.email);
      }
    },
  );
}
```

### 2. Data Migration
```dart
// DO: Migrate data safely
Future<void> migrateUserData() async {
  await transaction(() async {
    final users = await select(users).get();
    for (final user in users) {
      // Migrate each user safely
      await update(users).write(
        UsersCompanion(
          newField: Value(computeNewValue(user)),
        ),
      );
    }
  });
}
```

## Performance Guidelines

### 1. Query Optimization
```dart
// DO: Use indexed fields
@DataClassName('Person')
class PeopleTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get email => text().withLength(max: 255)();
  
  @override
  List<Set<Column>> get indexes => [
    {email},
  ];
}

// DON'T: Perform expensive operations in loops
for (final id in ids) {  // Wrong
  final user = await userDao.getUser(id);
}

// DO: Use batch operations
final users = await userDao.getUsersByIds(ids);
```

### 2. Caching Strategy
```dart
// DO: Implement appropriate caching
class UserRepository {
  final UserDao _dao;
  final Cache<User> _cache;
  
  Future<User?> getUser(int id) async {
    return _cache.get(id) ?? await _dao.getUser(id);
  }
}
```

## Testing Requirements

### 1. Unit Tests
```dart
test('creates user with timestamp', () async {
  final user = await userDao.createUser(
    UserCompanion.insert(name: 'Test'),
  );
  
  expect(user.createdAt, isNotNull);
  expect(user.updatedAt, equals(user.createdAt));
});
```

### 2. Integration Tests
```dart
test('updates related data in transaction', () async {
  await database.transaction(() async {
    final user = await userDao.createUser(companion);
    final settings = await settingsDao.createSettings(user.id);
    
    expect(settings.userId, equals(user.id));
  });
});
```

## Review Checklist

Before implementing data changes:
- [ ] Follows data access patterns
- [ ] Implements proper validation
- [ ] Uses appropriate error handling
- [ ] Includes standard fields
- [ ] Handles migrations properly
- [ ] Optimizes for performance
- [ ] Includes proper tests
- [ ] Documents data model
- [ ] Implements proper logging
- [ ] Handles transactions correctly

## UI Integration

### 1. Create Operations
```dart
// DO: Use dialog or dedicated screen for data entry
void showCreatePersonDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) => PersonFormDialog(
      onSubmit: (name, isSuperUser) async {
        await ref.read(peopleNotifierProvider.notifier)
          .createPerson(name, isSuperUser: isSuperUser);
        Navigator.of(context).pop();
      },
    ),
  );
}

// DON'T: Create data without validation
onPressed: () => ref.read(peopleNotifierProvider.notifier)
  .createPerson(nameController.text); // Wrong - no validation
```

### 2. Update Operations
```dart
// DO: Pre-fill form with existing data
void showEditPersonDialog(BuildContext context, WidgetRef ref, Person person) {
  showDialog(
    context: context,
    builder: (context) => PersonFormDialog(
      initialName: person.name,
      initialIsSuperUser: person.isSuperUser,
      onSubmit: (name, isSuperUser) async {
        await ref.read(peopleNotifierProvider.notifier)
          .updatePerson(person.copyWith(
            name: name,
            isSuperUser: isSuperUser,
          ));
        Navigator.of(context).pop();
      },
    ),
  );
}

// DON'T: Update without optimistic UI
onPressed: () async {
  await ref.read(peopleNotifierProvider.notifier)
    .updatePerson(person); // Wrong - no loading state
}
```

### 3. Delete Operations
```dart
// DO: Confirm destructive operations
void showDeleteConfirmation(BuildContext context, WidgetRef ref, Person person) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Delete ${person.name}?'),
      content: Text('This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await ref.read(peopleNotifierProvider.notifier)
              .deletePerson(person.id);
            Navigator.of(context).pop();
          },
          child: Text('Delete'),
        ),
      ],
    ),
  );
}

// DON'T: Delete without confirmation
onPressed: () => ref.read(peopleNotifierProvider.notifier)
  .deletePerson(id); // Wrong - no confirmation
```

### 4. Loading & Error States
```dart
// DO: Handle async states properly
Widget build(BuildContext context, WidgetRef ref) {
  final dataAsync = ref.watch(peopleNotifierProvider);
  
  return dataAsync.when(
    loading: () => CircularProgressIndicator(),
    error: (error, stack) => ErrorDisplay(error: error),
    data: (data) => DataList(items: data),
  );
}

// DON'T: Ignore loading or error states
final data = ref.watch(peopleNotifierProvider).value; // Wrong
``` 