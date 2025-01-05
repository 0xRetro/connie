# App Router

Manages application routing, navigation, and deep linking using GoRouter.

## File Location
`lib/navigation/app_router.dart`

## Key Patterns & Principles
- Uses GoRouter for navigation
- Implements route guards
- Handles deep linking
- Manages redirects
- Uses logging service
- Tracks analytics
- Handles errors
- Supports testing

## Responsibilities
Does:
- Define routes
- Handle navigation
- Manage redirects
- Track analytics
- Log navigation
- Handle errors
- Support deep links
- Guard routes

Does Not:
- Handle UI logic
- Process user input
- Store application data
- Configure services
- Handle theming
- Manage state
- Define layouts
- Process business logic

## Component Connections
- [x] Config Layer
  - [x] Environment
  - [ ] Theme
  - [x] Routes
  - [x] Logger
- [x] Service Layer
  - [ ] Storage
  - [ ] API
  - [x] Logger
  - [x] Analytics
- [x] State Layer
  - [x] First Run Provider
  - [ ] Theme Provider
  - [ ] App Preferences
- [x] UI Layer
  - [x] Screens
  - [ ] Widgets
  - [ ] Layout

## Dependencies
- `go_router`: Navigation
- `flutter_riverpod`: State management
- First run provider
- Logger service
- Analytics service
- Environment configuration

## Integration Points
- `first_run_provider.dart`: Setup flow
- Screen components
- Analytics service
- Error screen

## Additional Details

### Route Structure
Features:
- Main screen
- Settings screen
- People screens
- Schema screens
- Setup workflow
- Error handling

### Navigation Features
Features:
- Deep linking
- Route guards
- Redirects
- Analytics
- Error handling

### Analytics Integration
Features:
- Screen tracking
- Navigation events
- Error tracking
- Performance metrics
- User journeys

### Testing Support
- Route testing
- Guard testing
- Analytics testing
- Integration testing
- Mock navigation 