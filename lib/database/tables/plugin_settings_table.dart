// ignore_for_file: invalid_annotation_target
library connie.database.tables.plugin_settings_table;

import 'package:drift/drift.dart';

/// Plugin settings table definition
class PluginSettingsTable extends Table {
  @override
  String get tableName => 'plugin_settings';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get pluginName => text().withLength(min: 1)();
  TextColumn get settingsKey => text().withLength(min: 1)();
  TextColumn get settingsValue => text()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  List<String> get customConstraints => [
        'CONSTRAINT valid_plugin_name CHECK (length(plugin_name) > 0)',
        'CONSTRAINT valid_settings_key CHECK (length(settings_key) > 0)',
      ];
} 