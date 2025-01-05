# People Provider

Provider for managing people data in the application.

## File Location
`lib/providers/people_provider.dart`

## Key Patterns & Principles
- Riverpod async notifier pattern
- CRUD operations
- Soft delete pattern
- Database abstraction
- State invalidation

## Responsibilities
Does:
- Fetch people list
- Create new people
- Update existing people
- Handle soft deletes
- Manage state updates
- Log operations

Does Not:
- Handle UI state
- Validate input
- Process business logic
- Manage permissions
- Handle authentication

## Component Connections
- [x] Config Layer
  - [ ] Theme
  - [ ] Routes
  - [ ] Environment
  - [ ] Constants
- [x] Service Layer
  - [x] Database
  - [ ] API
  - [x] Logger
  - [ ] Initialization
- [x] State Layer
  - [x] Providers
  - [x] Notifiers
  - [x] Models
- [ ] UI Layer
  - [ ] Screens
  - [ ] Widgets
  - [ ] Layouts
- [ ] Util Layer
  - [ ] Helpers
  - [ ] Extensions
  - [ ] Types

## Dependencies
- `drift/drift.dart`: Database operations
- `riverpod_annotation`: Provider generation
- `database.dart`: Database access
- `logger_service.dart`: Operation logging

## Integration Points
- Used by screens
- Connects to database
- Manages people data
- Triggers UI updates

## Additional Details

### State Management
- Async state handling
- Automatic invalidation
- Error propagation
- Loading states
- Cache management

### Database Operations
- CRUD functionality
- Soft delete support
- Transaction handling
- State synchronization
- Data consistency

### Error Handling
- Operation logging
- State recovery
- Error propagation
- Data validation
- Null safety

### Performance
- Efficient queries
- State caching
- Batch operations
- Memory management
- Resource cleanup 