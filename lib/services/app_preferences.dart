import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../config/app_preferences_config.dart';
import 'logger_service.dart';

/// Manages persistent application preferences and initialization state
class AppPreferences {
  static final AppPreferences _instance = AppPreferences._();
  factory AppPreferences() => _instance;
  AppPreferences._();

  SharedPreferences? _prefs;

  /// Initializes preferences and ensures singleton instance
  Future<void> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      await _migrateIfNeeded();
      LoggerService.debug('AppPreferences initialized');
    } catch (e, stack) {
      LoggerService.error(
        'Failed to initialize AppPreferences',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  /// Ensures preferences are initialized before access
  void _ensureInitialized() {
    if (_prefs == null) {
      throw StateError('AppPreferences not initialized. Call initialize() first.');
    }
  }

  /// Migrates preferences if version has changed
  Future<void> _migrateIfNeeded() async {
    _ensureInitialized();
    final currentVersion = _prefs!.getInt(AppPreferencesConfig.keys.storageVersion) ?? 0;
    
    if (currentVersion < AppPreferencesConfig.storageVersion) {
      LoggerService.info(
        'Migrating preferences from v$currentVersion to v${AppPreferencesConfig.storageVersion}',
      );
      
      // Add migration logic here when needed
      
      await _prefs!.setInt(
        AppPreferencesConfig.keys.storageVersion,
        AppPreferencesConfig.storageVersion,
      );
    }
  }

  /// Whether this is the first run of the application
  Future<bool> get isFirstRun async {
    _ensureInitialized();
    final isFirstRun = _prefs!.getBool(AppPreferencesConfig.keys.isFirstLaunch) 
        ?? AppPreferencesConfig.defaults.isFirstLaunch;
    LoggerService.debug('Retrieved isFirstRun: $isFirstRun');
    return isFirstRun;
  }

  /// Marks the first run as completed
  Future<void> setFirstRunCompleted() async {
    _ensureInitialized();
    LoggerService.info('Setting first run completed');
    await _prefs!.setBool(AppPreferencesConfig.keys.isFirstLaunch, false);
  }

  /// Gets the current theme mode
  Future<ThemeMode> getThemeMode() async {
    _ensureInitialized();
    final value = _prefs!.getString(AppPreferencesConfig.keys.themeMode);
    return ThemeMode.values.firstWhere(
      (mode) => mode.toString() == value,
      orElse: () => AppPreferencesConfig.defaults.themeMode,
    );
  }

  /// Sets the current theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _ensureInitialized();
    await _prefs!.setString(AppPreferencesConfig.keys.themeMode, mode.toString());
  }

  /// Gets whether high contrast mode is enabled
  Future<bool> getHighContrast() async {
    _ensureInitialized();
    return _prefs!.getBool(AppPreferencesConfig.keys.highContrast) 
        ?? AppPreferencesConfig.defaults.highContrast;
  }

  /// Sets whether high contrast mode is enabled
  Future<void> setHighContrast(bool enabled) async {
    _ensureInitialized();
    await _prefs!.setBool(AppPreferencesConfig.keys.highContrast, enabled);
  }

  /// Gets the last update check time
  Future<DateTime> getLastUpdateCheck() async {
    _ensureInitialized();
    final value = _prefs!.getInt(AppPreferencesConfig.keys.lastUpdateCheck);
    return value != null
        ? DateTime.fromMillisecondsSinceEpoch(value)
        : AppPreferencesConfig.defaultLastUpdateCheck;
  }

  /// Sets the last update check time
  Future<void> setLastUpdateCheck(DateTime time) async {
    _ensureInitialized();
    await _prefs!.setInt(
      AppPreferencesConfig.keys.lastUpdateCheck,
      time.millisecondsSinceEpoch,
    );
  }

  /// Gets whether debug info should be shown
  Future<bool> getShowDebugInfo() async {
    _ensureInitialized();
    return _prefs!.getBool(AppPreferencesConfig.keys.showDebugInfo) 
        ?? AppPreferencesConfig.defaults.showDebugInfo;
  }

  /// Sets whether debug info should be shown
  Future<void> setShowDebugInfo(bool show) async {
    _ensureInitialized();
    await _prefs!.setBool(AppPreferencesConfig.keys.showDebugInfo, show);
  }

  /// Gets whether logging to file is enabled
  Future<bool> getLogToFile() async {
    _ensureInitialized();
    return _prefs!.getBool(AppPreferencesConfig.keys.logToFile) 
        ?? AppPreferencesConfig.defaults.logToFile;
  }

  /// Sets whether logging to file is enabled
  Future<void> setLogToFile(bool enabled) async {
    _ensureInitialized();
    await _prefs!.setBool(AppPreferencesConfig.keys.logToFile, enabled);
  }

  /// Clears all preferences
  Future<void> clear() async {
    _ensureInitialized();
    LoggerService.info('Clearing all preferences');
    await _prefs!.clear();
  }

  /// Cleans up resources
  Future<void> dispose() async {
    _prefs = null;
    LoggerService.debug('AppPreferences disposed');
  }
}