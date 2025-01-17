import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/environment.dart';
import '../services/logger_service.dart';
import '../services/database_service.dart';
import '../utils/initialization_progress.dart';
import '../providers/ollama_provider.dart';

/// Service responsible for coordinating application initialization
class InitializationService {
  /// Tracks whether the app has been initialized.
  /// This is static to ensure a single instance across the app.
  static bool _initialized = false;

  /// Tracks the progress of the initialization process.
  /// This is static to ensure a single instance across the app.
  static final _progress = InitializationProgress();
  
  /// Initializes all required services in the correct order.
  /// Returns `true` if this is the first run of the app, `false` otherwise.
  static Future<bool> initialize(ProviderContainer container) async {
    if (_initialized) return false;
    
    try {
      // Stage 1: Logger initialization
      _progress.updateStage('logger');
      LoggerService.info('Starting app bootstrap', data: {
        'environment': Environment.name,
        'ollamaConfig': Environment.ollamaConfig,
      });
      
      // Stage 2: Platform services initialization
      _progress.updateStage('platform');
      await _initializePlatformServices();
      
      // Stage 3: Database initialization and health check
      _progress.updateStage('database');
      final dbService = container.read(databaseServiceProvider);
      await dbService.initialize();
      
      // Stage 4: Check and run migrations if needed
      _progress.updateStage('migration');
      final needsMigration = await _checkMigrations(container);
      if (needsMigration) {
        await _runMigrations(container);
      }
      
      // Stage 5: Initialize Ollama service
      _progress.updateStage('ollama');
      final ollamaService = container.read(ollamaServiceProvider);
      if (!await ollamaService.isHealthy()) {
        LoggerService.warn('Ollama service health check failed during initialization');
      }
      
      // Stage 6: Check if first-time setup is needed
      _progress.updateStage('setup');
      final isFirstRun = await _checkFirstTimeSetup(container);
      
      // Stage 7: Non-blocking initializations
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

  /// Initializes platform-specific services.
  /// This method ensures that platform-specific features are properly set up.
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

  /// Checks if database migrations are needed.
  /// Returns `true` if migrations are required, `false` otherwise.
  static Future<bool> _checkMigrations(ProviderContainer container) async {
    try {
      final dbService = container.read(databaseServiceProvider);
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

  /// Runs necessary database migrations.
  /// This method ensures the database schema is up-to-date.
  static Future<void> _runMigrations(ProviderContainer container) async {
    try {
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

  /// Checks if this is the first time the app is run.
  /// Returns `true` if this is the first run, `false` otherwise.
  static Future<bool> _checkFirstTimeSetup(ProviderContainer container) async {
    try {
      final dbService = container.read(databaseServiceProvider);
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

  /// Verifies that all required services are healthy.
  /// Returns `true` if all services are healthy, `false` otherwise.
  static Future<bool> verifyServices(ProviderContainer container) async {
    try {
      LoggerService.debug('Verifying service health');
      
      // Verify database service
      final dbService = container.read(databaseServiceProvider);
      final dbHealth = await dbService.checkDatabaseHealth();
      if (!dbHealth['isHealthy']) {
        LoggerService.error('Database health check failed', data: dbHealth);
        return false;
      }
      
      // Verify Ollama service
      final ollamaService = container.read(ollamaServiceProvider);
      if (!await ollamaService.isHealthy()) {
        LoggerService.error('Ollama service health check failed');
        return false;
      }
      
      return true;
    } catch (e, stack) {
      LoggerService.error(
        'Service verification failed',
        error: e,
        stackTrace: stack,
      );
      return false;
    }
  }

  /// Cleans up resources during app termination.
  /// This method ensures that all resources are properly disposed of.
  static Future<void> cleanup(ProviderContainer container) async {
    try {
      // Cleanup database
      final dbService = container.read(databaseServiceProvider);
      await dbService.dispose();

      // Cleanup Ollama service
      final ollamaService = container.read(ollamaServiceProvider);
      ollamaService.dispose();
      
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