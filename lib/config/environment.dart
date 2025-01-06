import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import '../services/initialization/database_initializer.dart';

/// Manages environment-specific configuration and platform detection.
/// Supports development, staging, and production environments.
/// This class cannot be instantiated and provides only static access.
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
  static bool get isWeb => kIsWeb;
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

  /// Ollama configuration based on environment
  static Map<String, dynamic> get ollamaConfig => switch (name) {
    'production' => {
      'baseUrl': 'http://localhost:11434',
      'model': 'llama3.2:latest',
      'contextLength': 8192,
      'temperature': 0.7,
      'topP': 0.9,
      'topK': 40,
      'stream': true,
      'connectionTimeout': 30000,
      'receiveTimeout': 30000,
      'enableDebugLogs': false,
      'trackPerformance': true,
      'maxRequestsPerMinute': 60,
      'rateLimitInterval': const Duration(minutes: 1),
    },
    'staging' => {
      'baseUrl': 'http://localhost:11434',
      'model': 'llama3.2:latest',
      'contextLength': 8192,
      'temperature': 0.7,
      'topP': 0.9,
      'topK': 40,
      'stream': true,
      'connectionTimeout': 30000,
      'receiveTimeout': 30000,
      'enableDebugLogs': true,
      'trackPerformance': true,
      'maxRequestsPerMinute': 60,
      'rateLimitInterval': const Duration(minutes: 1),
    },
    _ => {
      'baseUrl': 'http://localhost:11434',
      'model': 'llama3.2:latest',
      'contextLength': 4096,
      'temperature': 0.7,
      'topP': 0.9,
      'topK': 40,
      'stream': true,
      'connectionTimeout': 30000,
      'receiveTimeout': 30000,
      'enableDebugLogs': true,
      'trackPerformance': true,
      'maxRequestsPerMinute': 60,
      'rateLimitInterval': const Duration(minutes: 1),
    },
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

  /// Add environment-specific database config validation
  static void validateDatabaseConfig() {
    final config = databaseConfig;
    if (config['maxConnections'] < 1) {
      throw ArgumentError('Invalid database connection configuration');
    }
  }

  /// Validate Ollama configuration
  static void validateOllamaConfig() {
    final config = ollamaConfig;
    if (config['contextLength'] < 1) {
      throw ArgumentError('Invalid Ollama context length configuration');
    }
    if (config['temperature'] < 0 || config['temperature'] > 1) {
      throw ArgumentError('Invalid Ollama temperature configuration');
    }
    if (config['topP'] < 0 || config['topP'] > 1) {
      throw ArgumentError('Invalid Ollama top-p configuration');
    }
    if (config['topK'] < 1) {
      throw ArgumentError('Invalid Ollama top-k configuration');
    }
    if (config['connectionTimeout'] < 1000) {
      throw ArgumentError('Invalid Ollama connection timeout configuration');
    }
  }
} 