# Logger Service

Provides centralized logging functionality with environment awareness, error handling, and structured logging capabilities.

## File Location
`lib/services/logger_service.dart`

## Key Patterns & Principles
- Uses singleton pattern
- Implements hierarchical logging
- Provides environment-aware logging
- Implements log rotation
- Sanitizes sensitive data
- Uses structured logging format
- Implements group logging
- Provides performance tracking
- Manages log file lifecycle
- Implements verification checks
- Uses emoji-based log levels
- Supports analytics integration

## Responsibilities
Does:
- Initialize logging system
- Format log messages
- Handle different log levels
- Manage log files
- Rotate log files
- Clean up old logs
- Sanitize sensitive data
- Group related logs
- Track performance
- Monitor database operations
- Log navigation events
- Verify log file health
- Track initialization stages
- Format with emojis
- Structure log data

Does Not:
- Handle UI updates
- Manage application state
- Process business logic
- Configure environment
- Handle user preferences
- Manage database operations
- Define log retention policy
- Handle crash reporting

## Component Connections
- [x] Config Layer
  - [x] Environment
  - [x] Logger Config
  - [x] Storage Config
  - [x] Provider Config
- [x] Service Layer
  - [x] Database
  - [x] Initialization
  - [x] Navigation Analytics
  - [x] Preferences
- [x] State Layer
  - [x] Progress
  - [x] First Run
  - [x] Environment
- [x] UI Layer
  - [x] Error Display
  - [x] Debug Console
  - [x] Progress Indicator

## Log Levels and Formatting
Debug (🐛):
- Development details
- Stack traces
- Object dumps
- Navigation events
- State changes

Info (💡):
- Stage completion
- Operation success
- Health checks
- Analytics events
- Progress updates

Warning (⚠️):
- Non-critical issues
- Performance concerns
- Resource warnings
- State inconsistencies

Error (❌):
- Critical failures
- Exception details
- Stack traces
- Recovery attempts

## Message Structure
```
┌─────────────────────────────────────────────
│ #0   LoggerService.method (file:line)
│ #1   CallingMethod (file:line)
├─────────────────────────────────────────────
│ 🐛 Message - Data: {key: value, ...}
└─────────────────────────────────────────────
```

## Dependencies
- `logger`: Third-party logging package
- `logger_config.dart`: Logger configuration
- `environment.dart`: Environment settings
- `path`: Path manipulation utilities
- `dart:io`: File operations
- `storage_config.dart`: File system management

## Integration Points
- `main.dart`: Primary consumer
- `initialization_service.dart`: Service initialization
- `database_service.dart`: Database operations
- `environment.dart`: Environment checks
- `logger_config.dart`: Configuration
- `navigation_analytics_service.dart`: Navigation tracking

## Additional Details

### Log Categories
- Initialization stages
- Database operations
- Navigation events
- State changes
- Health checks
- Analytics events
- Platform events
- User interactions

### File Management
- Environment-based paths
- Automatic log rotation
- Size-based rotation
- Configurable backup count
- Old log cleanup
- File health verification
- Write permission checks

### Performance Tracking
- Operation duration logging
- Database operation timing
- Navigation event tracking
- Service operation monitoring
- Health check timing
- Stage completion timing

### Security Features
- Sensitive data masking
- Environment-based logging
- Secure file operations
- Access verification
- Write permission checks
- Path sanitization

### Analytics Integration
- Navigation tracking
- Stage completion
- Error reporting
- Performance metrics
- User interactions
- Health statistics

### Testing Support
- Debug logging
- State tracking
- Error simulation
- Performance monitoring
- Path verification 