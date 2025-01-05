import 'package:drift/drift.dart';
import '../database.dart';

part 'dynamic_table_dao.g.dart';

@DriftAccessor(tables: [])
class DynamicTableDao extends DatabaseAccessor<AppDatabase> with _$DynamicTableDaoMixin {
  DynamicTableDao(super.db);

  Future<void> createTable(String tableName, List<GeneratedColumn> columns) async {
    await customStatement(
      'CREATE TABLE IF NOT EXISTS $tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, ${columns.map((c) => '${c.name} ${c.type.sqlTypeName}').join(', ')})',
    );
  }

  Future<void> addColumn(String tableName, GeneratedColumn column) async {
    await customStatement(
      'ALTER TABLE $tableName ADD COLUMN ${column.name} ${column.type.sqlTypeName}',
    );
  }

  Future<void> editColumn(String tableName, String oldColumnName, GeneratedColumn newColumn) async {
    await customStatement(
      'ALTER TABLE $tableName ALTER COLUMN $oldColumnName TYPE ${newColumn.type.sqlTypeName}',
    );
  }

  Future<void> deleteColumn(String tableName, String columnName) async {
    await customStatement(
      'ALTER TABLE $tableName DROP COLUMN $columnName',
    );
  }

  Future<void> deleteTable(String tableName) async {
    await customStatement(
      'DROP TABLE IF EXISTS $tableName',
    );
  }

  Future<List<Map<String, Object?>>> queryTable(
    String tableName, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    var query = 'SELECT * FROM $tableName';
    if (where != null) {
      query += ' WHERE $where';
    }
    if (orderBy != null) {
      query += ' ORDER BY $orderBy';
    }
    if (limit != null) {
      query += ' LIMIT $limit';
    }
    if (offset != null) {
      query += ' OFFSET $offset';
    }
    
    final result = await customSelect(
      query,
      variables: whereArgs?.map((arg) => Variable<Object>(arg)).toList() ?? [],
    ).get();
    
    return result.map((row) => row.data).toList();
  }
} 