# Database Implementation

Core database implementation using Drift (SQLite) for local data persistence, with comprehensive health monitoring, backup management, and environment-specific configurations.

## File Location
`lib/database/database.dart`

## Key Patterns & Principles
- Uses thread-safe singleton pattern with lazy initialization
- Implements Drift ORM for SQLite operations
- Provides comprehensive health monitoring and metrics
- Uses migration strategy pattern for schema updates
- Implements environment-based configuration
- Follows single responsibility principle
- Uses Data Access Objects (DAOs) for data access
- Implements testability hooks
- Provides backup/restore functionality
- Uses PRAGMA optimizations

## Responsibilities

### Does:
- Manage database connections and lifecycle
- Handle database migrations and schema changes
- Monitor database health and metrics
- Configure environment-specific settings
- Provide DAO-based data access
- Create and restore backups
- Initialize default data
- Verify connection health
- Manage transactions
- Handle cleanup operations
- Track initialization state

### Does Not:
- Handle business logic
- Manage application state
- Process data transformations
- Handle UI interactions
- Manage error display
- Configure services
- Handle table operations directly
- Process network requests
- Define validation rules

## Component Connections
- [x] Database Layer
  - [x] Table Definitions
  - [x] DAOs
  - [x] Migrations
  - [x] Backup System
- [x] Config Layer
  - [x] Environment
  - [x] Logger
  - [x] Storage
- [x] Service Layer
  - [x] Database Service
  - [x] Logger Service
  - [x] Initialization Service
- [x] State Layer
  - [x] Tables
  - [x] DAOs
  - [x] Health Metrics
- [x] Util Layer
  - [x] File System
  - [x] Metrics
  - [x] Testing

## Execution Pattern
- [x] Has Initialization Order
  1. Connection setup
  2. Environment configuration
  3. Migration check
  4. Schema verification
  5. Foreign key setup
  6. Default data creation
  7. Health check
  8. Metrics collection
  9. Backup directory setup (if needed)

## Dependencies
- `drift`: Database ORM and operations
- `drift/native`: Native SQLite implementation
- `path_provider`: File system access
- `path`: Path manipulation
- `meta`: Additional annotations
- `environment.dart`: Configuration
- `logger_service.dart`: Logging
- Database tables and DAOs

## Integration Points
- `database_service.dart`: Primary service consumer
- `environment.dart`: Configuration management
- `initialization_service.dart`: Startup sequence
- `logger_service.dart`: Logging system
- Database tables: Schema definitions
- Database DAOs: Data access patterns

## Additional Details

### Database Structure
```dart
@DriftDatabase(
  tables: [
    PeopleTable,
    UiSettingsTable,
    PluginSettingsTable,
  ],
  daos: [
    AppDao,
    DynamicTableDao,
  ],
)
```

### Configuration
```dart
// Environment-specific settings
await customStatement(
  'PRAGMA max_page_count = ${config['maxConnections']}',
);
await customStatement(
  'PRAGMA cache_size = ${config['enableCache'] ? -2000 : -1000}',
);
```

### Health Monitoring
Metrics tracked:
- Database size and version
- Schema version compatibility
- Table count and integrity
- Connection health status
- Page and cache metrics
- Default data presence
- Migration status
- Backup status

### Backup Management
Features:
```dart
Future<File> backup() async {
  // Automatic backup directory creation
  // Timestamped backups
  // VACUUM INTO optimization
  // Backup size tracking
  // Backup verification
}

Future<void> restoreFromBackup(File backupFile) async {
  // Safe restore process
  // Connection management
  // Database reinitialization
}
```

### Migration Strategy
```dart
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (m) async {
    // Initial schema creation
    // Default data setup
  },
  onUpgrade: (m, from, to) async {
    // Version-specific migrations
  },
  beforeOpen: (details) async {
    // Pre-open validations
    // Foreign key setup
  },
);
```

### Testing Support
- Separate test database creation
- In-memory database support
- Connection verification
- Data cleanup utilities
- Metric collection
- Health checks
- Backup testing

### Error Handling
- Connection failures
- Migration errors
- Backup/restore errors
- Health check failures
- Schema validation errors
- Foreign key violations
- Transaction failures

## Review Checklist

Before modifying database implementation:
- [ ] Follows singleton pattern
- [ ] Implements proper error handling
- [ ] Includes health monitoring
- [ ] Manages resources correctly
- [ ] Handles migrations properly
- [ ] Implements backup strategy
- [ ] Includes proper testing
- [ ] Documents schema changes
``` 
</rewritten_file>