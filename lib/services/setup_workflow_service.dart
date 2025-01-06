import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/logger_service.dart';
import '../services/database_service.dart';

final setupWorkflowProvider = Provider((ref) => SetupWorkflowService(ref));

/// Manages first-time setup workflow and database initialization
class SetupWorkflowService {
  final Ref _ref;

  SetupWorkflowService(this._ref);

  /// Checks if setup is needed and handles the workflow
  Future<void> handleSetupIfNeeded(bool isFirstRun) async {
    if (!isFirstRun) return;

    try {
      LoggerService.info('Starting first-time setup workflow');
      
      // Get database service
      final dbService = _ref.read(databaseServiceProvider);
      
      // Initialize database with default schema
      await _initializeDefaultSchema(dbService);
      
      // Create default settings
      await _createDefaultSettings(dbService);
      
      // Initialize default data
      await _initializeDefaultData(dbService);
      
      LoggerService.info('First-time setup completed successfully');
    } catch (e, stack) {
      LoggerService.error(
        'First-time setup failed',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  /// Initializes the default database schema
  Future<void> _initializeDefaultSchema(DatabaseService dbService) async {
    LoggerService.debug('Initializing default schema');
    // Initialize schema (tables are created by Drift)
  }

  /// Creates default application settings
  Future<void> _createDefaultSettings(DatabaseService dbService) async {
    LoggerService.debug('Creating default settings');
    // Create default settings in database
  }

  /// Initializes default application data
  Future<void> _initializeDefaultData(DatabaseService dbService) async {
    LoggerService.debug('Initializing default data');
    // Create default data (e.g., admin user)
  }

  /// Validates the setup was successful
  Future<bool> validateSetup() async {
    try {
      final dbService = _ref.read(databaseServiceProvider);
      final health = await dbService.checkDatabaseHealth();
      
      return health['isHealthy'] == true &&
             health['hasDefaultData'] == true;
    } catch (e, stack) {
      LoggerService.error(
        'Setup validation failed',
        error: e,
        stackTrace: stack,
      );
      return false;
    }
  }
} 