# AI Screen

Provides the main AI chat interface for interacting with the Ollama AI assistant. Manages chat history, message input, and AI responses in a user-friendly interface.

## File Location
`lib/ui/screens/ai_screen.dart`

## Key Patterns & Principles
- Uses Riverpod for state management
- Implements ConsumerWidget pattern
- Follows Material Design principles
- Uses composition for UI components
- Implements responsive layout
- Follows chat UI best practices

## Responsibilities
Does:
- Display chat history
- Handle message input
- Show AI responses
- Manage chat UI state
- Display loading states
- Handle error states

Does Not:
- Process AI responses
- Manage message persistence
- Handle authentication
- Process model selection
- Manage network state
- Handle deep linking

## Component Connections
- [x] Config Layer
  - [x] Theme
  - [x] Routes
  - [x] Environment
  - [x] Constants
- [x] Service Layer
  - [ ] Database
  - [x] API
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

## Execution Pattern
- [x] Has Initialization Order
  1. Initialize Riverpod state
  2. Setup UI components
  3. Connect to chat service
  4. Handle message flow

## Dependencies
- `flutter_riverpod`: State management
- `ollama_provider`: AI chat state management
- `chat_message`: Message display widget
- `chat_input`: Message input widget
- `base_layout`: Screen layout template

## Integration Points
- `ollama_provider.dart`: Chat state management
- `chat_message.dart`: Message display
- `chat_input.dart`: Message input
- `base_layout.dart`: Screen layout
- `app_router.dart`: Navigation

## Additional Details

### State Management
- Uses OllamaProvider for chat state
- Manages message history
- Handles loading states
- Processes error states

### UI Integration
- Implements chat bubble design
- Shows user/AI avatars
- Displays typing indicators
- Supports message selection
- Handles keyboard interactions

### Error Handling
- Shows error messages
- Supports retry functionality
- Maintains UI responsiveness
- Preserves message history 