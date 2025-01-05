# Main Screen

The main screen serves as the primary entry point and landing page for the Connie application.

## Purpose

The main screen provides:
- A welcoming interface for users
- Quick access to theme and display settings
- Overview of key features and getting started guide
- Navigation to key application sections

## Components

### Navigation Bar
- App-wide navigation using NavBar
- Access to key sections:
  - Home
  - People
  - People Management
  - Settings
- Help action in the app bar

### Header Section
- Title: "Welcome to Connie"
- Subtitle: "Your AI-powered assistant"
- Uses `HeaderWidget` for consistent styling

### Theme Settings
- Theme mode selection (Light/Dark/System)
- High contrast mode toggle
- Implemented using `ThemeSettingsWidget`
- Settings persist across sessions

### Quick Start Guide
- Overview of key features
- Interactive elements for navigation
- Visual indicators with icons
- Getting started instructions

## Layout

The screen follows responsive design principles:
- Uses `ResponsiveLayout` for adaptive sizing
- Implements proper spacing using `ResponsiveSpacing`
- Content width constraints via `ResponsiveConstraints`
- Scrollable content area

## State Management

### Theme Mode Provider
```dart
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
```
- Manages application theme state
- Defaults to system theme
- Persists across sessions

### High Contrast Provider
```dart
final highContrastProvider = StateProvider<bool>((ref) => false);
```
- Controls high contrast display mode
- Defaults to disabled
- Persists across sessions

## Error Handling

- Uses `ErrorBoundary` widget for catching UI errors
- Provides visual error feedback
- Includes retry functionality where applicable
- Logs errors using `Logger`

## Navigation

### Entry Points
- Initial app launch
- '/' route
- Deep links to home screen

### Exit Points
- Navigation via NavBar:
  - People section
  - People Management
  - Settings
- Help section via app bar action

## Dependencies

### Providers
- `themeModeProvider`
- `highContrastProvider`

### Widgets
- `NavBar`
- `HeaderWidget`
- `ThemeSettingsWidget`
- `ErrorBoundary`

### Layout
- `ResponsiveLayout`
- `ResponsiveSpacing`
- `ResponsiveConstraints`

## Testing

### Widget Tests
- Verify theme switching functionality
- Test high contrast toggle
- Validate error boundary behavior
- Check responsive layout adaptations
- Test navigation interactions

### Integration Tests
- Theme persistence across sessions
- Navigation flow validation
- Error handling scenarios
- Screen transitions

## Accessibility

- Proper semantic labels
- High contrast support
- Keyboard navigation
- Screen reader compatibility
- Sufficient touch targets

## Performance Considerations

- Uses `const` constructors where possible
- Implements proper widget rebuilding strategy
- Efficient error boundary implementation
- Responsive layout optimizations
- Proper scroll view implementation 