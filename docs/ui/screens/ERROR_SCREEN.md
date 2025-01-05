# Error Screen

A screen component that displays navigation and routing errors with recovery options.

## File Location
`lib/ui/screens/error_screen.dart`

## Key Patterns & Principles
- Uses stateless widget pattern
- Implements error display
- Provides recovery options
- Uses structured logging
- Implements user feedback
- Uses consistent styling
- Provides error context
- Implements navigation safety
- Uses selective text copying
- Follows material design

## Responsibilities
Does:
- Display error messages
- Show error details
- Provide navigation options
- Log user interactions
- Enable error copying
- Handle back navigation
- Offer home navigation
- Format error text
- Show error icons
- Maintain UI consistency

Does Not:
- Handle error recovery
- Process error data
- Manage error state
- Handle API errors
- Process business logic
- Store error history
- Manage navigation state
- Handle authentication

## Component Connections
- [x] Config Layer
  - [x] Theme
  - [ ] Environment
  - [ ] Provider Config
  - [ ] Constants
- [x] Service Layer
  - [x] Logger
  - [ ] Database
  - [ ] API
  - [ ] Auth
- [ ] State Layer
  - [ ] Providers
  - [ ] Notifiers
  - [ ] Models
- [x] UI Layer
  - [ ] Screens
  - [x] Widgets
  - [ ] Layouts
- [ ] Util Layer
  - [ ] Progress
  - [ ] Extensions
  - [ ] Types

## Execution Pattern
- [x] Has Display Order
  1. Error validation
  2. Layout construction
  3. Error formatting
  4. Icon display
  5. Button setup
  6. Navigation handling

## Dependencies
- `flutter/material.dart`: UI components
- `logger_service.dart`: Interaction logging

## Integration Points
- `app_router.dart`: Error handling
- `logger_service.dart`: Event logging
- Material theme: Styling
- Navigation system: Recovery

## Additional Details

### UI Components
- Error icon
- Error title
- Error message
- Recovery buttons
- Back button
- Selectable text

### Error Display
- Red error icon
- Bold error title
- Selectable error text
- Centered layout
- Consistent padding
- Clear typography

### Navigation Options
- Back navigation
- Home navigation
- Error context
- Safe navigation
- State clearing

### User Interactions
- Copy error text
- Navigate back
- Return home
- View details
- Dismiss error

### Logging Features
- Navigation events
- User interactions
- Error context
- Recovery attempts
- Screen lifecycle

### Usage Guidelines
- Display clear error messages
- Enable error text copying
- Provide recovery options
- Log user interactions
- Maintain UI consistency 