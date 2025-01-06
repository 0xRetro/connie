import 'package:freezed_annotation/freezed_annotation.dart';

part 'constraint_definition.freezed.dart';
part 'constraint_definition.g.dart';

/// Represents the type of a database constraint
enum ConstraintType {
  @JsonValue('CHECK')
  check,
  @JsonValue('FOREIGN_KEY')
  foreignKey,
  @JsonValue('UNIQUE')
  unique,
  @JsonValue('PRIMARY_KEY')
  primaryKey,
  @JsonValue('NOT_NULL')
  notNull,
}

/// Represents a database constraint definition
@freezed
class ConstraintDefinition with _$ConstraintDefinition {
  const factory ConstraintDefinition({
    /// The name of the constraint
    required String name,
    
    /// The type of constraint
    required ConstraintType type,
    
    /// The SQL expression for CHECK constraints
    String? checkExpression,
    
    /// The referenced table for FOREIGN KEY constraints
    String? referencedTable,
    
    /// The referenced column for FOREIGN KEY constraints
    String? referencedColumn,
    
    /// ON DELETE action for FOREIGN KEY constraints
    String? onDelete,
    
    /// ON UPDATE action for FOREIGN KEY constraints
    String? onUpdate,
    
    /// Description of the constraint's purpose
    String? description,
  }) = _ConstraintDefinition;

  factory ConstraintDefinition.fromJson(Map<String, dynamic> json) =>
      _$ConstraintDefinitionFromJson(json);
} 