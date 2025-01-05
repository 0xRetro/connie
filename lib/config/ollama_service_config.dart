import 'package:freezed_annotation/freezed_annotation.dart';
import 'ollama_config.dart' as global_config;
import '../services/logger_service.dart';

part 'ollama_service_config.freezed.dart';
part 'ollama_service_config.g.dart';

/// Configuration for Ollama service instance
///
/// This class provides a type-safe configuration model for Ollama service settings.
/// It includes validation for all numeric values and integrates with the global configuration.
@freezed
@JsonSerializable()
class OllamaServiceConfig with _$OllamaServiceConfig {
  /// Creates a new service configuration with validation
  ///
  /// All numeric values are validated to ensure they are within acceptable ranges:
  /// - temperature: must be between 0 and 1
  /// - topP: must be between 0 and 1
  /// - topK: must be greater than 0
  /// - contextLength: must be greater than 0
  /// - connectionTimeout: must be at least 1000ms
  @Assert('temperature >= 0 && temperature <= 1', 'Temperature must be between 0 and 1')
  @Assert('topP >= 0 && topP <= 1', 'Top-p must be between 0 and 1')
  @Assert('topK > 0', 'Top-k must be greater than 0')
  @Assert('contextLength > 0', 'Context length must be greater than 0')
  @Assert('connectionTimeout >= 1000', 'Connection timeout must be at least 1000ms')
  const factory OllamaServiceConfig({
    required String baseUrl,
    required String model,
    required int contextLength,
    required double temperature,
    required double topP,
    required int topK,
    required bool stream,
    required int connectionTimeout,
    required bool enableDebugLogs,
    required bool trackPerformance,
  }) = _OllamaServiceConfig;

  /// Creates a configuration instance from JSON data
  ///
  /// Throws [FormatException] if the JSON data is invalid
  factory OllamaServiceConfig.fromJson(Map<String, dynamic> json) {
    try {
      return _$OllamaServiceConfigFromJson(json);
    } catch (e) {
      LoggerService.error(
        'Failed to parse OllamaServiceConfig from JSON',
        error: e,
        data: json,
      );
      rethrow;
    }
  }

  /// Creates a configuration instance from global configuration
  ///
  /// This is the recommended way to create a new service configuration
  /// as it ensures all values are properly synchronized with global settings.
  factory OllamaServiceConfig.fromGlobalConfig() {
    try {
      return OllamaServiceConfig(
        baseUrl: global_config.OllamaConfig.baseUrl,
        model: global_config.OllamaConfig.defaultModel,
        contextLength: global_config.OllamaConfig.maxContextLength,
        temperature: global_config.OllamaConfig.defaultTemperature,
        topP: global_config.OllamaConfig.defaultTopP,
        topK: global_config.OllamaConfig.defaultTopK,
        stream: global_config.OllamaConfig.defaultStreamMode,
        connectionTimeout: global_config.OllamaConfig.connectionTimeout,
        enableDebugLogs: global_config.OllamaConfig.enableDebugLogs,
        trackPerformance: global_config.OllamaConfig.trackPerformance,
      );
    } catch (e) {
      LoggerService.error(
        'Failed to create OllamaServiceConfig from global config',
        error: e,
      );
      rethrow;
    }
  }
} 