# Chat Message Widget

A reusable widget that displays individual chat messages in a bubble format with user/AI avatars and proper styling based on the message sender.

## File Location
`lib/ui/widgets/chat_message.dart`

## Key Patterns & Principles
- Implements StatelessWidget pattern
- Uses composition for layout
- Follows Material Design principles
- Implements responsive design
- Uses consistent styling
- Supports message selection

## Responsibilities
Does:
- Display message content
- Show sender avatar
- Apply appropriate styling
- Support text selection
- Handle message alignment
- Maintain consistent layout

Does Not:
- Process message content
- Handle message state
- Manage animations
- Process user input
- Handle message actions
- Store message data

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
  - [ ] Providers
  - [ ] Notifiers
  - [x] Models
- [x] UI Layer
  - [ ] Screens
  - [x] Widgets
  - [x] Layouts
- [ ] Util Layer
  - [ ] Helpers
  - [ ] Extensions
  - [ ] Types

## Dependencies
- `ollama_agent.dart`: Message model
- `color_palette.dart`: Theme colors
- `spacing_constants.dart`: Layout spacing

## Integration Points
- `ai_screen.dart`: Parent screen
- `ollama_agent.dart`: Message data
- `color_palette.dart`: Styling

## Additional Details

### UI Integration
- Implements chat bubble design
- Shows sender avatar
- Supports message selection
- Uses consistent spacing
- Handles long messages

### Styling
- Different colors for user/AI
- Proper text contrast
- Consistent spacing
- Rounded corners
- Avatar integration

### Accessibility
- Selectable text
- High contrast colors
- Proper spacing
- Clear visual hierarchy
- Screen reader support 