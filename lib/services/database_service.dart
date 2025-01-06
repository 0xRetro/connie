import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../database/database.dart';
import 'logger_service.dart';
//import '../database/tables/plugin_settings_table.dart';
//import 'package:drift/drift.dart';

final appDatabaseProvider = Provider((ref) => AppDatabase());

final databaseServiceProvider = Provider((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DatabaseService(db);
});

/// Maximum number of retry attempts for database operations
const _maxRetries = 3;

/// Delay between retry attempts in milliseconds
const _retryDelay = 1000;

/// Manages database operations and provides error handling
class DatabaseService {
  final AppDatabase _db;

  DatabaseService(this._db);

  /// Executes a database operation with retry logic
  Future<T> _withRetry<T>(
    String operation,
    Future<T> Function() action,
  ) async {
    int attempts = 0;
    while (true) {
      try {
        attempts++;
        return await action();
      } catch (e, stack) {
        if (attempts >= _maxRetries) {
          LoggerService.error(
            'Database operation failed after $_maxRetries attempts',
            error: e,
            stackTrace: stack,
            data: {'operation': operation},
          );
          rethrow;
        }
        
        LoggerService.info(
          'Retrying database operation',
          data: {
            'operation': operation,
            'attempt': attempts,
            'maxRetries': _maxRetries,
          },
        );
        
        await Future.delayed(const Duration(milliseconds: _retryDelay));
      }
    }
  }

  /// Initializes the database service
  Future<void> initialize() async {
    await _withRetry('initialize', () async {
      await _db.initialize();
      LoggerService.info('Database service initialized');
    });
  }

  /// Disposes of the database service
  Future<void> dispose() async {
    await _withRetry('dispose', () async {
      await _db.close();
      LoggerService.info('Database service disposed');
    });
  }

  /// Performs database health check with metrics
  Future<Map<String, dynamic>> checkDatabaseHealth() async {
    return _withRetry('health_check', () async {
      final metrics = await _db.getDatabaseMetrics();
      LoggerService.info('Database health check', data: metrics);
      return metrics;
    });
  }

  /// Creates a database backup
  Future<void> createBackup() async {
    await _withRetry('create_backup', () async {
      await _db.backup();
      LoggerService.info('Database backup completed');
    });
  }

  /// Restores database from backup
  Future<void> restoreFromBackup(String backupPath) async {
    await _withRetry('restore_backup', () async {
      final backupFile = File(backupPath);
      await _db.restoreFromBackup(backupFile);
      LoggerService.info('Database restored from backup');
    });
  }

  /// Gets the database instance
  AppDatabase get database => _db;

  /// TODO: Updates a setting in the database

} 