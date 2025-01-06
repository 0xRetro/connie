import 'package:freezed_annotation/freezed_annotation.dart';

import '../services/errors.dart';
import '../services/logger_service.dart';

part 'ollama_response.freezed.dart';
part 'ollama_response.g.dart';

/// Response from the Ollama API, supporting both native and OpenAI-compatible formats
@freezed
@JsonSerializable(explicitToJson: true)
abstract class OllamaResponse with _$OllamaResponse {
  /// Creates a new Ollama response
  /// 
  /// Throws [ArgumentError] if required fields are invalid
  const factory OllamaResponse({
    required String model,
    required String response,
    required bool done,
    DateTime? createdAt,
    Map<String, dynamic>? metrics,
  }) = _OllamaResponse;

  factory OllamaResponse.fromJson(Map<String, dynamic> json) {
    try {
      LoggerService.debug('Parsing Ollama response', data: json);
      
      if (json.isEmpty) {
        throw const ParseError('Empty response data', responseData: '{}');
      }

      if (json.containsKey('error')) {
        throw ApiError(
          json['error'].toString(),
          endpoint: '/generate',
          statusCode: json['code'] as int?,
        );
      }

      if (json.containsKey('choices')) {
        LoggerService.debug('Using OpenAI format parser');
        return _parseOpenAIFormat(json);
      }

      LoggerService.debug('Using Ollama format parser');
      final response = _parseOllamaFormat(json);
      LoggerService.debug('Successfully parsed response', data: {
        'model': response.model,
        'response': response.response,
        'done': response.done,
        'metrics': response.metrics,
      });
      return response;
    } catch (e, stack) {
      LoggerService.error(
        'Failed to parse response',
        error: e,
        data: json,
        stackTrace: stack,
      );
      // If custom parsing fails, try using the generated fromJson
      return _$OllamaResponseFromJson(json);
    }
  }

  /// Parses response in OpenAI format
  static OllamaResponse _parseOpenAIFormat(Map<String, dynamic> json) {
    final choices = json['choices'] as List;
    if (choices.isEmpty) {
      throw ParseError(
        'Empty choices array in response',
        responseData: json.toString(),
      );
    }
    
    final choice = choices.first;
    String content;
    
    if (choice.containsKey('delta')) {
      // Streaming response
      final delta = choice['delta'] as Map<String, dynamic>;
      content = delta['content'] as String? ?? '';
    } else if (choice.containsKey('message')) {
      // Non-streaming response
      final message = choice['message'] as Map<String, dynamic>;
      content = message['content'] as String? ?? '';
    } else {
      throw ParseError(
        'Invalid choice format in response',
        responseData: json.toString(),
      );
    }

    return OllamaResponse(
      model: json['model'] as String? ?? 'unknown',
      response: content,
      done: choice['finish_reason'] != null,
      createdAt: json['created'] != null 
        ? DateTime.fromMillisecondsSinceEpoch((json['created'] as int) * 1000) 
        : null,
    );
  }

  /// Parses response in native Ollama format
  static OllamaResponse _parseOllamaFormat(Map<String, dynamic> json) {
    if (!json.containsKey('model') || !json.containsKey('response')) {
      throw ParseError(
        'Missing required fields in response',
        responseData: json.toString(),
      );
    }

    // Extract response content
    final response = json['response'] as String?;
    final isDone = json['done'] as bool? ?? false;
    
    // Allow empty response if it's the final message
    if (response == null || (response.isEmpty && !isDone)) {
      throw ParseError(
        'Empty or invalid response content',
        responseData: json.toString(),
      );
    }

    // Extract performance metrics if available
    final metrics = <String, dynamic>{};
    final metricsFields = [
      'total_duration',
      'load_duration',
      'prompt_eval_count',
      'eval_count',
      'eval_duration',
    ];

    for (final field in metricsFields) {
      if (json.containsKey(field)) {
        metrics[field] = json[field];
      }
    }

    return OllamaResponse(
      model: json['model'] as String,
      response: response,
      done: json['done'] as bool? ?? false,
      metrics: metrics.isNotEmpty ? metrics : null,
    );
  }
}