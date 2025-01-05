// ignore_for_file: invalid_annotation_target

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../config/ollama_config.dart' as config;
import '../config/ollama_service_config.dart';
import '../models/ollama_agent.dart';
import '../services/logger_service.dart';
import '../services/ollama_service.dart';

part 'ollama_provider.freezed.dart';
part 'ollama_provider.g.dart';

// Configuration keys
const _kBaseUrlKey = 'ollama_base_url';
const _kModelNameKey = 'ollama_model_name';
const _kTemperatureKey = 'ollama_temperature';
const _kContextLengthKey = 'ollama_context_length';

/// Main state for Ollama functionality
@freezed
class OllamaState with _$OllamaState {
  const factory OllamaState({
    @Default({}) Map<String, OllamaAgent> agents,
    @Default({}) Map<String, OllamaWorkflow> workflows,
    @Default({}) Map<String, OllamaPromptTemplate> templates,
    @Default([]) List<OllamaMessage> chatHistory,
    @Default(false) bool isLoading,
    @JsonKey(ignore: true) AsyncValue<OllamaServiceConfig>? config,
    String? error,
  }) = _OllamaState;

  factory OllamaState.fromJson(Map<String, dynamic> json) =>
      _$OllamaStateFromJson(json);
}

/// Provider for Ollama service configuration
@riverpod
class OllamaConfig extends _$OllamaConfig {
  late final SharedPreferences _prefs;

  @override
  FutureOr<OllamaServiceConfig> build() async {
    _prefs = await SharedPreferences.getInstance();
    
    return OllamaServiceConfig(
      baseUrl: _prefs.getString(_kBaseUrlKey) ?? 'http://localhost:11434',
      model: _prefs.getString(_kModelNameKey) ?? 'llama3.2',
      contextLength: _prefs.getInt(_kContextLengthKey) ?? 4096,
      temperature: _prefs.getDouble(_kTemperatureKey) ?? 0.7,
      topP: 0.9,
      topK: 40,
      stream: true,
      connectionTimeout: 30000,
      enableDebugLogs: true,
      trackPerformance: true,
    );
  }

  Future<void> saveSettings() async {
    final config = state.valueOrNull;
    if (config == null) return;

    await _prefs.setString(_kBaseUrlKey, config.baseUrl);
    await _prefs.setString(_kModelNameKey, config.model);
    await _prefs.setDouble(_kTemperatureKey, config.temperature);
    await _prefs.setInt(_kContextLengthKey, config.contextLength);
    
    state = AsyncData(config);
  }

  Future<bool> testConnection() async {
    final config = state.valueOrNull;
    if (config == null) return false;
    
    try {
      final dio = Dio(BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: Duration(milliseconds: config.connectionTimeout),
      ));
      
      final response = await dio.get('/api/tags');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  void updateBaseUrl(String value) {
    final config = state.valueOrNull;
    if (config == null) return;
    state = AsyncData(config.copyWith(baseUrl: value));
  }

  void updateModelName(String value) {
    final config = state.valueOrNull;
    if (config == null) return;
    state = AsyncData(config.copyWith(model: value));
  }

  void updateTemperature(double value) {
    final config = state.valueOrNull;
    if (config == null) return;
    if (value >= 0.0 && value <= 1.0) {
      state = AsyncData(config.copyWith(temperature: value));
    }
  }

  void updateContextLength(int value) {
    final config = state.valueOrNull;
    if (config == null) return;
    if (value > 0) {
      state = AsyncData(config.copyWith(contextLength: value));
    }
  }

  Future<void> resetToDefaults() async {
    final defaultConfig = OllamaServiceConfig(
      baseUrl: 'http://localhost:11434',
      model: 'llama3.2',
      contextLength: 4096,
      temperature: 0.7,
      topP: 0.9,
      topK: 40,
      stream: true,
      connectionTimeout: 30000,
      enableDebugLogs: true,
      trackPerformance: true,
    );
    
    state = AsyncData(defaultConfig);
    await saveSettings();
  }
}

/// Provider for Ollama service instance
@riverpod
Future<OllamaService> ollamaService(Ref ref) async {
  LoggerService.debug('Creating Ollama service provider');
  final config = await ref.watch(ollamaConfigProvider.future);
  return OllamaService(config: config);
}

/// Main provider for Ollama functionality
@riverpod
class Ollama extends _$Ollama {
  @override
  OllamaState build() {
    LoggerService.debug('Initializing Ollama provider');
    return const OllamaState();
  }

  Future<OllamaService> get _service async => 
    await ref.read(ollamaServiceProvider.future);

  Future<void> loadAgents() async {
    LoggerService.startGroup('Loading agents');
    state = state.copyWith(isLoading: true, error: null);
    try {
      final service = await _service;
      final agentList = await service.listAgents();
      final agents = <String, OllamaAgent>{};
      for (final agent in agentList) {
        final details = await service.getAgent(agent['name'] as String);
        agents[agent['name'] as String] = OllamaAgent.fromJson(details);
      }
      state = state.copyWith(agents: agents, isLoading: false);
      LoggerService.info('Loaded ${agents.length} agents');
    } catch (e) {
      LoggerService.error(
        'Failed to load agents',
        error: e,
      );
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load agents: $e',
      );
    } finally {
      LoggerService.endGroup('Loading agents');
    }
  }

  Future<void> createAgent({
    required String name,
    required String systemPrompt,
    Map<String, dynamic>? metadata,
  }) async {
    LoggerService.startGroup('Creating agent');
    state = state.copyWith(isLoading: true, error: null);
    try {
      if (state.agents.length >= config.OllamaConfig.agentConfig['maxAgents']) {
        throw Exception('Maximum number of agents reached');
      }

      final service = await _service;
      await service.createAgent(
        name: name,
        systemPrompt: systemPrompt,
        metadata: metadata,
      );
      await loadAgents();
      LoggerService.info('Created agent: $name');
    } catch (e) {
      LoggerService.error(
        'Failed to create agent',
        error: e,
        data: {'name': name},
      );
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create agent: $e',
      );
    } finally {
      LoggerService.endGroup('Creating agent');
    }
  }

  Future<void> deleteAgent(String name) async {
    LoggerService.startGroup('Deleting agent');
    state = state.copyWith(isLoading: true, error: null);
    try {
      final service = await _service;
      await service.deleteAgent(name);
      final agents = Map<String, OllamaAgent>.from(state.agents)
        ..remove(name);
      state = state.copyWith(agents: agents, isLoading: false);
      LoggerService.info('Deleted agent: $name');
    } catch (e) {
      LoggerService.error(
        'Failed to delete agent',
        error: e,
        data: {'name': name},
      );
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to delete agent: $e',
      );
    } finally {
      LoggerService.endGroup('Deleting agent');
    }
  }

  Future<void> sendMessage(String content) async {
    LoggerService.startGroup('Sending message');
    state = state.copyWith(isLoading: true, error: null);
    try {
      final userMessage = OllamaMessage(
        role: 'user',
        content: content,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        chatHistory: [...state.chatHistory, userMessage],
      );

      final service = await _service;
      final response = await service.generate(prompt: content);

      final assistantMessage = OllamaMessage(
        role: 'assistant',
        content: response.response,
        metadata: {
          'model': response.model,
          'totalDuration': response.totalDuration,
          'evalCount': response.evalCount,
        },
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        chatHistory: [...state.chatHistory, assistantMessage],
        isLoading: false,
      );
      LoggerService.info('Message sent and response received');
    } catch (e) {
      LoggerService.error(
        'Failed to send message',
        error: e,
      );
      final errorMessage = OllamaMessage(
        role: 'assistant',
        content: 'Failed to generate response',
        metadata: {'error': e.toString()},
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        chatHistory: [...state.chatHistory, errorMessage],
        isLoading: false,
        error: 'Failed to send message: $e',
      );
      rethrow;
    } finally {
      LoggerService.endGroup('Sending message');
    }
  }

  Future<void> clearChat() async {
    state = state.copyWith(chatHistory: []);
  }

  Stream<String> generateStreamResponse({
    required String agentName,
    required String prompt,
    Map<String, dynamic>? context,
  }) async* {
    LoggerService.startGroup('Generating stream response');
    state = state.copyWith(isLoading: true, error: null);
    try {
      if (!state.agents.containsKey(agentName)) {
        throw Exception('Agent not found: $agentName');
      }

      final agent = state.agents[agentName]!;
      final maxHistory = config.OllamaConfig.agentConfig['maxConversationHistory'];
      final updatedConversation = [
        ...agent.conversation.length >= maxHistory
            ? agent.conversation.skip(2)
            : agent.conversation,
        OllamaMessage(
          role: 'user',
          content: prompt,
          timestamp: DateTime.now(),
        ),
      ];

      String fullResponse = '';
      final service = await _service;
      await for (final response in service.generateStream(
        prompt: prompt,
        context: context,
      )) {
        fullResponse += response.response;
        yield response.response;

        if (response.done) {
          final agents = Map<String, OllamaAgent>.from(state.agents)
            ..[agentName] = agent.copyWith(
              conversation: [
                ...updatedConversation,
                OllamaMessage(
                  role: 'assistant',
                  content: fullResponse,
                  timestamp: DateTime.now(),
                  metadata: {
                    'totalDuration': response.totalDuration,
                    'evalCount': response.evalCount,
                  },
                ),
              ],
            );
          state = state.copyWith(agents: agents, isLoading: false);
          LoggerService.info('Completed stream response for agent: $agentName');
        }
      }
    } catch (e) {
      LoggerService.error(
        'Failed to generate stream response',
        error: e,
        data: {'agentName': agentName},
      );
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to generate stream response: $e',
      );
      rethrow;
    } finally {
      LoggerService.endGroup('Generating stream response');
    }
  }
} 