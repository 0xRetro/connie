# Data Access Objects (DAOs)

## Overview
DAOs provide a clean interface for database operations, abstracting the complexity of SQL queries and data manipulation.

## Location
`lib/database/daos/`

## Components

### AppDao
`app_dao.dart`

Primary DAO for core application operations.

#### Responsibilities
- Manage UI settings
- Handle plugin settings
- Process people data
- Maintain data integrity
- Handle batch operations

#### Key Methods
```dart
Future<void> updateUiSettings(UiSettingsCompanion settings);
Future<List<Person>> getAllPeople();
Future<void> updatePluginSettings(PluginSettingsCompanion settings);
```

### DynamicTableDao
`dynamic_table_dao.dart`

Handles dynamic table operations and schema management.

#### Responsibilities
- Create dynamic tables
- Manage table schemas
- Handle data migrations
- Process dynamic queries
- Maintain table metadata

#### Key Methods
```dart
Future<void> createTable(String tableName, List<ColumnDefinition> columns);
Future<List<Map<String, dynamic>>> queryTable(String tableName);
Future<void> dropTable(String tableName);
```

## Implementation Guidelines

### 1. Method Naming
```dart
// DO: Use clear, action-based names
Future<Person> getPerson(int id);
Future<void> updatePersonDetails(PersonCompanion details);

// DON'T: Use ambiguous names
Future<Person> person(int id);  // Wrong
Future<void> process(PersonCompanion details);  // Wrong
```

### 2. Error Handling
```dart
// DO: Use specific error types
Future<Person> getPerson(int id) async {
  try {
    return await (select(people)..where((p) => p.id.equals(id)))
        .getSingle();
  } on StateError {
    throw PersonNotFoundError(id);
  }
}

// DON'T: Swallow errors
Future<Person?> getPerson(int id) async {
  try {
    return await (select(people)..where((p) => p.id.equals(id)))
        .getSingle();
  } catch (_) {
    return null;  // Wrong - loses error context
  }
}
```

### 3. Transaction Management
```dart
// DO: Use transactions for multiple operations
Future<void> updatePersonWithSettings(
  PersonCompanion person,
  SettingsCompanion settings,
) async {
  await transaction(() async {
    await updatePerson(person);
    await updateSettings(settings);
  });
}

// DON'T: Perform multiple operations without transaction
Future<void> updatePersonWithSettings(  // Wrong
  PersonCompanion person,
  SettingsCompanion settings,
) async {
  await updatePerson(person);
  await updateSettings(settings);
}
```

### 4. Query Optimization
```dart
// DO: Use efficient queries
Future<List<Person>> getPeopleByIds(List<int> ids) async {
  return await (select(people)..where((p) => p.id.isIn(ids))).get();
}

// DON'T: Use inefficient queries
Future<List<Person>> getPeopleByIds(List<int> ids) async {  // Wrong
  final results = <Person>[];
  for (final id in ids) {
    results.add(await getPerson(id));
  }
  return results;
}
```

## Testing Requirements

### 1. Unit Tests
```dart
test('getPerson returns correct person', () async {
  final person = await dao.getPerson(1);
  expect(person.id, equals(1));
});

test('getPerson throws on invalid id', () async {
  expect(() => dao.getPerson(-1), throwsA(isA<PersonNotFoundError>()));
});
```

### 2. Integration Tests
```dart
test('updatePersonWithSettings maintains consistency', () async {
  await dao.updatePersonWithSettings(person, settings);
  
  final updatedPerson = await dao.getPerson(person.id);
  final updatedSettings = await dao.getSettings(person.id);
  
  expect(updatedPerson.version, equals(person.version + 1));
  expect(updatedSettings.personId, equals(person.id));
});
```

## Review Checklist

Before modifying DAOs:
- [ ] Methods follow naming conventions
- [ ] Proper error handling implemented
- [ ] Transactions used where needed
- [ ] Queries are optimized
- [ ] Tests are comprehensive
- [ ] Documentation is updated
- [ ] Migrations are handled
- [ ] Logging is appropriate
``` 