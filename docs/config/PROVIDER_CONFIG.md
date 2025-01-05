# Provider Configuration

Centralizes provider configurations and overrides for the application.

## File Location
`lib/config/provider_config.dart`

## Key Patterns & Principles
- Uses Riverpod for state management
- Implements provider overrides
- Supports environment configs
- Handles feature flags
- Uses logging service
- Follows DI pattern
- Uses builder pattern
- Supports testing

## Responsibilities
Does:
- Configure providers
- Manage overrides
- Handle environments
- Support features
- Log configurations
- Enable testing
- Manage dependencies
- Support development

Does Not:
- Handle UI logic
- Process user input
- Store application data
- Define providers
- Handle routing
- Manage state
- Define themes
- Process analytics

## Component Connections
- [x] Config Layer
  - [x] Environment
  - [x] Theme
  - [ ] Routes
  - [x] Logger
- [ ] Service Layer
  - [ ] Storage
  - [ ] API
  - [x] Logger
  - [ ] Analytics
- [x] State Layer
  - [x] First Run Provider
  - [x] Theme Provider
  - [x] App Preferences
- [ ] UI Layer
  - [ ] Screens
  - [ ] Widgets
  - [ ] Layout

## Dependencies
- `flutter_riverpod`: State management
- `meta`: Annotations
- First run provider
- Theme provider
- App preferences provider
- Environment configuration
- Logger service

## Integration Points
- `first_run_provider.dart`: First run state
- `theme_provider.dart`: Theme management
- `app_preferences_provider.dart`: App settings
- Environment configuration

## Additional Details

### Provider Overrides
Features:
- Root overrides
- Feature overrides
- Environment overrides
- Test overrides
- Development settings

### Environment Support
Features:
- Development mode
- Production mode
- Testing mode
- Feature flags
- Configuration

### Feature Management
Features:
- Settings overrides
- People management
- Schema management
- Feature flags
- Configuration

### Testing Support
- Provider testing
- Override testing
- Environment testing
- Integration testing
- Mock providers 