# Environment Configuration

Manages environment-specific settings and platform detection for the application.

## File Location
`lib/config/environment.dart`

## Key Patterns & Principles
- Singleton pattern (private constructor)
- Platform-aware configuration
- Environment validation
- Static configuration provider

## Responsibilities
Does:
- Define valid environments
- Provide environment-specific settings
- Detect platform type
- Validate environment configuration
- Provide database configuration

Does Not:
- Handle environment switching
- Manage runtime configuration
- Handle API calls
- Process environment variables

## Component Connections
- [x] Config Layer
  - [ ] Theme
  - [ ] Routes
  - [x] Constants
- [x] Service Layer
  - [x] Database
  - [ ] API
  - [ ] Logger
  - [x] Initialization
- [ ] State Layer
  - [ ] Providers
  - [ ] Notifiers
  - [ ] Models
- [ ] UI Layer
  - [ ] Screens
  - [ ] Widgets
  - [ ] Layouts
- [ ] Util Layer
  - [ ] Helpers
  - [ ] Extensions
  - [ ] Types

## Execution Pattern
- [x] Has Initialization Order
  1. Environment validation
  2. Platform detection
  3. Database configuration setup

## Dependencies
- `dart:io`: Platform detection
- `database_initializer.dart`: Database configuration

## Integration Points
- `lib/config/ollama_config.dart`: Uses environment context
- `lib/services/initialization/database_initializer.dart`: Database setup
- Various service configurations that depend on environment

## Additional Details

### Configuration
- Supports development, staging, and production
- Platform-specific detection
- Debug information toggle
- Analytics configuration

### Services
- Database configuration by environment
- Logging configuration
- Analytics enablement 