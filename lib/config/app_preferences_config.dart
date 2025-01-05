import 'package:flutter/material.dart';

/// Configuration for application preferences
class AppPreferencesConfig {
  /// Storage keys for preferences
  static const keys = _PreferenceKeys();
  
  /// Default values for preferences
  static const defaults = _PreferenceDefaults();
  
  /// Storage version for migrations
  static const storageVersion = 1;
  
  /// Default last update check (Unix epoch)
  static DateTime get defaultLastUpdateCheck => 
      DateTime.fromMillisecondsSinceEpoch(0);
}

/// Storage keys for preferences
class _PreferenceKeys {
  const _PreferenceKeys();
  
  /// Theme related keys
  final String themeMode = 'theme_mode';
  final String highContrast = 'high_contrast';
  
  /// Navigation related keys
  final String lastRoute = 'last_route';
  final String navigationHistory = 'navigation_history';
  
  /// Error handling related keys
  final String showDebugInfo = 'show_debug_info';
  final String logToFile = 'log_to_file';
  
  /// App state related keys
  final String storageVersion = 'storage_version';
  final String isFirstLaunch = 'is_first_launch';
  final String lastUpdateCheck = 'last_update_check';
}

/// Default values for preferences
class _PreferenceDefaults {
  const _PreferenceDefaults();
  
  /// Theme defaults
  final ThemeMode themeMode = ThemeMode.system;
  final bool highContrast = false;
  
  /// Navigation defaults
  final String lastRoute = '/';
  final List<String> navigationHistory = const [];
  
  /// Error handling defaults
  final bool showDebugInfo = false;
  final bool logToFile = true;
  
  /// App state defaults
  final bool isFirstLaunch = true;
} 