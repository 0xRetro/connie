# Base Layout Components

Core layout components that provide consistent structure and error handling for screens.

## File Location
`lib/ui/layout/base_layout.dart`

## Key Patterns & Principles
- Composite layout pattern
- Error boundary integration
- Responsive design
- Consistent spacing
- Safe area handling
- Drawer support

## Responsibilities

### BaseLayout
Does:
- Provide consistent app bar
- Handle responsive padding
- Manage width constraints
- Support navigation drawer
- Handle safe areas
- Support action buttons

Does Not:
- Handle business logic
- Manage state
- Process errors
- Handle data loading
- Define styling

### BaseScreenLayout
Does:
- Handle async state
- Display loading states
- Process error states
- Support retry functionality
- Integrate error boundary
- Maintain consistent error display

Does Not:
- Handle business logic
- Manage global state
- Define error messages
- Process API calls
- Cache data

## Component Connections
- [x] Config Layer
  - [x] Theme
  - [x] Routes
  - [ ] Environment
  - [x] Constants
- [x] Service Layer
  - [ ] Database
  - [ ] API
  - [x] Logger
  - [ ] Initialization
- [x] State Layer
  - [x] Providers
  - [ ] Notifiers
  - [ ] Models
- [x] UI Layer
  - [x] Screens
  - [x] Widgets
  - [x] Layouts
- [x] Util Layer
  - [ ] Helpers
  - [ ] Extensions
  - [x] Types

## Dependencies
- `flutter/material.dart`: Core widgets
- `flutter_riverpod`: State management
- `responsive_framework`: Responsive utilities
- `error_boundary.dart`: Error handling
- `typography_styles.dart`: Text styling
- `spacing_constants.dart`: Layout spacing

## Integration Points
- Used by all screen widgets
- Integrates with ErrorBoundary
- Works with ResponsiveLayout
- Connects with navigation system

## Additional Details

### Layout Structure
- App bar with title
- Optional action buttons
- Safe area wrapper
- Responsive padding
- Width constraints
- Optional drawer

### Error Handling
- Integrated ErrorBoundary
- Consistent error display
- Retry functionality
- Error message formatting
- Loading state handling

### Props
BaseLayout:
- `title`: Screen title
- `child`: Content widget
- `actions`: App bar actions
- `floatingActionButton`: FAB widget
- `bottomNavigationBar`: Bottom nav
- `showBackButton`: Navigation control
- `constrainWidth`: Width limiting
- `padding`: Custom padding

BaseScreenLayout:
- Extends BaseLayout props
- `state`: AsyncValue state
- `onData`: Data builder
- `onRetry`: Retry callback

### Accessibility
- Safe area compliance
- Proper navigation
- Error message clarity
- Loading indicators
- Touch target sizing 