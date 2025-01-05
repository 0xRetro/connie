import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../config/environment.dart';
import '../services/logger_service.dart';
import 'tables/people_table.dart';
import 'tables/ui_settings_table.dart';
import 'tables/plugin_settings_table.dart';
import 'daos/app_dao.dart';
import 'daos/dynamic_table_dao.dart';

part 'database.g.dart';

/// Global provider for database access
@Riverpod(keepAlive: true)
AppDatabase database(ref) => AppDatabase();

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'connie.db'));
    LoggerService.debug('Opening database at ${file.path}');
    return NativeDatabase(
      file,
      logStatements: Environment.isDevelopment,
    );
  });
}

@DriftDatabase(
  tables: [
    PeopleTable,
    UiSettingsTable,
    PluginSettingsTable,
  ],
  daos: [
    AppDao,
    DynamicTableDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  // Thread-safe singleton
  static final AppDatabase _instance = AppDatabase._internal();
  static bool _initialized = false;
  
  factory AppDatabase() => _instance;
  
  // For testing purposes
  @visibleForTesting
  factory AppDatabase.forTesting(QueryExecutor e) => AppDatabase._(e);

  AppDatabase._internal() : super(_openConnection());
  AppDatabase._(QueryExecutor e) : super(e);

  /// Initializes the database with environment-specific settings
  Future<void> initialize() async {
    if (_initialized) return;
    
    LoggerService.debug('Initializing database');
    
    // Apply environment configuration
    final config = Environment.databaseConfig;
    await customStatement(
      'PRAGMA max_page_count = ${config['maxConnections']}',
    );
    await customStatement(
      'PRAGMA cache_size = ${config['enableCache'] ? -2000 : -1000}',
    );
    
    _initialized = true;
    LoggerService.info('Database initialized');
  }

  @override
  int get schemaVersion => 1;

  /// Handles database migrations with proper logging
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      LoggerService.info('Creating database schema');
      await m.createAll();
      
      // Initialize with default data
      await into(peopleTable).insert(
        PersonCompanion.insert(
          name: 'Admin',
          isSuperUser: const Value(true),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDeleted: const Value(false),
        ),
      );
    },
    onUpgrade: (m, from, to) async {
      LoggerService.info('Upgrading database from $from to $to');
      await m.createAll();
    },
    beforeOpen: (details) async {
      LoggerService.debug('Running pre-open database checks');
      await customStatement('PRAGMA foreign_keys = ON');
      if (details.wasCreated) {
        LoggerService.info('New database created');
      }
    },
  );

  /// Closes database connection
  @override
  Future<void> close() async {
    LoggerService.debug('Closing database connection');
    await super.close();
    _initialized = false;
  }

  /// Performs database health check with metrics
  Future<Map<String, dynamic>> getDatabaseMetrics() async {
    try {
      final size = await customSelect(
        'SELECT page_count * page_size as size FROM pragma_page_count, pragma_page_size'
      ).getSingle();
      
      final tableCount = allTables.length;
      
      // Check if default data exists
      final hasDefaultData = await (select(peopleTable)
        ..where((t) => t.isDeleted.equals(false)))
        .get()
        .then((rows) => rows.isNotEmpty);

      // Check if default settings exist
      final hasDefaultSettings = await (select(uiSettingsTable)
        ..where((t) => t.isDeleted.equals(false)))
        .get()
        .then((rows) => rows.isNotEmpty);
      
      // Check schema version
      final currentVersion = schemaVersion;
      final dbVersion = await customSelect(
        'PRAGMA user_version'
      ).getSingle().then((row) => row.data['user_version'] as int);
      
      final needsMigration = dbVersion < currentVersion;
      
      return {
        'size': size.data['size'],
        'version': currentVersion,
        'dbVersion': dbVersion,
        'tables': tableCount,
        'isHealthy': await verifyConnection(),
        'hasDefaultData': hasDefaultData,
        'hasDefaultSettings': hasDefaultSettings,
        'needsMigration': needsMigration,
      };
    } catch (e, stack) {
      LoggerService.error(
        'Failed to get database metrics',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  /// Creates a backup of the database
  Future<File> backup() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final backupPath = p.join(
      dbFolder.path,
      'backups',
      'connie_${DateTime.now().toIso8601String()}.db',
    );

    try {
      // Ensure backup directory exists
      final backupDir = Directory(p.dirname(backupPath));
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }

      // Create backup
      final backupFile = File(backupPath);
      await customStatement('VACUUM INTO ?', [backupPath]);
      
      LoggerService.info('Database backup created', data: {
        'path': backupPath,
        'size': await backupFile.length(),
      });
      
      return backupFile;
    } catch (e, stack) {
      LoggerService.error(
        'Failed to create database backup',
        error: e,
        stackTrace: stack,
        data: {'path': backupPath},
      );
      rethrow;
    }
  }

  /// Restores database from backup
  Future<void> restoreFromBackup(File backupFile) async {
    if (!await backupFile.exists()) {
      throw StateError('Backup file does not exist: ${backupFile.path}');
    }

    try {
      // Close current connection
      await close();
      
      // Get current database file
      final dbFolder = await getApplicationDocumentsDirectory();
      final dbFile = File(p.join(dbFolder.path, 'connie.db'));
      
      // Replace with backup
      await backupFile.copy(dbFile.path);
      
      // Reinitialize database
      _initialized = false;
      await initialize();
      
      LoggerService.info('Database restored from backup', data: {
        'backup': backupFile.path,
        'size': await dbFile.length(),
      });
    } catch (e, stack) {
      LoggerService.error(
        'Failed to restore database from backup',
        error: e,
        stackTrace: stack,
        data: {'backup': backupFile.path},
      );
      rethrow;
    }
  }

  /// Verifies database connection is healthy
  Future<bool> verifyConnection() async {
    try {
      await customSelect('SELECT 1').getSingle();
      return true;
    } catch (e, stack) {
      LoggerService.error(
        'Database health check failed',
        error: e,
        stackTrace: stack,
      );
      return false;
    }
  }

  /// Deletes all data from all tables
  Future<void> deleteAllData() async {
    await transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }
}
