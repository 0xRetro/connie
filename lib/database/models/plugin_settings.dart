import 'package:freezed_annotation/freezed_annotation.dart';

part 'plugin_settings.freezed.dart';
part 'plugin_settings.g.dart';

@freezed
class PluginSettings with _$PluginSettings {
  const factory PluginSettings({
    required int id,
    required String pluginName,
    required String settingsKey,
    required String settingsValue,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isDeleted,
  }) = _PluginSettings;

  factory PluginSettings.fromJson(Map<String, dynamic> json) => _$PluginSettingsFromJson(json);
} 