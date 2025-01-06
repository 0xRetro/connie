import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
//import 'dart:typed_data';

import 'package:dio/dio.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:uuid/uuid.dart';
import 'package:retry/retry.dart';

import '../config/ollama_config.dart';
import '../models/ollama_response.dart';
import '../services/logger_service.dart';
import 'rate_limiter.dart';
import 'errors.dart';

/// Service for interacting with Ollama API
class OllamaService {
  final OllamaConfig config;
  final Dio _dio;
  final RateLimiter _rateLimiter;
  bool _isDisposed = false;

  OllamaService({
    required this.config,
  }) : _dio = Dio(BaseOptions(
          baseUrl: config.baseUrl,
          connectTimeout: Duration(milliseconds: config.connectionTimeout),
          receiveTimeout: Duration(milliseconds: config.connectionTimeout),
          sendTimeout: Duration(milliseconds: config.connectionTimeout),
        )),
        _rateLimiter = RateLimiter(
          maxRequests: config.maxRequestsPerMinute,
          interval: config.rateLimitInterval,
        ) {
    _validateConfig(config);
    LoggerService.debug('Initializing OllamaService', data: {
      'baseUrl': config.baseUrl,
      'model': config.model,
    });

    if (config.enableDebugLogs) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => LoggerService.debug('Dio: $obj'),
      ));
    }

    // Configure Dio with better defaults
    _dio.options = BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: Duration(milliseconds: config.connectionTimeout),
      receiveTimeout: Duration(milliseconds: config.connectionTimeout),
      sendTimeout: Duration(milliseconds: config.connectionTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) => 
        status != null && status >= 200 && status < 300,
      responseType: ResponseType.json,
      listFormat: ListFormat.multiCompatible,
    );

    // Add logging interceptor with better formatting
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) {
        if (obj is Map || obj is List) {
          LoggerService.debug('Dio: ${const JsonEncoder.withIndent('  ').convert(obj)}');
        } else {
          LoggerService.debug('Dio: $obj');
        }
      },
      error: true,
      request: true,
      requestHeader: true,
      responseHeader: true,
    ));

    // Add retry interceptor
    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_isDisposed) {
            handler.reject(
              DioException(
                requestOptions: options,
                error: 'Service is disposed',
                type: DioExceptionType.cancel,
              ),
            );
            return;
          }

          if (!_rateLimiter.checkLimit()) {
            handler.reject(
              DioException(
                requestOptions: options,
                error: RateLimitError(
                  'Rate limit exceeded',
                  retryAfter: config.rateLimitInterval,
                ),
                type: DioExceptionType.cancel,
              ),
            );
            return;
          }

          handler.next(options);
        },
        onError: (error, handler) async {
          if (_isDisposed) {
            handler.reject(error);
            return;
          }

          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.receiveTimeout) {
            // Add exponential backoff for timeouts
            final retryCount = error.requestOptions.extra['retryCount'] as int? ?? 0;
            if (retryCount < 3) {
              final delay = Duration(milliseconds: (math.pow(2, retryCount) * 1000).toInt());
              await Future.delayed(delay);

              final options = error.requestOptions;
              options.extra['retryCount'] = retryCount + 1;

              try {
                final response = await _dio.fetch(options);
                handler.resolve(response);
                return;
              } catch (e) {
                handler.reject(error);
                return;
              }
            }
          }

          handler.reject(error);
        },
      ),
    );
  }

  /// Validates the Ollama configuration
  void _validateConfig(OllamaConfig config) {
    if (config.baseUrl.isEmpty) {
      throw const ConfigError('Base URL cannot be empty');
    }
    if (config.model.isEmpty) {
      throw const ConfigError('Model name cannot be empty');
    }
    if (config.temperature < 0 || config.temperature > 1) {
      throw const ConfigError('Temperature must be between 0 and 1');
    }
    if (config.topP < 0 || config.topP > 1) {
      throw const ConfigError('Top P must be between 0 and 1');
    }
    if (config.topK < 1) {
      throw const ConfigError('Top K must be greater than 0');
    }
    if (config.connectionTimeout < 1000) {
      throw const ConfigError('Connection timeout must be at least 1000ms');
    }
  }

  /// Checks if the Ollama server is healthy
  Future<bool> isHealthy() async {
    try {
      await testConnection();
      return true;
    } catch (e) {
      LoggerService.error('Health check failed', error: e);
      return false;
    }
  }

  /// Dispose of the service and cleanup resources
  void dispose() {
    _isDisposed = true;
    _dio.close(force: true);
  }

  /// Test the connection to the Ollama server
  Future<void> testConnection() async {
    LoggerService.debug('Testing connection to Ollama server', data: {
      'baseUrl': config.baseUrl,
      'timeout': config.connectionTimeout,
    });

    try {
      // First try OpenAI-compatible endpoint
      if (config.baseUrl.endsWith('/v1')) {
        final response = await _dio.get(
          '/models',
          options: Options(
            validateStatus: (status) => status != null && status >= 200 && status < 300,
            responseType: ResponseType.json,
          ),
        );
        
        if (response.statusCode != 200) {
          throw ApiError(
            'Ollama server returned status code: ${response.statusCode}',
            endpoint: '/models',
            statusCode: response.statusCode,
          );
        }

        final models = response.data['data'] as List?;
        if (models == null || models.isEmpty) {
          throw const ConfigError('No models available on the server');
        }

        LoggerService.debug('Successfully connected to Ollama server (OpenAI-compatible)', data: {
          'models': models.map((m) => m['id']).toList(),
        });
        return;
      }

      // Try native Ollama endpoint
      final response = await _dio.get(
        '/api/tags',
        options: Options(
          validateStatus: (status) => status != null && status >= 200 && status < 300,
          responseType: ResponseType.json,
        ),
      );
      
      if (response.statusCode != 200) {
        throw ApiError(
          'Ollama server returned status code: ${response.statusCode}',
          endpoint: '/api/tags',
          statusCode: response.statusCode,
        );
      }

      final models = response.data['models'] as List?;
      if (models == null || models.isEmpty) {
        throw const ConfigError('No models available on the server');
      }

      LoggerService.debug('Successfully connected to Ollama server', data: {
        'models': models,
      });
    } catch (e, stack) {
      LoggerService.error('Failed to connect to Ollama server', error: e);
      
      if (e is DioException) {
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
            throw ApiError(
              'Connection timed out. Please check if Ollama is running.',
              endpoint: '/api/tags',
              statusCode: e.response?.statusCode,
              originalError: e,
              stackTrace: stack,
            );
          case DioExceptionType.connectionError:
            throw ApiError(
              'Could not connect to Ollama. Please check if it is running at ${config.baseUrl}',
              endpoint: '/api/tags',
              originalError: e,
              stackTrace: stack,
            );
          case DioExceptionType.badResponse:
            final statusCode = e.response?.statusCode;
            if (statusCode == 404) {
              throw ConfigError(
                'Ollama API endpoint not found. Please check the server URL.',
                originalError: e,
                stackTrace: stack,
              );
            }
            throw ApiError(
              'Ollama server returned an error: $statusCode - ${e.response?.data}',
              endpoint: '/api/tags',
              statusCode: statusCode,
              originalError: e,
              stackTrace: stack,
            );
          default:
            throw ApiError(
              'Failed to connect to Ollama: ${e.message}',
              endpoint: '/api/tags',
              originalError: e,
              stackTrace: stack,
            );
        }
      }

      throw ApiError(
        'Failed to connect to Ollama: $e',
        endpoint: '/api/tags',
        originalError: e,
        stackTrace: stack,
      );
    }
  }

  /// Generate a streaming response for the given prompt
  ///
  /// [prompt] The input text to send to the model
  /// [context] Optional context from previous interactions
  /// [cancelToken] Optional token for cancelling the request
  ///
  /// Throws:
  /// - [ApiError] for API-related errors
  /// - [StreamError] for streaming-related errors
  /// - [ConfigError] for configuration issues
  /// - [RateLimitError] when rate limit is exceeded
  Stream<OllamaResponse> generateStream({
    required String prompt,
    Map<String, dynamic>? context,
    CancelToken? cancelToken,
  }) async* {
    if (prompt.trim().isEmpty) {
      throw ConfigError('Prompt cannot be empty');
    }

    // Check rate limit
    if (!_rateLimiter.checkLimit()) {
      final retryAfter = _rateLimiter.timeUntilNextWindow();
      throw RateLimitError(
        'Rate limit exceeded',
        retryAfter: retryAfter,
      );
    }

    final endpoint = config.baseUrl.endsWith('/v1') 
        ? '/chat/completions'
        : '/api/generate';

    final startTime = DateTime.now();
    LoggerService.debug('Generating stream response', data: {
      'model': config.model,
      'prompt': prompt,
      'endpoint': endpoint,
      'hasContext': context != null,
    });

    Response<ResponseBody>? response;
    Stream<List<int>>? responseStream;
    
    try {
      response = await retry(
        () => _dio.post<ResponseBody>(
          endpoint,
          data: config.baseUrl.endsWith('/v1')
              ? {
                  'model': config.model,
                  'messages': [
                    {'role': 'user', 'content': prompt}
                  ],
                  'stream': config.stream,
                  'temperature': config.temperature,
                  'top_p': config.topP,
                  'top_k': config.topK,
                }
              : {
                  'model': config.model,
                  'prompt': prompt,
                  'stream': config.stream,
                  'temperature': config.temperature,
                  'top_p': config.topP,
                  'top_k': config.topK,
                },
          options: Options(
            responseType: ResponseType.stream,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
          cancelToken: cancelToken,
        ),
        retryIf: (e) => e is DioError && e.type != DioErrorType.cancel,
        maxAttempts: 3,
      );

      if (response?.statusCode != 200) {
        throw ApiError(
          'HTTP Error ${response?.statusCode}',
          endpoint: endpoint,
          statusCode: response?.statusCode,
        );
      }

      responseStream = response?.data?.stream;
      if (responseStream == null) {
        throw StreamError(
          'No response stream available',
          connectionUrl: '${config.baseUrl}$endpoint',
        );
      }

      String buffer = '';
      await for (final chunk in responseStream.asBroadcastStream()) {
        buffer += utf8.decode(chunk);
        
        while (buffer.contains('\n')) {
          final index = buffer.indexOf('\n');
          final line = buffer.substring(0, index).trim();
          buffer = buffer.substring(index + 1);

          if (line.isEmpty) continue;

          LoggerService.debug('Received chunk', data: {
            'chunk': line,
          });

          try {
            final json = jsonDecode(line);
            final ollamaResponse = OllamaResponse.fromJson(json);
            
            if (ollamaResponse.response.isNotEmpty || ollamaResponse.done) {
              yield ollamaResponse;
            }

            if (ollamaResponse.done) {
              final endTime = DateTime.now();
              final duration = endTime.difference(startTime);
              LoggerService.info('Stream completed', data: {
                'duration': duration.inMilliseconds,
                'metrics': ollamaResponse.metrics,
              });

              if (config.trackPerformance) {
                LoggerService.logPerformance('generateStream', duration);
              }
              return;
            }
          } catch (e, stack) {
            LoggerService.error(
              'Error parsing response',
              error: e,
              stackTrace: stack,
              data: {'line': line},
            );
            continue;
          }
        }
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.cancel) {
        LoggerService.debug('Request cancelled');
        return;
      }
      rethrow;
    } finally {
      // Stream is already consumed, no need to drain
    }
  }
} 