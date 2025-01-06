# Navigation Bar Widget

A composite widget that provides consistent navigation across the application.

## File Location
`lib/ui/widgets/nav_bar.dart`

## Key Patterns & Principles
- Composite widget pattern
- Navigation integration
- Consistent styling
- Responsive design
- Accessibility support

## Responsibilities
Does:
- Provide app-wide navigation
- Display navigation buttons
- Handle navigation state
- Maintain consistent styling
- Support responsive layout

Does Not:
- Handle business logic
- Manage global state
- Process authentication
- Handle deep linking
- Cache navigation history

## Component Connections
- [x] Config Layer
  - [x] Theme
  - [x] Routes
  - [ ] Environment
  - [x] Constants
- [ ] Service Layer
  - [ ] Database
  - [ ] API
  - [ ] Logger
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
- `go_router`: Navigation
- `color_palette.dart`: Theme colors
- `typography_styles.dart`: Text styles
- `spacing_constants.dart`: Layout spacing

## Integration Points
- Used in BaseLayout for app-wide navigation
- Used directly in standalone screens
- Integrates with go_router for navigation
- Works with theme system

## Usage Patterns

### In BaseLayout
The NavBar is the default navigation component in BaseLayout:
```dart
BaseLayout(
  title: 'Screen Title',
  actions: [/* optional actions */],
  child: YourContent(),
)
```

### In Standalone Screens
For screens not using BaseLayout:
```dart
Scaffold(
  appBar: NavBar(
    context: context,
    title: 'Screen Title',
    actions: [/* optional actions */],
  ),
  body: YourContent(),
)
```

### Navigation Structure
- Home route ('/')
- People route ('/people')
- AI Assistant ('/ai')
- Settings route ('/settings')

### Props
- `context`: Build context for navigation
- `title`: Optional screen title
- `actions`: Optional action buttons

### UI Integration
- Consistent button styling
- Icon and text combination
- Proper spacing and padding
- Responsive layout support

### Accessibility
- Clear navigation labels
- Sufficient touch targets
- Keyboard navigation support
- Screen reader compatibility 