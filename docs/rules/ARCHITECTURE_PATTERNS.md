# Architecture Patterns

## Layer Separation

### 1. Project Structure
```
lib/
├── app/                    # App initialization and configuration
├── config/                 # Environment and app-wide configuration
│   ├── environment.dart    # Environment configuration
│   ├── theme.dart         # App theming
│   └── provider_config.dart # Provider configuration
├── database/              # Database implementation
│   ├── daos/             # Data Access Objects
│   ├── tables/           # Table definitions
│   └── database.dart     # Database configuration
├── services/             # Core services layer
│   ├── initialization/   # Initialization services
│   ├── logger_service.dart
│   └── database_service.dart
├── providers/           # State management
│   ├── core/           # App-wide providers
│   └── features/       # Feature-specific providers
├── ui/                 # Presentation layer
│   ├── screens/       # Full page screens
│   ├── widgets/       # Reusable widgets
│   └── layout/        # Layout components
└── utils/             # Utilities and helpers
    ├── lifecycle_observer.dart
    └── initialization_progress.dart
```

### 2. Layer Responsibilities

#### Configuration Layer
```dart
// Environment configuration
class Environment {
  static String get name => _config.environment;
  static bool get isDevelopment => name == 'development';
  
  static void validateEnvironment() {
    // Validate environment configuration
  }
}

// Provider configuration
class ProviderConfig {
  static List<Override> getRootOverrides({
    required bool isFirstRun,
  }) {
    return [
      // Provider overrides
    ];
  }
}
```

#### Service Layer
```dart
// Core service with initialization
class LoggerService {
  static Logger? _logger;
  
  static Future<void> initialize() async {
    _logger = await LoggerConfig.createLogger();
  }
  
  static void info(String message, {Map<String, dynamic>? data}) {
    _ensureInitialized();
    _logger!.i(_formatMessage(message, data));
  }
}

// Service coordination
class InitializationService {
  static Future<bool> initialize() async {
    await LoggerService.initialize();
    await DatabaseService.initialize();
    return _checkFirstTimeSetup();
  }
  
  static Future<bool> verifyServices() async {
    // Verify all services are healthy
  }
}
```

#### Presentation Layer
```dart
// Responsive layout handling
class ResponsiveLayout extends StatelessWidget {
  final Widget child;

  const ResponsiveLayout({required this.child});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper.builder(
      child,
      defaultScale: true,
      breakpoints: [
        // Breakpoint definitions
      ],
    );
  }
}
```

## Core Patterns

### 1. Initialization Pattern
```dart
// Structured initialization sequence
void main() async {
  try {
    // 1. Flutter bindings
    WidgetsFlutterBinding.ensureInitialized();
    
    // 2. Environment validation
    Environment.validateEnvironment();
    
    // 3. Progress tracking
    final progress = InitializationProgress();
    
    // 4. Core services
    await InitializationService.initialize();
    
    // 5. Health verification
    if (!await InitializationService.verifyServices()) {
      throw StateError('Service health check failed');
    }
    
    // 6. Application launch
    runApp(/* ... */);
  } catch (e, stack) {
    // Error handling
  }
}
```

### 2. Progress Tracking Pattern
```dart
// Progress tracking implementation
class InitializationProgress {
  final _stageController = StreamController<Stage>();
  Stream<Stage> get currentStage => _stageController.stream;
  
  void updateStage(String name) {
    _stageController.add(Stage(
      name: name,
      timestamp: DateTime.now(),
    ));
  }
  
  void dispose() {
    _stageController.close();
  }
}

class Stage {
  final String name;
  final String? description;
  final DateTime timestamp;
  final bool isCompleted;
  
  Stage(this.name, {
    this.description,
    required this.timestamp,
    this.isCompleted = false,
  });
}
```

### 3. Service Patterns

#### Singleton Services
```dart
// Logger service singleton
class LoggerService {
  static Logger? _logger;
  
  // Private constructor
  LoggerService._();
  
  static Future<void> initialize() async {
    if (_logger != null) return;
    _logger = await LoggerConfig.createLogger();
  }
}
```

#### Lifecycle Management
```dart
// Lifecycle observer pattern
class LifecycleObserver extends WidgetsBindingObserver {
  final VoidCallback? onPause;
  final VoidCallback? onResume;
  final Future<void> Function()? onDetach;
  
  LifecycleObserver({
    this.onPause,
    this.onResume,
    this.onDetach,
  });
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        onPause?.call();
        break;
      case AppLifecycleState.resumed:
        onResume?.call();
        break;
      case AppLifecycleState.detached:
        onDetach?.call();
        break;
      default:
        break;
    }
  }
}
```

### 4. Error Handling Pattern
```dart
// Global error handling
void configureErrorHandling() {
  FlutterError.onError = (details) {
    LoggerService.error(
      'Flutter error',
      error: details.exception,
      stackTrace: details.stack,
    );
  };
}

// Service error handling
class ServiceError implements Exception {
  final String message;
  final String service;
  final dynamic originalError;
  
  ServiceError(this.message, {
    required this.service,
    this.originalError,
  });
  
  @override
  String toString() => '$service error: $message';
}
```

## State Management

### 1. Provider Organization
```dart
// Core providers
final loggerProvider = Provider((ref) => LoggerService());

// Feature providers
final initializationProvider = FutureProvider.autoDispose((ref) async {
  await InitializationService.initialize();
  return true;
});

// Provider configuration
final providerConfig = Provider((ref) => ProviderConfig());
```

### 2. State Updates
```dart
// Progress state updates
class InitializationNotifier extends StateNotifier<InitializationState> {
  InitializationNotifier() : super(const InitializationState.initial());
  
  Future<void> initialize() async {
    state = const InitializationState.loading();
    try {
      await InitializationService.initialize();
      state = const InitializationState.complete();
    } catch (e) {
      state = InitializationState.error(e.toString());
    }
  }
}
```

## Best Practices

### 1. Service Organization
- Initialize services in correct order
- Validate service health
- Proper error handling
- Clean resource disposal
- Progress tracking

### 2. Error Management
- Global error handlers
- Service-specific errors
- Proper error logging
- Error recovery strategies

### 3. State Handling
- Provider-based state
- Proper state initialization
- Clean state disposal
- State validation

### 4. Resource Management
- Proper initialization
- Resource cleanup
- Memory management
- Service disposal

## Review Checklist

Before implementing features:
- [ ] Follows initialization pattern
- [ ] Implements proper error handling
- [ ] Uses appropriate service patterns
- [ ] Tracks progress appropriately
- [ ] Manages resources correctly
- [ ] Handles lifecycle events
- [ ] Follows state management patterns
``` 