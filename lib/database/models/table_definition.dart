import 'package:freezed_annotation/freezed_annotation.dart';
import 'column_definition.dart';
import 'constraint_definition.dart';

part 'table_definition.freezed.dart';
part 'table_definition.g.dart';

/// Regular expression for valid table names
/// Allows only lowercase letters, numbers, and underscores
/// Must start with a letter
final _tableNameRegex = RegExp(r'^[a-z][a-z0-9_]*$');

/// Represents a database table definition
@freezed
class TableDefinition with _$TableDefinition {
  const factory TableDefinition({
    required String name,
    required List<ColumnDefinition> columns,
    @Default([]) List<ConstraintDefinition> constraints,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? description,
  }) = _TableDefinition;

  static bool validateTableName(String name) => _tableNameRegex.hasMatch(name);

  factory TableDefinition.fromJson(Map<String, dynamic> json) =>
      _$TableDefinitionFromJson(json);
      
  /// Creates a new table definition with default ID column
  factory TableDefinition.create({
    required String name,
    required List<ColumnDefinition> columns,
    List<ConstraintDefinition> constraints = const [],
    String? description,
  }) {
    if (!validateTableName(name)) {
      throw ArgumentError('Table name must be lowercase, start with a letter, and contain only letters, numbers, and underscores');
    }
    
    // Create ID column
    final idColumn = ColumnDefinition(
      name: 'id',
      type: ColumnType.integer,
      isPrimaryKey: true,
      isAutoIncrement: true,
    );
    
    // Ensure ID is the first column
    final allColumns = [idColumn, ...columns];
    
    return TableDefinition(
      name: name,
      columns: allColumns,
      constraints: constraints,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      description: description,
    );
  }
}