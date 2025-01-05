import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import '../services/initialization/database_initializer.dart';

/// Manages environment-specific configuration and feature flags
class Environment {
  // Make constructor private to prevent instantiation
  Environment._();

  /// Validates environment name is supported
  static bool isValidEnvironment(String env) => switch (env) {
    'development' || 'staging' || 'production' => true,
    _ => false,
  };

  /// Current environment name
  static const String name = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  /// Platform-specific getters
  static bool get isAndroid => Platform.isAndroid;
  static bool get isIOS => Platform.isIOS;
  static bool get isWeb => false; // Add proper web detection if needed
  static bool get isDesktop => Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  /// Throws if environment is invalid
  static void validateEnvironment() {
    if (!isValidEnvironment(name)) {
      throw StateError('Invalid environment: $name');
    }
  }

  /// Whether we're in development mode
  static bool get isDevelopment => name == 'development';

  /// Whether to show debug information
  static bool get showDebugInfo => isDevelopment;

  /// Whether to enable file logging
  static bool get enableFileLogging => !isDevelopment;

  /// Whether to enable analytics
  static bool get enableAnalytics => !isDevelopment;

  /// Application version
  static String get appVersion => const String.fromEnvironment(
    'VERSION',
    defaultValue: '1.0.0',
  );

  /// API endpoint based on environment
  static String get apiEndpoint => switch (name) {
    'production' => 'https://api.example.com',
    'staging' => 'https://staging-api.example.com',
    _ => 'http://localhost:8080',
  };

  /// Database configuration based on environment
  static Map<String, dynamic> get databaseConfig => switch (name) {
    'production' => {
      'maxConnections': 10,
      'enableCache': true,
      'logQueries': false,
    },
    _ => {
      'maxConnections': 5,
      'enableCache': false,
      'logQueries': true,
    },
  };

  /// Get the database file name
  static String get databaseName => DatabaseInitializer.databaseName;
} 