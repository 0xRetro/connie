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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Validate environment first
    Environment.validateEnvironment();
    Environment.validateDatabaseConfig();
    Environment.validateOllamaConfig();
    
    final progress = InitializationProgress();
    
    // Initialize logger first for proper debugging
    await LoggerService.initialize();
    progress.updateStage('logger');
    LoggerService.info('Starting app bootstrap', data: {
      'environment': Environment.name,
      'ollamaConfig': Environment.ollamaConfig,
    });

    // Setup progress tracking
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
    
    // Initialize core services
    final isFirstRun = await InitializationService.initialize();
    
    // Register app lifecycle hooks
    final lifecycleObserver = LifecycleObserver(
      onDetach: () async {
        LoggerService.info('App detaching, cleaning up resources');
        await InitializationService.cleanup();
        progress.dispose();
      },
      onPause: () {
        LoggerService.info('App paused');
      },
      onResume: () async {
        LoggerService.info('App resumed');
        await InitializationService.verifyServices();
      },
    );
    
    // Verify services are healthy before continuing
    if (!await InitializationService.verifyServices()) {
      throw StateError('Service health check failed');
    }

    // Configure global error handling
    FlutterError.onError = (details) {
      LoggerService.error(
        'Flutter error',
        error: details.exception,
        stackTrace: details.stack,
      );
    };

    LoggerService.info('App bootstrap completed', data: {
      'isFirstRun': isFirstRun,
      'environment': Environment.name,
      'ollamaConfig': Environment.ollamaConfig,
    });
    
    // Run the app with proper provider configuration
    runApp(
      ProviderScope(
        overrides: ProviderConfig.getRootOverrides(
          isFirstRun: isFirstRun,
        ),
        child: MaterialApp.router(
          builder: (context, child) => ResponsiveLayout(child: child!),
          routerConfig: appRouter,
          theme: AppTheme.light,
          debugShowCheckedModeBanner: Environment.isDevelopment,
          title: 'Connie',
        ),
      ),
    );

    // Setup app termination cleanup
    final binding = WidgetsFlutterBinding.ensureInitialized();
    binding.addObserver(lifecycleObserver);
    
    // Register error handlers after app is running
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
