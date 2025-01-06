import 'package:flutter/foundation.dart';
import '../services/logger_service.dart';

/// Represents a stage in the initialization process
class InitializationStage {
  final String name;
  final String description;
  final bool isBlocking;
  final bool requiresUserInput;
  bool isCompleted;
  String? error;

  InitializationStage({
    required this.name,
    required this.description,
    this.isBlocking = true,
    this.requiresUserInput = false,
    this.isCompleted = false,
    this.error,
  });

  @override
  String toString() => '$name: ${isCompleted ? "completed" : "pending"}';
}

/// Manages the initialization progress of the application
class InitializationProgress extends ChangeNotifier {
  final _stages = <InitializationStage>[
    InitializationStage(
      name: 'platform',
      description: 'Initializing platform services',
      isBlocking: true,
    ),
    InitializationStage(
      name: 'logger',
      description: 'Setting up logging service',
      isBlocking: true,
    ),
    InitializationStage(
      name: 'database',
      description: 'Initializing database',
      isBlocking: true,
    ),
    InitializationStage(
      name: 'migration',
      description: 'Checking database migrations',
      isBlocking: true,
    ),
    InitializationStage(
      name: 'ollama',
      description: 'Initializing Ollama service',
      isBlocking: true,
    ),
    InitializationStage(
      name: 'setup',
      description: 'Checking first-time setup requirements',
      isBlocking: true,
      requiresUserInput: true,
    ),
    InitializationStage(
      name: 'preferences',
      description: 'Loading user preferences',
      isBlocking: false,
    ),
    InitializationStage(
      name: 'analytics',
      description: 'Initializing analytics',
      isBlocking: false,
    ),
  ];

  int _currentIndex = 0;
  bool _hasError = false;

  /// Stream of initialization stages for UI updates
  Stream<InitializationStage> get currentStage async* {
    for (final stage in _stages) {
      yield stage;
    }
  }

  /// Whether all blocking stages are completed
  bool get canProceed => _stages
    .where((stage) => stage.isBlocking)
    .every((stage) => stage.isCompleted);

  /// Whether any stage requires user input
  bool get requiresUserInput => _stages
    .any((stage) => stage.requiresUserInput && !stage.isCompleted);

  /// Whether there are any errors
  bool get hasError => _hasError;

  /// Updates the progress of a specific stage
  void updateStage(String stageName, {String? error}) {
    final stage = _stages.firstWhere(
      (s) => s.name == stageName,
      orElse: () => throw StateError('Invalid stage: $stageName'),
    );

    if (error != null) {
      stage.error = error;
      _hasError = true;
      LoggerService.error(
        'Initialization stage failed',
        error: error,
        data: {'stage': stageName},
      );
    } else {
      stage.isCompleted = true;
      _currentIndex = _stages.indexOf(stage) + 1;
      LoggerService.info(
        'Initialization stage completed',
        data: {
          'stage': stageName,
          'requiresUserInput': stage.requiresUserInput,
          'isBlocking': stage.isBlocking,
        },
      );
    }

    notifyListeners();
  }

  /// Gets the next incomplete blocking stage
  InitializationStage? get nextBlockingStage {
    return _stages
      .where((stage) => 
        stage.isBlocking && 
        !stage.isCompleted && 
        _stages.indexOf(stage) == _currentIndex)
      .firstOrNull;
  }

  /// Resets the progress of all stages
  void reset() {
    for (final stage in _stages) {
      stage.isCompleted = false;
      stage.error = null;
    }
    _currentIndex = 0;
    _hasError = false;
    notifyListeners();
  }

  /// Disposes of the progress tracker
  @override
  void dispose() {
    LoggerService.debug('Disposing initialization progress tracker');
    super.dispose();
  }
} 