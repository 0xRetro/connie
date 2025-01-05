// ignore_for_file: invalid_annotation_target
library connie.database.tables.people_table;

import 'package:drift/drift.dart';

@DataClassName('Person')
class PeopleTable extends Table {
  @override
  String get tableName => 'people';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get isSuperUser => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  List<String> get customConstraints => [
        'CONSTRAINT valid_name CHECK (length(name) > 0)',
      ];
} 