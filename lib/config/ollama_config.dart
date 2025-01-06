import 'package:freezed_annotation/freezed_annotation.dart';
import 'environment.dart';

part 'ollama_config.freezed.dart';
part 'ollama_config.g.dart';

/// Configuration for the Ollama service
///
/// Contains all settings required for interacting with an Ollama instance,
/// including connection details, model parameters, and performance settings.
@freezed
class OllamaConfig with _$OllamaConfig {
  /// Creates a new Ollama configuration instance
  /// 
  /// Default values are loaded from [Environment.ollamaConfig]
  const factory OllamaConfig({
    /// Base URL of the Ollama server
    @Default('http://localhost:11434') String baseUrl,
    
    /// Model to use for generation
    @Default('llama3.2:latest') String model,
    
    /// Context length for the model
    @Default(4096) int contextLength,
    
    /// Temperature for response generation (0.0 to 1.0)
    /// Higher values make output more random
    @Default(0.7) double temperature,
    
    /// Top-p sampling parameter (0.0 to 1.0)
    /// Controls diversity of responses
    @Default(0.9) double topP,
    
    /// Top-k sampling parameter
    /// Limits vocabulary for response generation
    @Default(40) int topK,
    
    /// Whether to use streaming responses
    /// Recommended for chat interfaces
    @Default(true) bool stream,
    
    /// Connection timeout in milliseconds
    /// Defaults to 30 seconds
    @Default(30000) int connectionTimeout,
    
    /// Whether to track performance metrics
    @Default(true) bool trackPerformance,
    
    /// Whether to enable debug logging
    @Default(true) bool enableDebugLogs,
    
    /// Maximum requests per minute
    @Default(60) int maxRequestsPerMinute,
    
    /// Interval for rate limiting requests
    @Default(Duration(minutes: 1)) Duration rateLimitInterval,
  }) = _OllamaConfig;

  /// Creates a configuration from JSON
  factory OllamaConfig.fromJson(Map<String, dynamic> json) => 
      _$OllamaConfigFromJson(json);
      
  /// Creates a configuration from environment settings
  factory OllamaConfig.fromEnvironment() {
    final config = Environment.ollamaConfig;
    return OllamaConfig(
      baseUrl: config['baseUrl'] as String? ?? 'http://localhost:11434',
      model: config['model'] as String? ?? 'llama3.2:latest',
      contextLength: config['contextLength'] as int? ?? 4096,
      temperature: config['temperature'] as double? ?? 0.7,
      topP: config['topP'] as double? ?? 0.9,
      topK: config['topK'] as int? ?? 40,
      stream: config['stream'] as bool? ?? true,
      connectionTimeout: config['connectionTimeout'] as int? ?? 30000,
      trackPerformance: config['trackPerformance'] as bool? ?? true,
      enableDebugLogs: config['enableDebugLogs'] as bool? ?? true,
      maxRequestsPerMinute: config['maxRequestsPerMinute'] as int? ?? 60,
      rateLimitInterval: config['rateLimitInterval'] as Duration? ?? const Duration(minutes: 1),
    );
  }
} 