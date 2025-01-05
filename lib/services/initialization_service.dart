import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/environment.dart';
import '../services/logger_service.dart';
import '../services/database_service.dart';
import '../utils/initialization_progress.dart';

/// Service responsible for coordinating application initialization
class InitializationService {
  static bool _initialized = false;
  static final _progress = InitializationProgress();
  
  /// Initializes all required services in the correct order
  static Future<bool> initialize() async {
    if (_initialized) return false;
    
    try {
      // Platform services initialization
      _progress.updateStage('platform');
      await _initializePlatformServices();
      
      // Database initialization and health check
      _progress.updateStage('database');
      final dbService = ProviderContainer().read(databaseServiceProvider);
      await dbService.initialize();
      
      // Check and run migrations if needed
      _progress.updateStage('migration');
      final needsMigration = await _checkMigrations();
      if (needsMigration) {
        await _runMigrations();
      }
      
      // Check if first-time setup is needed
      _progress.updateStage('setup');
      final isFirstRun = await _checkFirstTimeSetup();
      
      // Non-blocking initializations
      _initializePreferences();
      _initializeAnalytics();
      
      _initialized = true;
      return isFirstRun;
    } catch (e, stack) {
      LoggerService.error(
        'Initialization failed',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  /// Initializes platform-specific services
  static Future<void> _initializePlatformServices() async {
    try {
      LoggerService.info('Initializing platform services', data: {
        'platform': Environment.isAndroid ? 'android' : 
                    Environment.isIOS ? 'ios' :
                    Environment.isWeb ? 'web' : 'desktop',
      });

      if (Environment.isAndroid) {
        // Android-specific initialization
        // Example: Initialize Android-specific plugins
      } else if (Environment.isIOS) {
        // iOS-specific initialization
        // Example: Initialize iOS-specific plugins
      } else if (Environment.isDesktop) {
        // Desktop-specific initialization
        // Example: Initialize desktop-specific features
      }
    } catch (e, stack) {
      LoggerService.error(
        'Platform services initialization failed',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  /// Checks if database migrations are needed
  static Future<bool> _checkMigrations() async {
    try {
      final dbService = ProviderContainer().read(databaseServiceProvider);
      final metrics = await dbService.checkDatabaseHealth();
      return metrics['needsMigration'] ?? false;
    } catch (e, stack) {
      LoggerService.error(
        'Migration check failed',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  /// Runs necessary database migrations
  static Future<void> _runMigrations() async {
    try {
      // Run migrations
      LoggerService.info('Running database migrations');
    } catch (e, stack) {
      LoggerService.error(
        'Migration failed',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  /// Checks if this is the first time the app is run
  static Future<bool> _checkFirstTimeSetup() async {
    try {
      final dbService = ProviderContainer().read(databaseServiceProvider);
      final metrics = await dbService.checkDatabaseHealth();
      return metrics['isFirstRun'] ?? true;
    } catch (e, stack) {
      LoggerService.error(
        'First-time setup check failed',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  /// Initializes user preferences (non-blocking)
  static Future<void> _initializePreferences() async {
    _progress.updateStage('preferences');
    // Initialize preferences
  }

  /// Initializes analytics (non-blocking)
  static Future<void> _initializeAnalytics() async {
    _progress.updateStage('analytics');
    // Initialize analytics if enabled
    if (Environment.enableAnalytics) {
      // Setup analytics
    }
  }

  /// Verifies all services are healthy
  static Future<bool> verifyServices() async {
    try {
      final dbService = ProviderContainer().read(databaseServiceProvider);
      final isHealthy = await dbService.checkDatabaseHealth();
      return isHealthy['isHealthy'] ?? false;
    } catch (e, stack) {
      LoggerService.error(
        'Service verification failed',
        error: e,
        stackTrace: stack,
      );
      return false;
    }
  }

  /// Cleans up resources during app termination
  static Future<void> cleanup() async {
    try {
      final dbService = ProviderContainer().read(databaseServiceProvider);
      await dbService.dispose();
      _initialized = false;
    } catch (e, stack) {
      LoggerService.error(
        'Cleanup failed',
        error: e,
        stackTrace: stack,
      );
    }
  }
} 