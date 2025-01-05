import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:connie/services/logger_service.dart';

/// Handles database initialization, validation, and setup
class DatabaseInitializer {
  static const _dbFileName = 'connie.db';
  
  /// The name of the database file
  static String get databaseName => _dbFileName;

  /// Initializes the database system
  /// Returns true if successful, false if there was an error
  static Future<bool> initialize() async {
    try {
      // Step 1: Initialize SQLite for the current platform
      await _initializeSQLite();

      // Step 2: Get database path and ensure directory exists
      final dbPath = await _getDatabasePath();
      final directory = Directory(p.dirname(dbPath));
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      // Step 3: Check if database exists
      final dbFile = File(dbPath);
      final isFirstRun = !dbFile.existsSync();

      if (isFirstRun) {
        LoggerService.info('First run detected, creating new database');
        return await _createNewDatabase(dbPath);
      }

      // Step 4: Validate existing database
      return await _validateDatabase(dbPath);
    } catch (e, stack) {
      LoggerService.error('Database initialization failed', error: e, stackTrace: stack);
      return false;
    }
  }

  /// Initialize SQLite for the current platform
  static Future<void> _initializeSQLite() async {
    try {
      // Test SQLite functionality using in-memory database
      final db = NativeDatabase.memory();
      await db.ensureOpen(_DatabaseInitializerExecutorUser());
      await db.close();
    } catch (e, stack) {
      LoggerService.error('SQLite initialization failed', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Gets the platform-specific database path
  static Future<String> _getDatabasePath() async {
    final appDir = await getApplicationDocumentsDirectory();
    return p.join(appDir.path, 'connie', _dbFileName);
  }

  /// Creates a new database with initial schema
  static Future<bool> _createNewDatabase(String path) async {
    late final QueryExecutor db;
    try {
      // Create database directory if it doesn't exist
      final dbDir = Directory(p.dirname(path));
      if (!dbDir.existsSync()) {
        dbDir.createSync(recursive: true);
      }

      // Open database with Drift
      db = NativeDatabase(File(path));
      await db.ensureOpen(_DatabaseInitializerExecutorUser());

      // Enable foreign keys and WAL mode
      await db.runCustom('PRAGMA foreign_keys = ON');
      await db.runCustom('PRAGMA journal_mode = WAL');
      await db.runCustom('PRAGMA synchronous = NORMAL');

      // Initialize schema and create default data
      await _initializeSchema(db);
      await _createDefaultData(db);
      
      await db.close();
      return true;
    } catch (e, stack) {
      LoggerService.error('Failed to create new database', error: e, stackTrace: stack);
      await db.close();
      return false;
    }
  }

  /// Validates an existing database
  static Future<bool> _validateDatabase(String path) async {
    late final QueryExecutor db;
    try {
      db = NativeDatabase(File(path));
      await db.ensureOpen(_DatabaseInitializerExecutorUser());

      // Run integrity checks
      final integrityResult = await db.runSelect('PRAGMA integrity_check', []);
      if (integrityResult.first.values.first != 'ok') {
        LoggerService.error('Database integrity check failed');
        return false;
      }

      // Check foreign key constraints
      final fkResult = await db.runSelect('PRAGMA foreign_key_check', []);
      if (fkResult.isNotEmpty) {
        LoggerService.error('Foreign key constraints violated');
        return false;
      }

      // Verify schema version
      final versionResult = await db.runSelect('PRAGMA user_version', []);
      final version = versionResult.first.values.first as int;
      
      // TODO: Add version compatibility check
      LoggerService.info('Database version: $version');

      await db.close();
      return true;
    } catch (e, stack) {
      LoggerService.error('Database validation failed', error: e, stackTrace: stack);
      await db.close();
      return false;
    }
  }

  /// Initializes the database schema
  static Future<void> _initializeSchema(QueryExecutor db) async {
    // Create tables
    await db.runCustom('''
      CREATE TABLE IF NOT EXISTS people (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL CHECK (length(name) > 0),
        is_super_user BOOLEAN NOT NULL DEFAULT 0,
        created_at DATETIME NOT NULL,
        updated_at DATETIME NOT NULL,
        is_deleted BOOLEAN NOT NULL DEFAULT 0,
        CONSTRAINT valid_name CHECK (length(name) > 0)
      )
    ''');

    await db.runCustom('''
      CREATE TABLE IF NOT EXISTS ui_settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        table_name TEXT NOT NULL,
        settings TEXT NOT NULL,
        created_at DATETIME NOT NULL,
        updated_at DATETIME NOT NULL,
        is_deleted BOOLEAN NOT NULL DEFAULT 0,
        CONSTRAINT valid_table_name CHECK (length(table_name) > 0),
        CONSTRAINT valid_settings CHECK (length(settings) > 0)
      )
    ''');

    await db.runCustom('''
      CREATE TABLE IF NOT EXISTS plugin_settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        plugin_name TEXT NOT NULL,
        settings_key TEXT NOT NULL,
        settings_value TEXT NOT NULL,
        created_at DATETIME NOT NULL,
        updated_at DATETIME NOT NULL,
        is_deleted BOOLEAN NOT NULL DEFAULT 0,
        CONSTRAINT valid_plugin_name CHECK (length(plugin_name) > 0),
        CONSTRAINT valid_settings_key CHECK (length(settings_key) > 0)
      )
    ''');
  }

  /// Creates default data for a new database
  static Future<void> _createDefaultData(QueryExecutor db) async {
    final now = DateTime.now().toIso8601String();
    
    // Create default admin user
    await db.runCustom(
      'INSERT INTO people (name, is_super_user, created_at, updated_at, is_deleted) VALUES (?, 1, ?, ?, 0)',
      ['Admin', now, now],
    );

    // Create default UI settings
    await db.runCustom(
      'INSERT INTO ui_settings (table_name, settings, created_at, updated_at, is_deleted) VALUES (?, ?, ?, ?, 0)',
      ['global', '{"theme":"light","fontSize":14}', now, now],
    );
  }
}

/// A simple executor user for database initialization
class _DatabaseInitializerExecutorUser extends QueryExecutorUser {
  @override
  Future<void> beforeOpen(QueryExecutor executor, OpeningDetails details) async {
    // No special setup needed
  }

  @override
  int get schemaVersion => 1;
} 