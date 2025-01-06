# OllamaSettingsCard

Widget for managing Ollama configuration settings with real-time validation and connection testing.

## File Location
`lib/ui/widgets/ollama_settings_card.dart`

## Key Patterns & Principles
- ConsumerStatefulWidget pattern
- Form validation
- Real-time input handling
- Error handling
- Connection testing
- Settings persistence

## Responsibilities
Does:
- Display current Ollama settings
- Allow editing of settings
- Validate input values
- Test server connection
- Save configuration changes
- Show feedback messages
- Reset to defaults

Does Not:
- Handle API communication
- Manage global state
- Store settings (delegated to provider)
- Handle chat functionality
- Manage navigation

## Component Connections
- [x] Config Layer
  - [x] OllamaConfig
- [x] Service Layer
  - [x] OllamaService
  - [x] LoggerService
- [x] State Layer
  - [x] OllamaConfigProvider
- [x] UI Layer
  - [x] Material Components
  - [x] Typography Styles
  - [x] Spacing Constants
- [ ] Util Layer

## Execution Pattern
- [x] Has Initialization Order
  1. Initialize controllers
  2. Load current config
  3. Set up listeners
  4. Handle disposal

## Dependencies
- `flutter_riverpod`: State management
- `OllamaConfig`: Configuration model
- `OllamaService`: Connection testing
- Material Design components

## Integration Points
- `lib/providers/ollama_provider.dart`: Configuration state
- `lib/services/ollama_service.dart`: Connection testing
- `lib/config/ollama_config.dart`: Default values
- `lib/ui/layout/spacing_constants.dart`: Layout
- `lib/ui/layout/typography_styles.dart`: Text styles

## Additional Details

### Configuration Fields
```dart
class _OllamaSettingsCardState extends ConsumerState<OllamaSettingsCard> {
  late TextEditingController _urlController;
  late TextEditingController _modelController;
  late TextEditingController _tempController;
  late TextEditingController _contextController;
  bool _isEditing = false;
}
```

### Input Validation
- URL format validation
- Temperature range (0.0 - 1.0)
- Timeout validation
- Model name validation

### User Feedback
- Success messages
- Error messages
- Connection status
- Save confirmation

### Settings Flow
1. User edits settings
2. Real-time validation
3. Save changes
4. Update provider
5. Show confirmation
6. Optional connection test

### Layout Structure
```dart
Card(
  child: Column(
    children: [
      Header with reset button
      URL input field
      Model input field
      Row(
        Temperature input
        Timeout input
      )
      Action buttons
    ]
  )
)
``` 