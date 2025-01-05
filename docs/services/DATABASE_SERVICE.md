# Database Service

Manages database operations with health monitoring, schema management, and data initialization capabilities.

## File Location
`lib/services/database_service.dart`

## Key Patterns & Principles
- Uses Provider pattern for dependency injection
- Implements retry logic with exponential backoff
- Follows single responsibility principle
- Provides transaction safety
- Implements backup/restore functionality
- Uses proper error handling and logging
- Manages schema versioning
- Handles default data creation
- Implements health monitoring

## Responsibilities
Does:
- Manage database operations with retry logic
- Handle database initialization and disposal
- Perform health checks and metrics collection
- Create and restore database backups
- Provide error handling and logging
- Manage database lifecycle
- Create and verify schema
- Initialize default data
- Monitor database health
- Track database size
- Verify data integrity
- Handle migrations

Does Not:
- Handle UI state
- Manage business logic
- Define database schema
- Handle data transformations
- Manage application state
- Handle direct file operations
- Process user input

## Component Connections
- [x] Config Layer
  - [x] Environment
  - [x] Storage Config
  - [x] Provider Config
  - [x] Constants
- [x] Service Layer
  - [x] Database
  - [x] Logger
  - [x] Initialization
  - [x] Analytics
- [x] State Layer
  - [x] Providers
  - [x] First Run
  - [x] Progress
- [x] UI Layer
  - [x] Setup Screen
  - [x] Error Display
  - [x] Progress Indicator

## Database Schema
Tables:
- people
  - id: INTEGER PRIMARY KEY
  - name: TEXT NOT NULL
  - is_super_user: INTEGER
  - created_at: TEXT
  - updated_at: TEXT
  - is_deleted: INTEGER

- ui_settings
  - id: INTEGER PRIMARY KEY
  - table_name: TEXT NOT NULL
  - settings: TEXT NOT NULL
  - created_at: TEXT
  - updated_at: TEXT
  - is_deleted: INTEGER

- plugin_settings
  - id: INTEGER PRIMARY KEY
  - plugin_name: TEXT NOT NULL
  - settings_key: TEXT NOT NULL
  - settings_value: TEXT NOT NULL
  - created_at: TEXT
  - updated_at: TEXT
  - is_deleted: INTEGER

## Health Metrics
Monitored Metrics:
- Database size (bytes)
- Schema version
- Table count
- Default data presence
- Settings presence
- Migration status
- Connection health
- Write permissions

## Dependencies
- `drift`: Database ORM and operations
- `flutter_riverpod`: State management and DI
- `logger_service`: Logging functionality
- `database.dart`: Core database implementation
- `storage_config.dart`: File system management

## Integration Points
- `database.dart`: Core database functionality
- `initialization_service.dart`: App startup sequence
- `logger_service.dart`: Error and operation logging
- `environment.dart`: Configuration settings
- `storage_config.dart`: File paths
- `first_run_provider.dart`: Setup state

## Additional Details

### Configuration
- Maximum retry attempts: 3
- Retry delay: 1000ms
- Automatic error logging
- Transaction safety
- Health monitoring
- Schema versioning
- Default data setup

### State Management
- Uses Provider for database instance
- Provides service-level provider
- Manages database lifecycle state
- Tracks operation attempts
- Monitors health metrics
- Handles migrations

### Default Data
- Admin user creation
  - name: "Admin"
  - is_super_user: true
  - created_at: current timestamp
  - updated_at: current timestamp
  - is_deleted: false

### Health Checks
Verifications:
- Database size monitoring
- Schema version check
- Table existence
- Default data presence
- Settings verification
- Migration status
- Connection test
- Write permission

### Error Handling
- Automatic retry on failures
- Progressive delay between attempts
- Detailed error logging
- Operation tracking
- Health verification
- Migration rollback
- Data recovery

### Testing Support
- Mockable database instance
- Verifiable operations
- Testable retry logic
- Error simulation support
- Health check testing
- Migration testing 