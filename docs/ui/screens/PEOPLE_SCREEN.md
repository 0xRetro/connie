# People Screen

Screen that displays and manages the list of people in the system.

## File Location
`lib/ui/screens/people_screen.dart`

## Key Patterns & Principles
- Consumer widget pattern
- Error boundary integration
- Responsive design
- Action-based navigation
- List management
- Async data handling
- Card-based display

## Responsibilities
Does:
- Display list of people
- Provide filtering options
- Support person addition
- Enable data export
- Handle list interactions
- Manage view state
- Handle loading states
- Display error states

Does Not:
- Handle data persistence
- Process authentication
- Manage global state
- Define data models
- Handle complex operations

## Component Connections
- [x] Config Layer
  - [x] Theme
  - [x] Routes
  - [ ] Environment
  - [x] Constants
- [x] Service Layer
  - [x] Database
  - [ ] API
  - [x] Logger
  - [ ] Initialization
- [x] State Layer
  - [x] Providers
  - [x] Notifiers
  - [x] Models
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
- `flutter_riverpod`: State management
- `people_provider.dart`: Data access
- `data_card.dart`: Display widget
- `nav_bar.dart`: Navigation
- `header_widget.dart`: Page header
- `error_boundary.dart`: Error handling
- Layout utilities

## Integration Points
- Accessible via NavBar
- Links to person details
- Connects to management tools
- Integrates with data layer
- Uses DataCard widget

## Additional Details

### Layout Structure
- Navigation bar
- Header section
- Filter controls
- People list
  - Person cards
  - Action buttons
- Add person FAB

### Data Display
- Person name as title
- ID and role info
- Timestamps
- Action buttons
- Loading states
- Error states
- Empty states

### Actions
- Add person (FAB)
- Filter list
- Edit person
- View details
- Quick actions

### UI Integration
- Responsive layout
- Error handling
- Loading states
- Empty states
- Filter states

### Accessibility
- Clear navigation
- Proper labeling
- Keyboard support
- Screen reader support
- Touch targets 