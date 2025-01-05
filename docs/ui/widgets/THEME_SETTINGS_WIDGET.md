# Theme Settings Widget

Widget for managing theme-related settings and preferences.

## File Location
`lib/ui/widgets/theme_settings_widget.dart`

## Key Patterns & Principles
- Stateless widget pattern
- Controlled component pattern
- Callback-based state management
- Material Design components
- Responsive layout

## Responsibilities
Does:
- Display theme mode selector
- Show high contrast toggle
- Handle theme changes
- Provide visual feedback
- Support accessibility

Does Not:
- Manage theme state
- Persist settings
- Handle animations
- Define theme data
- Process validation

## Component Connections
- [x] Config Layer
  - [x] Theme
  - [ ] Routes
  - [ ] Environment
  - [x] Constants
- [ ] Service Layer
  - [ ] Database
  - [ ] API
  - [ ] Logger
  - [ ] Initialization
- [x] State Layer
  - [x] Providers
  - [x] Notifiers
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
- `spacing_constants.dart`: Layout spacing

## Integration Points
- Used in settings screen
- Connects to theme system
- Integrates with providers
- Supports system theme

## Additional Details

### Theme Mode Options
- System: Follow system theme
- Light: Force light theme
- Dark: Force dark theme

### High Contrast Mode
- Toggle switch
- Visual indicator
- Accessibility support

### Layout Structure
- Card container
- Theme mode selector
- High contrast toggle
- Consistent spacing

### UI Integration
- Material Design
- Responsive layout
- Visual feedback
- Error handling
- Accessibility support

### Accessibility
- Clear labels
- Proper contrast
- Screen reader support
- Keyboard navigation
- Focus management 