import 'package:freezed_annotation/freezed_annotation.dart';
import 'table_definition.dart';

part 'schema_definition.freezed.dart';
part 'schema_definition.g.dart';

/// Represents the complete database schema
@freezed
class SchemaDefinition with _$SchemaDefinition {
  const factory SchemaDefinition({
    required int version,
    required List<TableDefinition> tables,
    required DateTime lastModified,
    String? description,
  }) = _SchemaDefinition;

  factory SchemaDefinition.create({
    required int version,
    required List<TableDefinition> tables,
    String? description,
  }) {
    if (version <= 0) {
      throw ArgumentError('Schema version must be positive');
    }
    final names = tables.map((t) => t.name).toSet();
    if (names.length != tables.length) {
      throw ArgumentError('Table names must be unique within the schema');
    }
    return SchemaDefinition(
      version: version,
      tables: tables,
      lastModified: DateTime.now(),
      description: description,
    );
  }

  factory SchemaDefinition.fromJson(Map<String, dynamic> json) =>
      _$SchemaDefinitionFromJson(json);
} 