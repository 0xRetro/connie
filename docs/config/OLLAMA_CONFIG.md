# Ollama Configuration

Manages configuration settings and environment-specific values for Ollama integration.

## File Location
`lib/config/ollama_config.dart`

## Key Patterns & Principles
- Singleton pattern (private constructor)
- Environment-aware configuration
- Static configuration provider
- Validation-first initialization
- Comprehensive logging

## Responsibilities
Does:
- Provide Ollama-specific configuration values
- Validate configuration at initialization
- Handle environment-specific settings
- Manage rate limiting parameters
- Configure agent and workflow settings
- Provide template management settings

Does Not:
- Handle API calls
- Manage state
- Implement business logic
- Handle authentication
- Process model responses

## Component Connections
- [x] Config Layer
  - [x] Environment
  - [ ] Theme
  - [ ] Routes
  - [x] Constants
- [x] Service Layer
  - [ ] Database
  - [ ] API
  - [x] Logger
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
  2. Configuration initialization
  3. Configuration validation
  4. Logger setup

## Dependencies
- `environment.dart`: Environment-specific configuration
- `logger_service.dart`: Logging functionality

## Integration Points
- `lib/config/environment.dart`: Provides environment context
- `lib/services/logger_service.dart`: Logging integration
- `lib/providers/ollama_provider.dart`: Consumes configuration
- `lib/services/ollama_service.dart`: Uses configuration for API setup

## Additional Details

### Configuration
- Default values provided for all settings
- Environment-specific overrides available
- Comprehensive validation rules
- Debug mode tied to environment

### State Management
- Static getters ensure consistent access
- No mutable state
- Environment-aware value resolution

### Services
- Logging integration for debugging
- Initialization validation
- Error handling with specific messages

### UI Integration
- Settings exposed for UI configuration
- Rate limiting parameters available
- Template and workflow limits defined 