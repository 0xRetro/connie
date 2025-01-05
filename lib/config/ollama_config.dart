import 'package:flutter/foundation.dart';
import '../config/environment.dart';
import '../services/logger_service.dart';

/// Manages Ollama-specific configuration settings and initialization.
/// Provides environment-aware configuration for the Ollama integration.
/// This class cannot be instantiated and provides only static access.

/// Configuration for Ollama integration
class OllamaConfig {
  // Make constructor private to prevent instantiation
  OllamaConfig._();

  /// Initialize and validate configuration
  static void initialize() {
    LoggerService.startGroup('Initializing Ollama configuration');
    try {
      _validateConfiguration();
      LoggerService.info('Ollama configuration initialized successfully', data: {
        'baseUrl': baseUrl,
        'model': defaultModel,
        'environment': Environment.name,
      });
    } catch (e) {
      LoggerService.error('Failed to initialize Ollama configuration', error: e);
      rethrow;
    } finally {
      LoggerService.endGroup('Initializing Ollama configuration');
    }
  }

  /// Validate configuration values
  static void _validateConfiguration() {
    if (defaultTemperature < 0 || defaultTemperature > 1) {
      throw ArgumentError('Temperature must be between 0 and 1');
    }
    if (defaultTopP < 0 || defaultTopP > 1) {
      throw ArgumentError('Top-p must be between 0 and 1');
    }
    if (defaultTopK < 1) {
      throw ArgumentError('Top-k must be greater than 0');
    }
    if (maxContextLength < 1) {
      throw ArgumentError('Context length must be greater than 0');
    }
    if (connectionTimeout < 1000) {
      throw ArgumentError('Connection timeout must be at least 1000ms');
    }
    if (agentConfig['maxAgents'] < 1) {
      throw ArgumentError('Maximum agents must be greater than 0');
    }
    if (workflowConfig['maxWorkflows'] < 1) {
      throw ArgumentError('Maximum workflows must be greater than 0');
    }
    if (templateConfig['maxTemplates'] < 1) {
      throw ArgumentError('Maximum templates must be greater than 0');
    }
  }

  /// Base URL for Ollama API
  static String get baseUrl => switch (Environment.name) {
    'production' => const String.fromEnvironment(
      'OLLAMA_API_URL',
      defaultValue: 'http://localhost:11434',
    ),
    'staging' => const String.fromEnvironment(
      'OLLAMA_API_URL',
      defaultValue: 'http://localhost:11434',
    ),
    _ => 'http://localhost:11434',
  };

  /// Default model to use
  static String get defaultModel => const String.fromEnvironment(
    'OLLAMA_MODEL',
    defaultValue: 'llama3.2',
  );

  /// Maximum context length
  static int get maxContextLength => const int.fromEnvironment(
    'OLLAMA_MAX_CONTEXT_LENGTH',
    defaultValue: 4096,
  );

  /// Default temperature for generation
  static double get defaultTemperature {
    final value = const String.fromEnvironment(
      'OLLAMA_TEMPERATURE',
      defaultValue: '0.7',
    );
    return double.tryParse(value) ?? 0.7;
  }

  /// Default top_p for generation
  static double get defaultTopP {
    final value = const String.fromEnvironment(
      'OLLAMA_TOP_P',
      defaultValue: '0.9',
    );
    return double.tryParse(value) ?? 0.9;
  }

  /// Default top_k for generation
  static int get defaultTopK => const int.fromEnvironment(
    'OLLAMA_TOP_K',
    defaultValue: 40,
  );

  /// Whether to enable streaming by default
  static bool get defaultStreamMode => const bool.fromEnvironment(
    'OLLAMA_STREAM_MODE',
    defaultValue: true,
  );

  /// Connection timeout in milliseconds
  static int get connectionTimeout => const int.fromEnvironment(
    'OLLAMA_CONNECTION_TIMEOUT',
    defaultValue: 30000,
  );

  /// Maximum retries for failed requests
  static int get maxRetries => const int.fromEnvironment(
    'OLLAMA_MAX_RETRIES',
    defaultValue: 3,
  );

  /// Whether to enable debug logging
  static bool get enableDebugLogs => Environment.isDevelopment;

  /// Whether to enable performance tracking
  static bool get trackPerformance => Environment.isDevelopment;

  /// Rate limiting configuration
  static Map<String, dynamic> get rateLimiting => {
    'enabled': const bool.fromEnvironment(
      'OLLAMA_RATE_LIMITING_ENABLED',
      defaultValue: true,
    ),
    'maxRequestsPerMinute': const int.fromEnvironment(
      'OLLAMA_MAX_REQUESTS_PER_MINUTE',
      defaultValue: 60,
    ),
  };

  /// Agent configuration
  static Map<String, dynamic> get agentConfig => {
    'maxAgents': const int.fromEnvironment(
      'OLLAMA_MAX_AGENTS',
      defaultValue: 10,
    ),
    'maxConversationHistory': const int.fromEnvironment(
      'OLLAMA_MAX_CONVERSATION_HISTORY',
      defaultValue: 100,
    ),
  };

  /// Workflow configuration
  static Map<String, dynamic> get workflowConfig => {
    'maxWorkflows': const int.fromEnvironment(
      'OLLAMA_MAX_WORKFLOWS',
      defaultValue: 20,
    ),
    'maxStepsPerWorkflow': const int.fromEnvironment(
      'OLLAMA_MAX_STEPS_PER_WORKFLOW',
      defaultValue: 10,
    ),
  };

  /// Template configuration
  static Map<String, dynamic> get templateConfig => {
    'maxTemplates': const int.fromEnvironment(
      'OLLAMA_MAX_TEMPLATES',
      defaultValue: 50,
    ),
    'maxVariablesPerTemplate': const int.fromEnvironment(
      'OLLAMA_MAX_VARIABLES_PER_TEMPLATE',
      defaultValue: 20,
    ),
  };
} 