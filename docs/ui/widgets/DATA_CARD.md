# Data Card Widget

A reusable card widget that displays structured data in a responsive layout.

## File Location
`lib/ui/widgets/data_card.dart`

## Key Patterns & Principles
- Stateless widget pattern
- Responsive design
- Consistent styling
- Flexible data display
- Material Design

## Responsibilities
Does:
- Display title
- Show key-value pairs
- Handle responsive layout
- Support action buttons
- Apply consistent styling

Does Not:
- Manage data state
- Handle data fetching
- Process validation
- Define data structure
- Handle interactions

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
- `breakpoints.dart`: Responsive breakpoints

## Integration Points
- Used in list views
- Displays database records
- Shows structured data
- Supports actions

## Additional Details

### Layout Structure
- Card container
- Title section
- Fields section
- Action section
- Responsive grid

### Data Display
- Key-value pairs
- Consistent spacing
- Bold field names
- Wrapped text
- Flexible layout

### UI Integration
- Material Design
- Responsive layout
- Typography system
- Spacing system
- Card elevation

### Accessibility
- Clear labels
- Proper contrast
- Text scaling
- Touch targets
- Semantic structure 