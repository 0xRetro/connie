import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:retry/retry.dart';

import '../config/ollama_config.dart';
import '../config/ollama_service_config.dart';
import '../services/logger_service.dart';
import 'rate_limiter.dart';
import 'errors.dart';

part 'ollama_service.freezed.dart';
part 'ollama_service.g.dart';

@freezed
class OllamaResponse with _$OllamaResponse {
  const factory OllamaResponse({
    required String model,
    required String response,
    required bool done,
    double? totalDuration,
    double? loadDuration,
    double? promptEvalCount,
    double? evalCount,
    double? evalDuration,
  }) = _OllamaResponse;

  factory OllamaResponse.fromJson(Map<String, dynamic> json) =>
      _$OllamaResponseFromJson(json);
}

/// Service for interacting with Ollama API
class OllamaService {
  OllamaService({
    required this.config,
    Dio? dio,
  }) : _dio = dio ?? Dio() {
    LoggerService.debug('Initializing OllamaService', data: {
      'baseUrl': config.baseUrl,
      'model': config.model,
      'modelFromConfig': config.model,
    });

    _dio.options.baseUrl = config.baseUrl;
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
    _dio.options.connectTimeout = Duration(
      milliseconds: config.connectionTimeout,
    );
    _dio.options.receiveTimeout = Duration(
      milliseconds: config.connectionTimeout,
    );

    if (config.enableDebugLogs) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => LoggerService.debug('Dio: $obj'),
      ));
    }

    // Add rate limiting interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (!_rateLimiter.tryAcquire()) {
            handler.reject(
              DioException(
                requestOptions: options,
                error: RateLimitError(
                  'Rate limit exceeded',
                  retryAfter: const Duration(minutes: 1),
                ),
              ),
            );
            return;
          }
          handler.next(options);
        },
      ),
    );
  }

  final OllamaServiceConfig config;
  final Dio _dio;
  final _uuid = const Uuid();
  final _rateLimiter = RateLimiter(
    maxRequests: OllamaConfig.rateLimiting['maxRequestsPerMinute'] as int,
    interval: const Duration(minutes: 1),
  );

  /// Generate a response for the given prompt
  Future<OllamaResponse> generate({
    required String prompt,
    Map<String, dynamic>? context,
    bool? stream,
  }) async {
    try {
      LoggerService.debug('Generating response', data: {
        'model': config.model,
        'stream': stream ?? config.stream,
      });

      final startTime = DateTime.now();

      final response = await retry(
        () => _dio.post(
          '/api/generate',
          data: {
            'model': config.model,
            'prompt': prompt,
            'context': context,
            'stream': stream ?? config.stream,
            'options': {
              'temperature': config.temperature,
              'top_p': config.topP,
              'top_k': config.topK,
            },
          },
        ),
        retryIf: (e) => e is DioException && e.type != DioExceptionType.cancel,
        maxAttempts: OllamaConfig.maxRetries,
      );

      final result = OllamaResponse.fromJson(response.data);
      final duration = DateTime.now().difference(startTime);

      if (config.trackPerformance) {
        LoggerService.logPerformance('generate', duration);
      }

      LoggerService.debug('Generated response', data: {
        'totalDuration': result.totalDuration,
        'evalCount': result.evalCount,
      });

      return result;
    } on DioException catch (e, stack) {
      LoggerService.error(
        'Failed to generate response',
        error: e,
        data: {'model': config.model},
      );
      throw ApiError(
        'Failed to generate response',
        statusCode: e.response?.statusCode,
        endpoint: '/api/generate',
        originalError: e,
        stackTrace: stack,
      );
    } catch (e, stack) {
      LoggerService.error(
        'Failed to generate response',
        error: e,
        data: {'model': config.model},
      );
      throw ConfigError(
        'Failed to generate response',
        originalError: e,
        stackTrace: stack,
      );
    }
  }

  /// Generate a streaming response for the given prompt
  Stream<OllamaResponse> generateStream({
    required String prompt,
    Map<String, dynamic>? context,
  }) async* {
    LoggerService.debug('Starting stream generation', data: {
      'model': config.model,
    });

    final uri = Uri.parse('${config.baseUrl}/api/generate');
    WebSocketChannel? channel;
    final startTime = DateTime.now();

    try {
      channel = WebSocketChannel.connect(uri);

      LoggerService.debug('Sending chat request', data: {
        'model': config.model,
        'prompt': prompt,
        'context': context,
        'options': {
          'temperature': config.temperature,
          'top_p': config.topP,
          'top_k': config.topK,
        },
      });

      channel.sink.add(jsonEncode({
        'model': config.model,
        'prompt': prompt,
        'context': context,
        'stream': true,
        'options': {
          'temperature': config.temperature,
          'top_p': config.topP,
          'top_k': config.topK,
        },
      }));

      await for (final message in channel.stream) {
        try {
          final data = jsonDecode(message as String);
          yield OllamaResponse.fromJson(data);
        } catch (e, stack) {
          throw ParseError(
            'Failed to parse stream response',
            responseData: message.toString(),
            originalError: e,
            stackTrace: stack,
          );
        }
      }

      if (config.trackPerformance) {
        final duration = DateTime.now().difference(startTime);
        LoggerService.logPerformance('generateStream', duration);
      }
    } catch (e, stack) {
      LoggerService.error(
        'Stream generation failed',
        error: e,
        data: {'model': config.model},
      );
      throw StreamError(
        'Stream generation failed',
        connectionUrl: uri.toString(),
        originalError: e,
        stackTrace: stack,
      );
    } finally {
      LoggerService.debug('Closing stream connection');
      channel?.sink.close();
    }
  }

  /// Create a new agent
  Future<void> createAgent({
    required String name,
    required String systemPrompt,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      LoggerService.debug('Creating agent', data: {
        'name': name,
        'model': config.model,
      });

      await retry(
        () => _dio.post(
          '/api/agents',
          data: {
            'name': name,
            'model': config.model,
            'system_prompt': systemPrompt,
            'metadata': metadata ?? {},
          },
        ),
        retryIf: (e) => e is DioException && e.type != DioExceptionType.cancel,
        maxAttempts: OllamaConfig.maxRetries,
      );

      LoggerService.info('Agent created successfully', data: {
        'name': name,
      });
    } catch (e, stack) {
      LoggerService.error(
        'Failed to create agent',
        error: e,
        data: {'name': name},
      );
      throw ApiError(
        'Failed to create agent',
        endpoint: '/api/agents',
        originalError: e,
        stackTrace: stack,
      );
    }
  }

  /// Get agent details
  Future<Map<String, dynamic>> getAgent(String name) async {
    try {
      LoggerService.debug('Fetching agent', data: {'name': name});
      final response = await retry(
        () => _dio.get('/api/agents/$name'),
        retryIf: (e) => e is DioException && e.type != DioExceptionType.cancel,
        maxAttempts: OllamaConfig.maxRetries,
      );
      return response.data;
    } catch (e, stack) {
      LoggerService.error(
        'Failed to get agent',
        error: e,
        data: {'name': name},
      );
      throw ApiError(
        'Failed to get agent',
        endpoint: '/api/agents/$name',
        originalError: e,
        stackTrace: stack,
      );
    }
  }

  /// List all agents
  Future<List<Map<String, dynamic>>> listAgents() async {
    try {
      LoggerService.debug('Listing agents');
      final response = await retry(
        () => _dio.get('/api/agents'),
        retryIf: (e) => e is DioException && e.type != DioExceptionType.cancel,
        maxAttempts: OllamaConfig.maxRetries,
      );
      return List<Map<String, dynamic>>.from(response.data['agents']);
    } catch (e, stack) {
      LoggerService.error('Failed to list agents', error: e);
      throw ApiError(
        'Failed to list agents',
        endpoint: '/api/agents',
        originalError: e,
        stackTrace: stack,
      );
    }
  }

  /// Delete an agent
  Future<void> deleteAgent(String name) async {
    try {
      LoggerService.debug('Deleting agent', data: {'name': name});
      await retry(
        () => _dio.delete('/api/agents/$name'),
        retryIf: (e) => e is DioException && e.type != DioExceptionType.cancel,
        maxAttempts: OllamaConfig.maxRetries,
      );
      LoggerService.info('Agent deleted successfully', data: {'name': name});
    } catch (e, stack) {
      LoggerService.error(
        'Failed to delete agent',
        error: e,
        data: {'name': name},
      );
      throw ApiError(
        'Failed to delete agent',
        endpoint: '/api/agents/$name',
        originalError: e,
        stackTrace: stack,
      );
    }
  }
}

final ollamaConfigProvider = Provider<OllamaServiceConfig>((ref) {
  LoggerService.debug('Creating Ollama config provider');
  return OllamaServiceConfig.fromGlobalConfig();
});

final ollamaServiceProvider = Provider<OllamaService>((ref) {
  LoggerService.debug('Creating Ollama service provider');
  final config = ref.watch(ollamaConfigProvider);
  return OllamaService(config: config);
}); 