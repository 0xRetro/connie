import 'package:freezed_annotation/freezed_annotation.dart';

part 'ollama_agent.freezed.dart';
part 'ollama_agent.g.dart';

@freezed
class OllamaConfigModel with _$OllamaConfigModel {
  const factory OllamaConfigModel({
    required String baseUrl,
    required String modelName,
    @Default(0.7) double temperature,
    @Default(4096) int contextLength,
  }) = _OllamaConfigModel;

  factory OllamaConfigModel.fromJson(Map<String, dynamic> json) =>
      _$OllamaConfigModelFromJson(json);
}

@freezed
class OllamaAgent with _$OllamaAgent {
  const factory OllamaAgent({
    required String name,
    required String model,
    required String systemPrompt,
    @Default({}) Map<String, dynamic> metadata,
    @Default([]) List<OllamaMessage> conversation,
  }) = _OllamaAgent;

  factory OllamaAgent.fromJson(Map<String, dynamic> json) =>
      _$OllamaAgentFromJson(json);
}

@freezed
class OllamaMessage with _$OllamaMessage {
  const factory OllamaMessage({
    required String role,
    required String content,
    @Default({}) Map<String, dynamic> metadata,
    DateTime? timestamp,
  }) = _OllamaMessage;

  factory OllamaMessage.fromJson(Map<String, dynamic> json) =>
      _$OllamaMessageFromJson(json);
}

@freezed
class OllamaFunction with _$OllamaFunction {
  const factory OllamaFunction({
    required String name,
    required String description,
    required Map<String, dynamic> parameters,
    @Default([]) List<String> required,
  }) = _OllamaFunction;

  factory OllamaFunction.fromJson(Map<String, dynamic> json) =>
      _$OllamaFunctionFromJson(json);
}

@freezed
class OllamaWorkflow with _$OllamaWorkflow {
  const factory OllamaWorkflow({
    required String name,
    required String description,
    required List<OllamaWorkflowStep> steps,
    @Default({}) Map<String, dynamic> metadata,
  }) = _OllamaWorkflow;

  factory OllamaWorkflow.fromJson(Map<String, dynamic> json) =>
      _$OllamaWorkflowFromJson(json);
}

@freezed
class OllamaWorkflowStep with _$OllamaWorkflowStep {
  const factory OllamaWorkflowStep({
    required String name,
    required String type,
    required Map<String, dynamic> parameters,
    @Default([]) List<String> dependencies,
    @Default({}) Map<String, dynamic> metadata,
  }) = _OllamaWorkflowStep;

  factory OllamaWorkflowStep.fromJson(Map<String, dynamic> json) =>
      _$OllamaWorkflowStepFromJson(json);
}

@freezed
class OllamaPromptTemplate with _$OllamaPromptTemplate {
  const factory OllamaPromptTemplate({
    required String name,
    required String template,
    required Map<String, String> variables,
    @Default({}) Map<String, dynamic> metadata,
  }) = _OllamaPromptTemplate;

  factory OllamaPromptTemplate.fromJson(Map<String, dynamic> json) =>
      _$OllamaPromptTemplateFromJson(json);
} 