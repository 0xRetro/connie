import 'package:freezed_annotation/freezed_annotation.dart';

part 'ui_settings.freezed.dart';
part 'ui_settings.g.dart';

@freezed
class UiSettings with _$UiSettings {
  const factory UiSettings({
    required int id,
    required String tableName,
    required String settings,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isDeleted,
  }) = _UiSettings;

  factory UiSettings.fromJson(Map<String, dynamic> json) => _$UiSettingsFromJson(json);
} 