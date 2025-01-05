# Connie AI Assistant Project Roadmap

## Current Focus: Database Implementation

### Phase 1: Database Structure Reorganization
- [x] Create new directory structure
- [x] Update pubspec.yaml with latest dependencies
- [x] Configure build.yaml for drift
- [x] Configure development tools
- [x] Implement consistent naming conventions for tables and models:
  - [x] `@DataClassName` annotations
  - [x] Companion class naming
  - [x] Generated file structure
- [x] Create and configure database tables:
  - [x] `PeopleTable` with `@DataClassName('Person')`
  - [x] `UiSettingsTable` with `@DataClassName('UiSetting')`
  - [x] `PluginSettingsTable` with `@DataClassName('PluginSetting')`
- [x] Set up proper library directives and part files
- [x] Successfully generate Drift files

### Remaining Tasks for Phase 1:
- [x] Complete database tests:
  - [x] Update test files with correct companion class names
  - [x] Add missing test cases
  - [x] Verify error handling
- [ ] Set up CI/CD pipeline:
  - [ ] Automated testing
  - [ ] Build verification
  - [ ] Migration testing
  - [ ] Platform compatibility checks
- [x] Verify all database operations:
   - [x] CRUD operations for all tables
   - [x] Dynamic table management
   - [x] Migration handling
   - [x] Error handling and logging
   - [x] Health checks and metrics

### Phase 2: Model Implementation
- [x] Create data models with Freezed:
  - [x] `models/people.dart`: Person data model
  - [x] `models/ui_settings.dart`: UI settings model
  - [x] `models/plugin_settings.dart`: Plugin settings model
- [x] Add proper annotations for JSON serialization
- [x] Generate model code with build_runner

### Phase 3: Database Access Layer
- [x] Create DAO files:
  - [x] `daos/app_dao.dart`: Basic CRUD operations
  - [x] `daos/dynamic_table_dao.dart`: Dynamic table management
- [x] Add proper annotations and documentation
- [x] Implement type-safe queries
- [x] Add transaction support

### Phase 3a: Table Definitions
- [x] Move table definitions to separate files:
  - [x] `tables/people_table.dart`:
    ```dart
    @DataClassName('PeopleTableData')
    class PeopleTable extends Table {
      // Existing columns...
    }
    ```
  - [x] `tables/ui_settings_table.dart`
  - [x] `tables/plugin_settings_table.dart`
- [x] Add proper Drift annotations
- [x] Add table documentation

### Phase 3b: Initialization Infrastructure
-  [  ] Create initialization sequence:
  ```
  lib/services/
  ├── initialization/
  │   ├── database_initializer.dart    # Core initialization logic
  │   │   ├── checkSQLiteSetup()      # Verify SQLite installation
  │   │   ├── validateDatabase()       # Check DB health
  │   │   └── initializeDatabase()     # Setup/upgrade DB
  │   │
  │   ├── first_run_handler.dart       # First-run management
  │   │   ├── isFirstRun()            # Check if first launch
  │   │   ├── createInitialDb()       # Create new database
  │   │   └── setupDefaults()         # Set default values
  │   │
  │   ├── schema_validator.dart        # Schema management
  │   │   ├── validateSchema()        # Check table structure
  │   │   ├── checkConstraints()      # Verify constraints
  │   │   └── validateIndexes()       # Check indexes
  │   │
  │   ├── health_checker.dart         # Database health
  │   │   ├── checkCorruption()       # Detect corruption
  │   │   ├── validateIntegrity()     # Check data integrity
  │   │   └── repairDatabase()        # Attempt repairs
  │   │
  │   └── recovery_manager.dart       # Recovery handling
  │       ├── backupDatabase()        # Create backup
  │       ├── attemptRepair()         # Try to fix issues
  │       └── recreateDatabase()      # Fresh database
  ```

- [x] Implement database validation:
  - [x] SQLite availability check
  - [x] Database file verification
  - [x] Schema version validation
  - [x] Table structure verification
  - [x] Index health check
  - [x] Constraint validation

- [x] Implement first-run detection:
  - [x] Check for existing database
  - [x] Create initial tables
  - [x] Set up default configurations
  - [x] Create admin user
  - [x] Initialize settings

- [ ] Add health management:
  - [ ] Corruption detection
  - [ ] Data integrity checks
  - [ ] Foreign key validation
  - [ ] Index verification
  - [ ] Performance metrics collection

- [ ] Implement recovery system:
  - [ ] Automatic backup before repairs
  - [ ] Multiple repair strategies
  - [ ] Clean database recreation
  - [ ] Data migration utilities
  - [ ] Recovery logging

- [ ] Add user interface components:
  - [ ] Initialization progress indicator
  - [ ] Error message handling
  - [ ] Recovery option dialogs
  - [ ] First-run setup wizard
  - [ ] Database health status

- [x] Add initialization order management:
  - [x] Pre-database checks
  - [x] Platform-specific initialization
  - [x] Database setup/validation
  - [x] Post-initialization checks
  - [x] Error recovery handling

- [x] Implement logging and monitoring:
  - [x] Initialization process logging
  - [x] Error tracking
  - [x] Performance metrics
  - [x] Recovery attempt logging
  - [x] Health check results

### Phase 3c: Dynamic Table Management
- [ ] Create dynamic table infrastructure:
  ```
  lib/database/
  ├── dynamic/
  │   ├── table_manager.dart     # Core table management logic
  │   ├── column_manager.dart    # Column operations
  │   ├── schema_validator.dart  # Schema validation
  │   └── types/
  │       ├── column_type.dart   # Supported column types
  │       └── table_schema.dart  # Table schema definition
  ```
- [ ] Implement core functionality:
  - [ ] Dynamic table creation
  - [ ] Column addition/modification
  - [ ] Schema validation
  - [ ] Type safety checks
  - [ ] Migration support for dynamic tables
- [ ] Implement versioning system:
  - [ ] Track schema versions
  - [ ] Store migration history
  - [ ] Version compatibility checks
  - [ ] Rollback points

- [ ] Create table management service:
  ```dart
  lib/services/table_management_service.dart
  ```
  - [ ] Table CRUD operations
  - [ ] Column CRUD operations
  - [ ] Schema validation
  - [ ] Error handling
  - [ ] Event notifications

- [ ] Add persistence layer:
  ```
  lib/database/tables/
  ├── meta_tables/
  │   ├── table_definitions.dart  # Stores table metadata
  │   ├── column_definitions.dart # Stores column metadata
  │   └── schema_versions.dart    # Tracks schema changes
  ```

- [ ] Implement safety features:
  - [ ] Schema validation
  - [ ] Data preservation during changes
  - [ ] Rollback support
  - [ ] Constraint checking
  - [ ] Reference integrity

- [ ] Add integration points:
  - [ ] UI builders for dynamic tables
  - [ ] Schema change notifications
  - [ ] Data migration utilities
  - [ ] Plugin system hooks

### Phase 3c: Migration Infrastructure
- [ ] Create backup system:
  ```
  lib/database/
  ├── backup/
  │   ├── backup_service.dart
  │   ├── restore_service.dart
  │   └── verification_service.dart
```
- [ ] Implement backup features:
  - [ ] Pre-migration backups
  - [ ] Incremental backups
  - [ ] Backup verification
  - [ ] Automated restore testing
- [ ] Add audit logging:
  - [ ] Track schema changes
  - [ ] Log migration operations
  - [ ] Record backup/restore events
  - [ ] Monitor critical operations

### Phase 4a: Initialization Infrastructure
- [ ] Create initialization sequence:
  ```
  lib/services/
  ├── initialization/
  │   ├── database_initializer.dart    # Database-specific init
  │   ├── first_run_handler.dart       # First-run setup
  │   └── schema_validator.dart        # Initial schema validation
  ```
- [ ] Add platform-specific SQLite initialization:
  - [ ] Windows: Check and load SQLite DLL
  - [ ] Linux: Verify SQLite shared libraries
  - [ ] Android: Verify NDK compatibility
  - [ ] iOS: Verify SQLite framework
  - [ ] Add platform detection utilities
  - [ ] Implement graceful fallbacks
  - [ ] Add error handling for missing dependencies
- [ ] Implement first-run detection:
  - [ ] Check AppPreferences for first run
  - [ ] Create initial tables
  - [ ] Set up default configurations
  - [ ] Initialize meta tables
- [ ] Add initialization order management:
  - [ ] Pre-database checks
  - [ ] Database initialization
  - [ ] Post-initialization validation

### Phase 4b: DAO Implementation
- [ ] Create separate DAO files:
  - [ ] `daos/app_dao.dart`: Basic CRUD operations
  - [ ] `daos/dynamic_table_dao.dart`: Dynamic table management
- [ ] Add proper annotations and documentation
- [ ] Implement type-safe queries
- [ ] Add transaction support

### Phase 5: Database Configuration
- [ ] Update main database file:
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
- [ ] Implement proper singleton pattern
- [ ] Add environment-specific configuration
- [ ] Add migration strategies
- [ ] Implement connection pooling
- [ ] Add health checks and metrics
- [ ] Create database configuration files:
  ```
  lib/config/
  ├── database_config.dart    # Database-specific configuration
  └── connection_config.dart  # Connection pool settings
  ```
- [ ] Add configuration for:
  - [ ] Query logging
  - [ ] Cache settings
  - [ ] Connection timeouts
  - [ ] Retry policies
  - [ ] Migration settings

### Phase 5c: Migration Infrastructure
- [ ] Create migration management system:
  ```
  lib/database/
  ├── migrations/
  │   ├── manager/
  │   │   ├── migration_executor.dart
  │   │   ├── version_manager.dart
  │   │   └── rollback_manager.dart
  │   └── versions/
  │       ├── base_migration.dart
  │       └── migrations/
  │           ├── v1_initial.dart
  │           └── v2_dynamic_tables.dart
  ```
- [ ] Implement migration features:
  - [ ] Version tracking in meta tables
  - [ ] Automatic migration detection
  - [ ] Safe rollback capabilities
  - [ ] Data preservation strategies
  - [ ] Migration validation
- [ ] Add migration testing:
  - [ ] Migration path testing
  - [ ] Rollback testing
  - [ ] Data integrity verification

### Phase 6: Environment Configuration
- [ ] Add database-specific environment settings:
  ```dart
  // environment.dart
  static Map<String, dynamic> get databaseConfig => switch (name) {
    'production' => {
      'maxConnections': 10,
      'enableCache': true,
      'logQueries': false,
    },
    _ => {
      'maxConnections': 5,
      'enableCache': false,
      'logQueries': true,
    },
  };
  ```

### Phase 7: Service Integration
- [ ] Update DatabaseService to use new structure
- [ ] Update InitializationService for proper database init
- [ ] Add proper error handling and logging
- [ ] Implement connection management
- [ ] Add metrics collection
- [ ] Integrate dynamic table management:
  - [ ] Schema change detection
  - [ ] Automatic migration generation
  - [ ] Plugin system integration
  - [ ] UI update notifications
  - [ ] Data validation
- [ ] Add table management API:
  ```dart
  // Example API
  Future<void> createTable({
    required String name,
    required List<ColumnDefinition> columns,
    TableOptions? options,
  });
  
  Future<void> alterTable({
    required String name,
    List<ColumnModification>? columnChanges,
    TableModification? tableChanges,
  });
  ```
- [ ] Add safety middleware:
  - [ ] Schema validation
  - [ ] Data preservation
  - [ ] Reference checking
  - [ ] Type safety
  - [ ] Migration generation
- [ ] Update InitializationService:
  - [ ] Proper database initialization order
  - [ ] Integration with AppPreferences
  - [ ] First-run detection
  - [ ] Migration checks
- [ ] Integrate with existing services:
  - [ ] Use DatabaseService for lifecycle management
  - [ ] Use InitializationService for coordination

### Phase 8: Code Generation
- [ ] Run build_runner commands in order:
  ```bash
  flutter clean
  flutter pub get
  flutter pub run build_runner clean
  flutter pub run build_runner build --delete-conflicting-outputs
  ```

### Phase 9: Testing & Documentation
- [ ] Add unit tests for models
- [ ] Add integration tests for DAOs
- [ ] Update documentation:
  - [ ] DATABASE.md
  - [ ] DATABASE_SERVICE.md
  - [ ] API documentation
  - [ ] Example usage
- [ ] Add comprehensive test suite:
  - [ ] Unit tests:
    - [ ] Table operations
    - [ ] Migration paths
    - [ ] Error conditions
  - [ ] Integration tests:
    - [ ] Service interactions
    - [ ] Data consistency
    - [ ] Performance benchmarks
  - [ ] Platform-specific tests:
    - [ ] iOS/Android specific
    - [ ] Desktop specific
    - [ ] Web platform support

### Phase 10: UI Integration
- [ ] Update existing screens to use new database structure
- [ ] Add loading and error states
- [ ] Implement proper state management with Riverpod
- [ ] Add database health monitoring UI

### Phase 11: Quality Assurance
- [ ] Implement monitoring:
  - [ ] Performance metrics
  - [ ] Error tracking
  - [ ] Usage analytics
- [ ] Add validation:
  - [ ] Schema validation
  - [ ] Data integrity checks
  - [ ] Type safety enforcement
- [ ] Security measures:
  - [ ] SQL injection prevention
  - [ ] Access control
  - [ ] Data sanitization
- [ ] Documentation:
  - [ ] API documentation
  - [ ] Migration guides
  - [ ] Best practices guide

### Phase 12: Error Recovery & Resilience
- [ ] Implement recovery strategies:
  - [ ] Database corruption detection
  - [ ] Automatic backup/restore
  - [ ] Connection retry policies
  - [ ] Transaction recovery
 - [ ] Database corruption detection:
    - [ ] Checksum validation
    - [ ] Page integrity checks
    - [ ] Index consistency verification
    - [ ] Foreign key constraint validation
    - [ ] Automated repair attempts
  - [ ] Automatic backup/restore:
    - [ ] Corruption-triggered backups
    - [ ] Point-in-time recovery
    - [ ] Transaction log replay
    - [ ] Include automatic backup before migrations
- [ ] Add telemetry:
  - [ ] Operation timing metrics
  - [ ] Error rate monitoring
  - [ ] Performance bottleneck detection
  - [ ] Corruption incident tracking
- [ ] Consider batch operation handling
- [ ] Add index management strategy
- [ ] Add caching strategy (especially for frequently accessed data)
- [ ] Add specific error handling for:
  - [ ] Disk space issues
  - [ ] Concurrent access conflicts
  - [ ] Migration failures
  - [ ] Network disconnections (for backup/sync)

- [ ] Add these documentation files:
  ```
  docs/database/
  ├── MIGRATION_GUIDE.md
  ├── BACKUP_RESTORE.md
  ├── PERFORMANCE_TUNING.md
  └── TROUBLESHOOTING.md
  ```

- [ ] Add structured logging for:
  - [ ] Query execution times
  - [ ] Migration durations
  - [ ] Error frequencies
  - [ ] Connection pool status



## Implementation Strategy

### Development Flow
1. Start with Phase -1 and 0 (Setup & Init)
2. Implement Phases 1-4 together (Core Database)
3. Add Phase 5 (Configuration) incrementally
4. Implement Phase 3b (Dynamic Tables) after core is stable
5. Add remaining phases iteratively

### Testing Strategy
- Write tests alongside implementation
- Use drift_dev's testing utilities
- Implement integration tests early
- Test migrations thoroughly

### Deployment Considerations
- Version database changes carefully
- Plan for backward compatibility
- Consider data migration paths
- Test on all target platforms

## Next Steps
After completing these phases, we should have a robust, maintainable, and properly structured database implementation that follows best practices and integrates well with the rest of the application.