import 'package:freezed_annotation/freezed_annotation.dart';
import 'constraint_definition.dart';

part 'column_definition.freezed.dart';
part 'column_definition.g.dart';

/// Regular expression for valid column names
/// Allows only lowercase letters, numbers, and underscores
/// Must start with a letter
final _columnNameRegex = RegExp(r'^[a-z][a-z0-9_]*$');

/// Regular expression for YYYY-MM-DD date format
final _dateFormatRegex = RegExp(r'^\d{4}-(?:0[1-9]|1[0-2])-(?:0[1-9]|[12]\d|3[01])$');

/// Represents the type of a database column
enum ColumnType {
  @JsonValue('INTEGER')
  integer,
  @JsonValue('TEXT')
  text,
  @JsonValue('BOOLEAN')
  boolean,
  @JsonValue('DATE')
  date,
  @JsonValue('DATETIME')
  datetime,
  @JsonValue('REAL')
  real,
  @JsonValue('BLOB')
  blob,
}

/// Represents a database column definition
@freezed
class ColumnDefinition with _$ColumnDefinition {
  @internal
  const factory ColumnDefinition({
    required String name,
    required ColumnType type,
    @Default(false) bool isNullable,
    @Default(false) bool isAutoIncrement,
    @Default(false) bool isPrimaryKey,
    @Default(false) bool isUnique,
    int? maxLength,
    String? pattern,
    int? precision,
    int? scale,
    String? defaultValue,
    @Default(false) bool defaultToCurrentTime,
    String? referencedTable,
    @Default([]) List<ConstraintDefinition> constraints,
    String? description,
  }) = _ColumnDefinition;

  static bool validateColumnName(String name) => _columnNameRegex.hasMatch(name);
  
  static bool validateTypeConstraints(ColumnType type, int? precision, int? scale) =>
    (type == ColumnType.real && precision != null && scale != null) || 
    (type != ColumnType.real && precision == null && scale == null);

  static bool validateDefaultValue(ColumnType type, String? value) {
    if (value == null) return true;
    
    switch (type) {
      case ColumnType.date:
        return _dateFormatRegex.hasMatch(value);
      case ColumnType.integer:
        return int.tryParse(value) != null;
      case ColumnType.real:
        return double.tryParse(value) != null;
      case ColumnType.boolean:
        return value.toLowerCase() == 'true' || value.toLowerCase() == 'false';
      case ColumnType.text:
      case ColumnType.blob:
        return true;
      case ColumnType.datetime:
        try {
          DateTime.parse(value);
          return true;
        } catch (_) {
          return false;
        }
    }
  }

  factory ColumnDefinition.create({
    required String name,
    required ColumnType type,
    bool isNullable = false,
    bool isAutoIncrement = false,
    bool isPrimaryKey = false,
    bool isUnique = false,
    int? maxLength,
    String? pattern,
    int? precision,
    int? scale,
    String? defaultValue,
    bool defaultToCurrentTime = false,
    String? referencedTable,
    List<ConstraintDefinition> constraints = const [],
    String? description,
  }) {
    if (!validateColumnName(name)) {
      throw ArgumentError('Column name must be lowercase, start with a letter, and contain only letters, numbers, and underscores');
    }
    if (!validateTypeConstraints(type, precision, scale)) {
      throw ArgumentError('Precision and scale are only valid for REAL columns');
    }
    if (isAutoIncrement && type != ColumnType.integer) {
      throw ArgumentError('Auto-increment is only valid for INTEGER columns');
    }
    if (defaultToCurrentTime && type != ColumnType.datetime && type != ColumnType.date) {
      throw ArgumentError('Default to current time is only valid for DATE/DATETIME columns');
    }
    if (maxLength != null && type != ColumnType.text) {
      throw ArgumentError('Max length is only valid for TEXT columns');
    }
    if (!validateDefaultValue(type, defaultValue)) {
      throw ArgumentError('Invalid default value format for column type');
    }

    return ColumnDefinition(
      name: name,
      type: type,
      isNullable: isNullable,
      isAutoIncrement: isAutoIncrement,
      isPrimaryKey: isPrimaryKey,
      isUnique: isUnique,
      maxLength: maxLength,
      pattern: pattern,
      precision: precision,
      scale: scale,
      defaultValue: defaultValue,
      defaultToCurrentTime: defaultToCurrentTime,
      referencedTable: referencedTable,
      constraints: constraints,
      description: description,
    );
  }

  factory ColumnDefinition.fromJson(Map<String, dynamic> json) =>
      _$ColumnDefinitionFromJson(json);
} 