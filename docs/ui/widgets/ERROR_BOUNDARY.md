# Error Boundary Widget

A feature widget that catches and handles UI errors with a consistent error display interface.

## File Location
`lib/ui/widgets/error_boundary.dart`

## Key Patterns & Principles
- Error boundary pattern
- State management for error tracking
- Logging integration
- Retry mechanism
- Consistent error display

## Responsibilities
Does:
- Catch UI rendering errors
- Display error messages
- Provide retry functionality
- Log error details
- Maintain error state
- Handle error recovery

Does Not:
- Handle business logic errors
- Process API errors
- Manage global error state
- Handle navigation errors
- Cache error history

## Component Connections
- [x] Config Layer
  - [x] Theme
  - [ ] Routes
  - [ ] Environment
  - [x] Constants
- [x] Service Layer
  - [ ] Database
  - [ ] API
  - [x] Logger
  - [ ] Initialization
- [ ] State Layer
  - [ ] Providers
  - [ ] Notifiers
  - [ ] Models
- [x] UI Layer
  - [x] Screens
  - [x] Widgets
  - [x] Layouts
- [ ] Util Layer
  - [ ] Helpers
  - [ ] Extensions
  - [ ] Types

## Dependencies
- `flutter/material.dart`: Core widgets
- `logger`: Error logging
- `typography_styles.dart`: Text styling
- `spacing_constants.dart`: Layout spacing

## Integration Points
- `main_screen.dart`: Primary usage
- Used in any widget tree that needs error handling
- Integrates with Flutter's error system
- Works with Logger service

## Additional Details

### Error Handling
- Captures Flutter widget errors
- Maintains error and stack trace state
- Provides visual error feedback
- Supports error recovery

### State Management
- Uses StatefulWidget for error tracking
- Manages error and stack trace state
- Handles state reset on retry
- Preserves child widget state when possible

### UI Integration
- Centered error display
- Icon-based visual indicators
- Selectable error text
- Retry button when applicable

### Props
- `child`: Widget to monitor for errors
- `onRetry`: Optional retry callback

### Accessibility
- Error messages are selectable
- Clear visual indicators
- Proper contrast for error states
- Keyboard-accessible retry button 