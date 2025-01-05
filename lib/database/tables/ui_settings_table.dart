// ignore_for_file: invalid_annotation_target
library connie.database.tables.ui_settings_table;

import 'package:drift/drift.dart';

@DataClassName('UiSetting')
class UiSettingsTable extends Table {
  @override
  String get tableName => 'ui_settings';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get targetTableName => text().named('table_name')();
  TextColumn get settings => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  List<String> get customConstraints => [
        'CONSTRAINT valid_table_name CHECK (length(table_name) > 0)',
        'CONSTRAINT valid_settings CHECK (length(settings) > 0)',
      ];
} 