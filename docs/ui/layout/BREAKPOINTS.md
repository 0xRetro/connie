# Breakpoints

Constants defining responsive layout breakpoints for the application.

## File Location
`lib/ui/layout/breakpoints.dart`

## Key Patterns & Principles
- Material Design breakpoints
- Responsive design
- Device categories
- Content constraints
- Layout adaptation

## Responsibilities
Does:
- Define device breakpoints
- Set content boundaries
- Support responsive layout
- Guide layout decisions
- Maintain consistency

Does Not:
- Handle layout logic
- Manage state
- Process media queries
- Define styles
- Control behavior

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
None - pure constant definitions

## Integration Points
- Used by layouts
- Guides responsive design
- Supports widget adaptation
- Controls content width

## Additional Details

### Breakpoint Categories
- Mobile: 0-599px
- Tablet: 600-1023px
- Desktop: 1024px+
- Content min: 320px
- Content max: 1200px

### Layout Integration
- MediaQuery usage
- LayoutBuilder support
- Responsive widgets
- Adaptive layouts
- Content constraints

### Device Support
- Phone layouts
- Tablet layouts
- Desktop layouts
- Orientation changes
- Screen sizes

### Best Practices
- Consistent usage
- Clear boundaries
- Device targeting
- Content scaling
- Layout adaptation 