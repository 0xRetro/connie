# Database Tables

## Overview
Database tables define the schema and structure for data storage using Drift (SQLite).

## Location
`lib/database/tables/`

## Core Tables

### PeopleTable
`people_table.dart`

Stores information about people in the system.

#### Schema
```dart
@DataClassName('Person')
class PeopleTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}
```

### UiSettingsTable
`ui_settings_table.dart`

Manages UI-related settings and preferences.

#### Schema
```dart
@DataClassName('UiSettings')
class UiSettingsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();
}
```

### PluginSettingsTable
`plugin_settings_table.dart`

Stores configuration for plugins and extensions.

#### Schema
```dart
@DataClassName('PluginSettings')
class PluginSettingsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get pluginId => text()();
  TextColumn get settings => text()();
  DateTimeColumn get updatedAt => dateTime()();
}
```

## Implementation Guidelines

### 1. Table Definition
```dart
// DO: Include standard columns
@DataClassName('MyTable')
class MyTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

// DON'T: Skip standard columns
class MyTable extends Table {  // Wrong
  IntColumn get id => integer().autoIncrement()();
  TextColumn get data => text()();
}
```

### 2. Column Constraints
```dart
// DO: Use appropriate constraints
TextColumn get email => text().withLength(min: 3, max: 255)();
IntColumn get age => integer().check(age.isBetween(0, 150))();

// DON'T: Skip constraints
TextColumn get email => text()();  // Wrong
IntColumn get age => integer()();  // Wrong
```

### 3. Indexes
```dart
// DO: Define indexes for frequently queried columns
@override
List<Set<Column>> get indexes => [
  {email},
  {createdAt, isDeleted},
];

// DO: Use unique constraints where appropriate
TextColumn get email => text().withLength(max: 255).unique()();
```

### 4. Foreign Keys
```dart
// DO: Use foreign keys for relationships
IntColumn get userId => integer().references(Users, #id)();

// DO: Handle cascading
IntColumn get userId => integer()
  .references(Users, #id, 
    onDelete: KeyAction.cascade,
    onUpdate: KeyAction.cascade,
  )();
```

## Data Types

### 1. Text Fields
```dart
// Fixed length
TextColumn get code => text().withLength(exactly: 8)();

// Variable length with limits
TextColumn get name => text().withLength(min: 1, max: 100)();

// Optional text
TextColumn get description => text().nullable()();
```

### 2. Numeric Fields
```dart
// Auto-incrementing ID
IntColumn get id => integer().autoIncrement()();

// Regular integer
IntColumn get count => integer()();

// Decimal/Real
RealColumn get price => real().check(price.isBiggerThan(0))();
```

### 3. Boolean Fields
```dart
// With default
BoolColumn get isActive => boolean().withDefault(const Constant(true))();

// Required boolean
BoolColumn get isVerified => boolean()();
```

### 4. Date/Time Fields
```dart
// Current timestamp
DateTimeColumn get createdAt => dateTime()
  .withDefault(currentDateAndTime)();

// Nullable timestamp
DateTimeColumn get deletedAt => dateTime().nullable()();
```

## Migration Support

### 1. Version Control
```dart
@DriftDatabase(
  tables: [MyTable],
  version: 2,
)
```

### 2. Schema Changes
```dart
// Adding columns
await m.addColumn(myTable, myTable.newColumn);

// Removing columns
await m.dropColumn(myTable, myTable.oldColumn);

// Renaming tables
await m.renameTable(oldTable, newTable);
```

## Testing Requirements

### 1. Schema Tests
```dart
test('table has required columns', () {
  final table = MyTable();
  expect(table.id, isNotNull);
  expect(table.createdAt, isNotNull);
  expect(table.updatedAt, isNotNull);
});
```

### 2. Constraint Tests
```dart
test('email column has correct constraints', () {
  final table = MyTable();
  final email = table.email;
  
  expect(email.isUnique, isTrue);
  expect(email.maxLength, equals(255));
});
```

## Review Checklist

Before modifying tables:
- [ ] Includes standard columns (id, timestamps, isDeleted)
- [ ] Uses appropriate data types
- [ ] Implements necessary constraints
- [ ] Defines required indexes
- [ ] Handles relationships properly
- [ ] Includes migration strategy
- [ ] Has comprehensive tests
- [ ] Documents schema changes
``` 