# Person Form Dialog

Dialog widget for creating and editing people in the system.

## File Location
`lib/ui/widgets/person_form_dialog.dart`

## Key Patterns & Principles
- Stateful widget pattern
- Form validation
- Error handling
- Loading states
- Controlled inputs

## Responsibilities
Does:
- Display form inputs
- Validate input data
- Handle submission
- Show loading states
- Display errors
- Support editing
- Manage dialog state

Does Not:
- Handle data persistence
- Process authentication
- Manage global state
- Define data models
- Handle navigation

## Component Connections
- [x] Config Layer
  - [ ] Theme
  - [ ] Routes
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
- `spacing_constants.dart`: Layout spacing
- `typography_styles.dart`: Text styles

## Integration Points
- Used in PeopleScreen
- Handles form submission
- Manages dialog state
- Provides validation

## Additional Details

### Form Fields
- Name input
  - Required field
  - Text validation
  - Error display
- Super user toggle
  - Boolean switch
  - Optional field
  - Default false

### State Management
- Loading states
- Error states
- Input validation
- Form submission
- Dialog closure

### Error Handling
- Input validation
- Submit errors
- Error display
- Error recovery
- State cleanup

### Accessibility
- Clear labels
- Error messages
- Keyboard support
- Focus management
- Loading indicators 