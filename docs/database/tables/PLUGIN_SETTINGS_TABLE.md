# Plugin Settings Table

Manages plugin-specific settings and configurations in the database.

## File Location
`lib/database/tables/plugin_settings_table.dart`

## Key Patterns & Principles
- Uses Drift for table definition
- Implements data validation
- Follows SQLite constraints
- Uses text columns for flexibility
- Implements soft deletion
- Tracks record timestamps
- Enforces data integrity

## Responsibilities
Does:
- Store plugin settings
- Validate setting entries
- Track creation time
- Track update time
- Manage soft deletion
- Enforce constraints
- Provide unique IDs

Does Not:
- Handle plugin logic
- Manage plugin state
- Process settings
- Handle migrations
- Validate plugin existence
- Store plugin binaries
- Manage plugin lifecycle

## Component Connections
- [x] Database Layer
  - [x] Database Service
  - [x] Migration Service
  - [x] Health Checks
- [x] Plugin Layer
  - [x] Plugin Manager
  - [x] Settings Provider
  - [x] Plugin State
- [x] Service Layer
  - [x] Settings Service
  - [x] Validation Service
  - [x] Logger Service

## Schema Details
- `id`: Auto-incrementing primary key
- `pluginName`: Non-empty plugin identifier
- `settingsKey`: Non-empty setting name
- `settingsValue`: Setting value (can be empty)
- `createdAt`: Creation timestamp
- `updatedAt`: Last update timestamp
- `isDeleted`: Soft deletion flag

## Constraints
- Plugin name must be non-empty
- Settings key must be non-empty
- Composite uniqueness on (pluginName, settingsKey)
- Soft deletion enabled by default
- Timestamps required for tracking

## Additional Details

### Data Validation
- Length checks on plugin name
- Length checks on settings key
- Value format validation
- Timestamp formatting
- Deletion state checks

### Usage Examples
```dart
// Insert setting
await into(pluginSettingsTable).insert(
  PluginSettingsCompanion.insert(
    pluginName: 'my_plugin',
    settingsKey: 'theme',
    settingsValue: 'dark'
  )
);

// Query setting
final setting = await (select(pluginSettingsTable)
  ..where((t) => t.pluginName.equals('my_plugin'))
  ..where((t) => t.settingsKey.equals('theme'))
).getSingleOrNull();
```

### Testing Support
- Table creation tests
- Constraint validation
- Data integrity checks
- Migration testing
- Query validation 