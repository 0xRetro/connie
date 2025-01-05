import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/logger_service.dart';

part 'theme_provider.g.dart';

/// Provider for theme mode settings
/// Defaults to system theme
@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    LoggerService.debug('Building ThemeModeNotifier');
    return ThemeMode.system;
  }

  /// Updates the theme mode
  void setThemeMode(ThemeMode mode) {
    LoggerService.debug('Setting theme mode: $mode');
    state = mode;
  }
}

/// Provider for high contrast mode
/// Defaults to disabled
@riverpod
class HighContrastNotifier extends _$HighContrastNotifier {
  @override
  bool build() {
    LoggerService.debug('Building HighContrastNotifier');
    return false;
  }

  /// Updates the high contrast mode
  void setHighContrast(bool enabled) {
    LoggerService.debug('Setting high contrast: $enabled');
    state = enabled;
  }
} 