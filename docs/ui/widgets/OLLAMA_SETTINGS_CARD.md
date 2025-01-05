# Ollama Settings Card Widget

## File Location
`lib/ui/widgets/ollama_settings_card.dart`

## Purpose
Provides a user interface for configuring Ollama service settings with real-time validation and persistence.

## Key Features
- Real-time settings updates
- Input validation
- Connection testing
- Settings persistence
- Error handling
- Loading states

## Widget Structure
```dart
OllamaSettingsCard
└── Card
    └── Column
        ├── Header Row (Title + Reset Button)
        ├── Base URL Input
        ├── Model Name Input
        ├── Temperature Input
        ├── Context Length Input
        └── Action Buttons (Test + Save)
```

## State Management
- Uses ConsumerStatefulWidget for Riverpod integration
- Manages text controllers for input fields
- Handles loading and error states
- Provides real-time validation

## Input Fields
- Base URL: Ollama API endpoint
- Model Name: Selected model
- Temperature: Generation randomness (0.0-1.0)
- Context Length: Maximum token context

## Actions
- Test Connection: Verifies API connectivity
- Save Settings: Persists configuration
- Reset to Defaults: Restores default values

## Error Handling
- Displays connection errors
- Shows save operation failures
- Validates input ranges
- Handles loading states

## Dependencies
- `flutter_riverpod`
- `ollama_config_provider.dart`

## Usage Example
```dart
Scaffold(
  body: Padding(
    padding: EdgeInsets.all(16.0),
    child: OllamaSettingsCard(),
  ),
)
```

## Best Practices
1. Always dispose text controllers
2. Handle loading states appropriately
3. Provide clear error messages
4. Validate inputs before saving
5. Test connection after changes
6. Use proper error boundaries

## Integration Points
- Uses `ollamaConfigProvider` for state management
- Integrates with app theme
- Uses shared spacing constants
- Follows typography guidelines 