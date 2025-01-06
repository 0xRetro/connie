import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/ollama_config.dart';
import '../models/chat_message.dart';
import '../services/logger_service.dart';
import '../services/ollama_service.dart';
import '../config/provider_config.dart';
//import '../services/errors.dart';

/// Manages Ollama configuration state and persistence
///
/// Handles loading, saving, and updating Ollama configuration settings
/// using SharedPreferences for persistence.
class OllamaConfigNotifier extends StateNotifier<OllamaConfig> {
  final SharedPreferences _prefs;
  static const _keyPrefix = 'ollama_config_';

  OllamaConfigNotifier(this._prefs) : super(_loadConfig(_prefs)) {
    LoggerService.debug('Initializing OllamaConfigNotifier', data: {
      'hasStoredConfig': _prefs.containsKey('${_keyPrefix}base_url'),
    });
  }

  static OllamaConfig _loadConfig(SharedPreferences prefs) {
    final config = OllamaConfig(
      baseUrl: prefs.getString('${_keyPrefix}base_url') ?? 'http://localhost:11434',
      model: prefs.getString('${_keyPrefix}model') ?? 'llama2',
      temperature: prefs.getDouble('${_keyPrefix}temperature') ?? 0.7,
      topP: prefs.getDouble('${_keyPrefix}top_p') ?? 0.9,
      topK: prefs.getInt('${_keyPrefix}top_k') ?? 40,
      stream: prefs.getBool('${_keyPrefix}stream') ?? true,
      connectionTimeout: prefs.getInt('${_keyPrefix}timeout') ?? 30000,
      trackPerformance: prefs.getBool('${_keyPrefix}track_performance') ?? true,
      rateLimitInterval: const Duration(minutes: 1),
    );

    LoggerService.debug('Loaded config from preferences', data: {
      'baseUrl': config.baseUrl,
      'model': config.model,
    });

    return config;
  }

  Future<void> _saveConfig(OllamaConfig config) async {
    LoggerService.debug('Saving config to preferences', data: {
      'baseUrl': config.baseUrl,
      'model': config.model,
    });

    await _prefs.setString('${_keyPrefix}base_url', config.baseUrl);
    await _prefs.setString('${_keyPrefix}model', config.model);
    await _prefs.setDouble('${_keyPrefix}temperature', config.temperature);
    await _prefs.setDouble('${_keyPrefix}top_p', config.topP);
    await _prefs.setInt('${_keyPrefix}top_k', config.topK);
    await _prefs.setBool('${_keyPrefix}stream', config.stream);
    await _prefs.setInt('${_keyPrefix}timeout', config.connectionTimeout);
    await _prefs.setBool('${_keyPrefix}track_performance', config.trackPerformance);
  }

  Future<void> updateConfig({
    String? baseUrl,
    String? model,
    double? temperature,
    double? topP,
    int? topK,
    bool? stream,
    int? connectionTimeout,
    bool? trackPerformance,
    Duration? rateLimitInterval,
  }) async {
    LoggerService.debug('Updating config', data: {
      'baseUrl': baseUrl,
      'model': model,
    });

    state = OllamaConfig(
      baseUrl: baseUrl ?? state.baseUrl,
      model: model ?? state.model,
      temperature: temperature ?? state.temperature,
      topP: topP ?? state.topP,
      topK: topK ?? state.topK,
      stream: stream ?? state.stream,
      connectionTimeout: connectionTimeout ?? state.connectionTimeout,
      trackPerformance: trackPerformance ?? state.trackPerformance,
      rateLimitInterval: rateLimitInterval ?? state.rateLimitInterval,
    );
    await _saveConfig(state);
  }

  Future<void> resetToDefaults() async {
    LoggerService.debug('Resetting config to defaults');
    state = const OllamaConfig();
    await _saveConfig(state);
  }
}

/// Global provider for Ollama configuration state
final ollamaConfigProvider = StateNotifierProvider<OllamaConfigNotifier, OllamaConfig>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return OllamaConfigNotifier(prefs);
});

/// Global provider for Ollama service instance
final ollamaServiceProvider = Provider<OllamaService>((ref) {
  final config = ref.watch(ollamaConfigProvider);
  LoggerService.debug('Creating Ollama service provider');
  return OllamaService(config: config);
}, dependencies: [ollamaConfigProvider]);

/// Represents the state of an Ollama chat session
///
/// Tracks message history, loading state, and error conditions
/// for a single chat session.
class OllamaState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;
  final String? currentMessageId;

  const OllamaState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
    this.currentMessageId,
  });

  List<ChatMessage> get chatHistory => messages;

  OllamaState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
    String? currentMessageId,
  }) {
    return OllamaState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentMessageId: currentMessageId,
    );
  }
}

/// Manages chat interaction state with Ollama
///
/// Handles message sending, history management, and error handling
/// for chat interactions with the Ollama service.
class Ollama extends StateNotifier<OllamaState> {
  final OllamaService _service;
  final _uuid = const Uuid();
  StreamSubscription? _subscription;

  Ollama(this._service) : super(const OllamaState()) {
    LoggerService.debug('Initializing Ollama provider');
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  /// Send a message to the Ollama API
  Future<void> sendMessage(String content) async {
    if (state.isLoading) return;

    LoggerService.startGroup('Sending message');

    try {
      final messageId = _uuid.v4();
      final userMessage = ChatMessage(
        id: messageId,
        role: 'user',
        content: content,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, userMessage],
        isLoading: true,
        error: null,
        currentMessageId: messageId,
      );

      String responseContent = '';
      final assistantMessageId = _uuid.v4();

      // Add initial assistant message
      state = state.copyWith(
        messages: [
          ...state.messages,
          ChatMessage(
            id: assistantMessageId,
            role: 'assistant',
            content: '',
            timestamp: DateTime.now(),
          ),
        ],
      );

      await for (final response in _service.generateStream(prompt: content)) {
        LoggerService.debug('Received response chunk', data: {
          'response': response.response,
          'done': response.done,
          'model': response.model,
        });
        
        responseContent += response.response;
        
        // Update the state with each chunk
        state = state.copyWith(
          messages: [
            ...state.messages.where((m) => m.id != assistantMessageId),
            ChatMessage(
              id: assistantMessageId,
              role: 'assistant',
              content: responseContent,
              timestamp: DateTime.now(),
            ),
          ],
        );

        if (response.done) {
          state = state.copyWith(isLoading: false);
          break;
        }
      }
    } catch (e, stackTrace) {
      LoggerService.error(
        'Error sending message',
        error: e,
        stackTrace: stackTrace,
      );
      state = state.copyWith(
        error: 'Failed to send message: ${e.toString()}',
        isLoading: false,
      );
    } finally {
      LoggerService.endGroup('Sending message');
    }
  }

  /// Clear the chat history
  void clearChat() {
    state = const OllamaState();
  }

  /// Clear any error messages
  void clearError() {
    if (state.error != null) {
      state = state.copyWith(error: null);
    }
  }
}

/// Global provider for Ollama chat state
final ollamaProvider = StateNotifierProvider<Ollama, OllamaState>((ref) {
  final service = ref.watch(ollamaServiceProvider);
  return Ollama(service);
}, dependencies: [ollamaServiceProvider, ollamaConfigProvider]); 