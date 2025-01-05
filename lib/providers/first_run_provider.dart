import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/logger_service.dart';
import '../services/database_service.dart';

part 'first_run_provider.g.dart';

/// Provider for the first-run state
@riverpod
class FirstRunStateNotifier extends _$FirstRunStateNotifier {
  @override
  Future<bool> build() async {
    LoggerService.debug('Building FirstRunStateNotifier');
    return _loadFirstRunState();
  }

  /// Gets the current first-run state
  bool get isFirstRun => state.value ?? true;

  /// Loads the first-run state from storage
  Future<bool> _loadFirstRunState() async {
    try {
      final dbService = ref.read(databaseServiceProvider);
      final health = await dbService.checkDatabaseHealth();
      return !health['hasDefaultData'];
    } catch (e, stack) {
      LoggerService.error(
        'Error loading first-run state',
        error: e,
        stackTrace: stack,
      );
      return true;
    }
  }

  /// Resets the first-run state
  Future<void> resetFirstRun() async {
    try {
      state = const AsyncData(false);
      LoggerService.info('First run state reset successfully');
    } catch (e, stack) {
      LoggerService.error(
        'Error resetting first-run state',
        error: e,
        stackTrace: stack,
      );
      state = AsyncError(e, stack);
    }
  }
} 