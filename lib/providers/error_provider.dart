import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/logger_service.dart';
import '../config/environment.dart';

/// Provider for managing error handling state
final errorStateProvider = StateNotifierProvider<ErrorStateNotifier, ErrorState>((ref) {
  return ErrorStateNotifier();
});

/// State for error handling configuration
class ErrorState {
  final bool showDebugInfo;
  final bool logToFile;
  final List<AppError> errorHistory;
  final DateTime? lastError;
  final bool hasUnhandledError;

  const ErrorState({
    this.showDebugInfo = false,
    this.logToFile = true,
    this.errorHistory = const [],
    this.lastError,
    this.hasUnhandledError = false,
  });

  ErrorState copyWith({
    bool? showDebugInfo,
    bool? logToFile,
    List<AppError>? errorHistory,
    DateTime? lastError,
    bool? hasUnhandledError,
  }) {
    return ErrorState(
      showDebugInfo: showDebugInfo ?? this.showDebugInfo,
      logToFile: logToFile ?? this.logToFile,
      errorHistory: errorHistory ?? this.errorHistory,
      lastError: lastError ?? this.lastError,
      hasUnhandledError: hasUnhandledError ?? this.hasUnhandledError,
    );
  }
}

/// Represents an application error with context
class AppError {
  final String message;
  final Object error;
  final StackTrace? stackTrace;
  final String? context;
  final DateTime timestamp;
  final bool isHandled;

  AppError({
    required this.message,
    required this.error,
    this.stackTrace,
    this.context,
    DateTime? timestamp,
    this.isHandled = false,
  }) : timestamp = timestamp ?? DateTime.now();

  AppError copyWith({
    String? message,
    Object? error,
    StackTrace? stackTrace,
    String? context,
    DateTime? timestamp,
    bool? isHandled,
  }) {
    return AppError(
      message: message ?? this.message,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
      context: context ?? this.context,
      timestamp: timestamp ?? this.timestamp,
      isHandled: isHandled ?? this.isHandled,
    );
  }

  @override
  String toString() {
    return '$message: $error${context != null ? ' in $context' : ''}';
  }
}

/// Notifier for managing error state
class ErrorStateNotifier extends StateNotifier<ErrorState> {
  static const _maxHistorySize = 50;
  
  ErrorStateNotifier() : super(ErrorState(
    showDebugInfo: Environment.isDevelopment,
    logToFile: !Environment.isDevelopment,
  ));

  void recordError(AppError error) {
    final history = List<AppError>.from(state.errorHistory);
    if (history.length >= _maxHistorySize) {
      history.removeAt(0);
    }
    history.add(error);

    state = state.copyWith(
      errorHistory: history,
      lastError: DateTime.now(),
      hasUnhandledError: !error.isHandled,
    );

    LoggerService.error(
      error.message,
      error: error.error,
      stackTrace: error.stackTrace,
      data: {'context': error.context},
    );
  }

  void markErrorHandled(AppError error) {
    final history = state.errorHistory.map((e) {
      if (e == error) {
        return e.copyWith(isHandled: true);
      }
      return e;
    }).toList();

    state = state.copyWith(
      errorHistory: history,
      hasUnhandledError: history.any((e) => !e.isHandled),
    );
  }

  void clearErrorHistory() {
    state = state.copyWith(
      errorHistory: [],
      hasUnhandledError: false,
    );
  }

  void setDebugInfo(bool showDebugInfo) {
    state = state.copyWith(showDebugInfo: showDebugInfo);
  }

  void setLogToFile(bool logToFile) {
    state = state.copyWith(logToFile: logToFile);
  }
} 