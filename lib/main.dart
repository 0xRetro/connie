import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'navigation/app_router.dart';
import 'ui/layout/responsive_layout.dart';
import 'config/theme.dart';
import 'config/environment.dart';
import 'services/initialization_service.dart';
import 'services/logger_service.dart';
import 'config/provider_config.dart';
import 'utils/lifecycle_observer.dart';
import 'utils/initialization_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize SharedPreferences with error handling
  final prefs = await SharedPreferences.getInstance().catchError((error, stack) {
    LoggerService.error('Failed to initialize SharedPreferences', error: error, stackTrace: stack);
    return SharedPreferences.getInstance(); // Fallback or handle accordingly
  });
  
  try {
    // Validate environment and configurations
    try {
      Environment.validateEnvironment();
      Environment.validateDatabaseConfig();
      Environment.validateOllamaConfig();
    } catch (e, stack) {
      LoggerService.error('Environment validation failed', error: e, stackTrace: stack);
      rethrow; // Or handle gracefully
    }

    final progress = InitializationProgress();
    
    // Initialize logger for debugging
    await LoggerService.initialize();
    progress.updateStage('logger');
    LoggerService.info('Starting app bootstrap', data: {
      'environment': Environment.name,
      'ollamaConfig': Environment.ollamaConfig,
    });

    // Track initialization progress
    progress.currentStage.listen((stage) {
      LoggerService.info(
        'Initialization stage update',
        data: {
          'stage': stage.name,
          'description': stage.description,
          'completed': stage.isCompleted,
        },
      );
    });

    // Create ProviderContainer with overrides
    final container = ProviderContainer(
      overrides: [
        // Override SharedPreferences provider with the initialized instance
        sharedPreferencesProvider.overrideWithValue(prefs),
        // Add other root overrides (e.g., for first-run logic)
        ...ProviderConfig.getRootOverrides(isFirstRun: false),
      ],
    );

    // Initialize core services
    final isFirstRun = await InitializationService.initialize(container);
    
    // Register app lifecycle hooks
    final lifecycleObserver = LifecycleObserver(
      onDetach: () async {
        try {
          LoggerService.info('App detaching, cleaning up resources');
          await InitializationService.cleanup(container);
          progress.dispose();
          container.dispose();
        } catch (e, stack) {
          LoggerService.error('Error during app detach', error: e, stackTrace: stack);
        }
      },
      onPause: () {
        LoggerService.info('App paused');
      },
      onResume: () async {
        try {
          LoggerService.info('App resumed');
          await InitializationService.verifyServices(container);
        } catch (e, stack) {
          LoggerService.error('Error during app resume', error: e, stackTrace: stack);
        }
      },
    );
    
    // Verify services are healthy before continuing
    if (!await InitializationService.verifyServices(container)) {
      throw StateError('Service health check failed');
    }

    LoggerService.info('App bootstrap completed', data: {
      'isFirstRun': isFirstRun,
      'environment': Environment.name,
      'ollamaConfig': Environment.ollamaConfig,
    });
    
    // Run the app with proper provider configuration
    runApp(
      ProviderScope(
        parent: container,
        overrides: [
          ...ProviderConfig.getRootOverrides(isFirstRun: isFirstRun),
        ],
        child: MaterialApp.router(
          builder: (context, child) => ResponsiveLayout(child: child!),
          routerConfig: appRouter,
          theme: AppTheme.light,
          debugShowCheckedModeBanner: Environment.isDevelopment,
          title: 'Connie',
        ),
      ),
    );

    // Setup app lifecycle observer
    WidgetsFlutterBinding.ensureInitialized().addObserver(lifecycleObserver);
    
    // Register global error handler
    FlutterError.onError = (details) {
      LoggerService.error(
        'Flutter error',
        error: details.exception,
        stackTrace: details.stack,
      );
    };
  } catch (e, stack) {
    // Log error and rethrow for platform error handling
    LoggerService.error(
      'Fatal error during initialization',
      error: e,
      stackTrace: stack,
      data: {
        'environment': Environment.name,
        'ollamaConfig': Environment.ollamaConfig,
      },
    );
    rethrow;
  }
}