import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/first_run_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/app_preferences_provider.dart';
import '../providers/ollama_provider.dart';
import '../config/environment.dart';
import '../services/logger_service.dart';

/// Provider for SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

/// Centralizes provider configurations and overrides for the application
class ProviderConfig {
  /// Returns the list of provider overrides for the app's root ProviderScope
  static List<Override> getRootOverrides({
    required bool isFirstRun,
  }) {
    LoggerService.debug('Configuring root provider overrides');
    
    final overrides = <Override>[
      // Core state
      firstRunStateNotifierProvider.overrideWith(
        () => FirstRunStateNotifier(),
      ),
      
      // Theme configuration
      themeModeNotifierProvider.overrideWith(
        () => ThemeModeNotifier(),
      ),
      
      // App preferences
      preferencesNotifierProvider.overrideWith(
        () => PreferencesNotifier(),
      ),

      // Ollama configuration
      ollamaConfigProvider.overrideWith(
        (ref) => OllamaConfigNotifier(ref.watch(sharedPreferencesProvider)),
      ),
    ];

    // Add environment-specific overrides
    if (Environment.isDevelopment) {
      overrides.addAll(_getDevelopmentOverrides());
    } else {
      overrides.addAll(_getProductionOverrides());
    }

    return overrides;
  }

  /// Returns overrides specific to features or screens
  static List<Override> getFeatureOverrides({
    String? feature,
    Map<String, dynamic>? configuration,
  }) {
    LoggerService.debug('Configuring feature overrides: $feature');
    final overrides = <Override>[];

    switch (feature) {
      case 'settings':
        overrides.addAll(_getSettingsOverrides(configuration));
        break;
      case 'people':
        overrides.addAll(_getPeopleOverrides(configuration));
        break;
      case 'schema':
        overrides.addAll(_getSchemaOverrides(configuration));
        break;
    }

    return overrides;
  }

  /// Returns overrides specific to development environment
  static List<Override> _getDevelopmentOverrides() {
    LoggerService.debug('Configuring development overrides');
    return [
      // Development-specific overrides
      themeModeNotifierProvider.overrideWith(
        () => ThemeModeNotifier()..setThemeMode(ThemeMode.light),
      ),
    ];
  }

  /// Returns overrides specific to production environment
  static List<Override> _getProductionOverrides() {
    LoggerService.debug('Configuring production overrides');
    return [
      // Production-specific overrides
    ];
  }

  /// Returns overrides for settings feature
  static List<Override> _getSettingsOverrides(Map<String, dynamic>? config) {
    LoggerService.debug('Configuring settings overrides');
    return [
      // Settings-specific overrides
    ];
  }

  /// Returns overrides for people management feature
  static List<Override> _getPeopleOverrides(Map<String, dynamic>? config) {
    LoggerService.debug('Configuring people overrides');
    return [
      // People management-specific overrides
    ];
  }

  /// Returns overrides for schema management feature
  static List<Override> _getSchemaOverrides(Map<String, dynamic>? config) {
    LoggerService.debug('Configuring schema overrides');
    return [
      // Schema management-specific overrides
    ];
  }

  /// Returns overrides for testing
  @visibleForTesting
  static List<Override> getTestOverrides({
    bool? isFirstRun,
    ThemeMode? themeMode,
  }) {
    LoggerService.debug('Configuring test overrides');
    return [
      if (isFirstRun != null)
        firstRunStateNotifierProvider.overrideWith(
          () => FirstRunStateNotifier(),
        ),
      if (themeMode != null)
        themeModeNotifierProvider.overrideWith(
          () => ThemeModeNotifier()..setThemeMode(themeMode),
        ),
    ];
  }
} 