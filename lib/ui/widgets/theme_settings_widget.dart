import 'package:flutter/material.dart';
import '../layout/spacing_constants.dart';

/// Widget for managing theme-related settings
///
/// Displays controls for:
/// - Theme mode (system, light, dark)
/// - High contrast mode
///
/// Usage:
/// ```dart
/// ThemeSettingsWidget(
///   themeMode: ThemeMode.system,
///   highContrast: false,
///   onThemeModeChanged: (mode) => print('Theme mode: $mode'),
///   onHighContrastChanged: (enabled) => print('High contrast: $enabled'),
/// )
/// ```
class ThemeSettingsWidget extends StatelessWidget {
  /// Current theme mode
  final ThemeMode themeMode;

  /// Whether high contrast mode is enabled
  final bool highContrast;

  /// Callback when theme mode changes
  final ValueChanged<ThemeMode> onThemeModeChanged;

  /// Callback when high contrast mode changes
  final ValueChanged<bool> onHighContrastChanged;

  const ThemeSettingsWidget({
    super.key,
    required this.themeMode,
    required this.highContrast,
    required this.onThemeModeChanged,
    required this.onHighContrastChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(kSpacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThemeModeSelector(context),
            const SizedBox(height: kSpacingMedium),
            _buildHighContrastToggle(context),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeModeSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Theme Mode'),
        const SizedBox(height: kSpacingSmall),
        SegmentedButton<ThemeMode>(
          segments: const [
            ButtonSegment<ThemeMode>(
              value: ThemeMode.system,
              label: Text('System'),
              icon: Icon(Icons.brightness_auto),
            ),
            ButtonSegment<ThemeMode>(
              value: ThemeMode.light,
              label: Text('Light'),
              icon: Icon(Icons.brightness_high),
            ),
            ButtonSegment<ThemeMode>(
              value: ThemeMode.dark,
              label: Text('Dark'),
              icon: Icon(Icons.brightness_4),
            ),
          ],
          selected: {themeMode},
          onSelectionChanged: (Set<ThemeMode> selected) {
            onThemeModeChanged(selected.first);
          },
        ),
      ],
    );
  }

  Widget _buildHighContrastToggle(BuildContext context) {
    return SwitchListTile(
      title: const Text('High Contrast'),
      subtitle: const Text('Increase contrast for better visibility'),
      value: highContrast,
      onChanged: onHighContrastChanged,
    );
  }
} 