# Environment Configuration

## Overview
The Environment configuration provides centralized access to application-wide settings, feature flags, and environment-specific configurations. It acts as a single source of truth for environment-dependent values.

## File Location
`lib/config/environment.dart`

## Key Patterns

### Environment Types
- Development
- Staging
- Production

### Configuration Categories
1. Platform Information
   - Android detection
   - iOS detection
   - Desktop detection
   - Web support (future)

2. Environment Settings
   - Environment name
   - Development mode
   - Debug information
   - File logging
   - Analytics

3. Application Settings
   - Version information
   - API endpoints
   - Database configuration
   - Database file name

## Component Responsibilities

### Primary Functions
- Environment validation
- Platform detection
- Feature flag management
- Configuration access
- Database settings

### Environment Management
```dart
// Environment validation
static bool isValidEnvironment(String env) => switch (env) {
  'development' || 'staging' || 'production' => true,
  _ => false,
};

// Current environment
static const String name = String.fromEnvironment(
  'ENVIRONMENT',
  defaultValue: 'development',
);
```

### Configuration Access
```dart
// Feature flags
static bool get isDevelopment => name == 'development';
static bool get showDebugInfo => isDevelopment;
static bool get enableFileLogging => !isDevelopment;
static bool get enableAnalytics => !isDevelopment;

// Database configuration
static String get databaseName => DatabaseInitializer.databaseName;
```

## Integration Points

### Database Configuration
```dart
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

### API Configuration
```dart
static String get apiEndpoint => switch (name) {
  'production' => 'https://api.example.com',
  'staging' => 'https://staging-api.example.com',
  _ => 'http://localhost:8080',
};
```

## Error Handling

### Environment Validation
- Validates environment name at startup
- Throws StateError for invalid environments
- Provides type-safe environment checking

### Configuration Access
- Safe boolean getters
- Null-safe configuration access
- Environment-specific defaults

## Testing Requirements

### Unit Tests
- Environment validation
- Configuration switching
- Platform detection
- Feature flag logic

### Integration Tests
- Environment loading
- Configuration access
- Database settings
- API endpoint resolution

## Future Improvements

### Short Term
- Add web platform support
- Enhance configuration validation
- Add more feature flags
- Improve error messages

### Long Term
- Dynamic configuration loading
- Remote configuration
- Environment-specific assets
- Custom environment support

## Common Issues

### Known Limitations
- Fixed environment types
- Static configuration
- Limited web support
- Manual validation required

### Troubleshooting
1. Environment Issues
   - Check environment name
   - Verify build flags
   - Review platform detection
   - Validate configuration

2. Configuration Access
   - Check getter availability
   - Verify environment state
   - Review platform support
   - Check initialization order

## Maintenance

### Regular Tasks
- Update environment types
- Review configuration values
- Check platform support
- Validate API endpoints

### Documentation
- Update configuration examples
- Document new features
- Maintain platform support
- Review error handling 