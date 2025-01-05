import 'dart:async';
import 'logger_service.dart';

/// Service for tracking detailed navigation analytics and patterns
class NavigationAnalyticsService {
  static final NavigationAnalyticsService _instance = NavigationAnalyticsService._internal();
  factory NavigationAnalyticsService() => _instance;
  
  NavigationAnalyticsService._internal();

  final _navigationTimings = <String, DateTime>{};
  final _screenDurations = <String, List<Duration>>{};
  final _navigationPatterns = <String, int>{};
  Timer? _sessionTimer;
  String? _currentScreen;
  DateTime? _sessionStart;

  /// Tracks when navigation to a screen starts
  void trackNavigationStart(String routeName) {
    _navigationTimings[routeName] = DateTime.now();
    LoggerService.debug(
      'Navigation started',
      data: {'route': routeName},
    );
  }

  /// Tracks when navigation to a screen completes
  void trackNavigationComplete(String routeName) {
    final startTime = _navigationTimings[routeName];
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      LoggerService.debug(
        'Navigation completed',
        data: {
          'route': routeName,
          'duration_ms': duration.inMilliseconds,
        },
      );
      _navigationTimings.remove(routeName);
    }
  }

  /// Tracks screen view duration
  void trackScreenView(String? fromRoute, String toRoute) {
    if (_currentScreen != null) {
      final duration = DateTime.now().difference(_navigationTimings[_currentScreen] ?? DateTime.now());
      _screenDurations.putIfAbsent(_currentScreen!, () => []).add(duration);
      
      // Track navigation pattern
      final pattern = '$fromRoute->$toRoute';
      _navigationPatterns[pattern] = (_navigationPatterns[pattern] ?? 0) + 1;
      
      LoggerService.debug(
        'Screen view tracked',
        data: {
          'screen': _currentScreen,
          'duration_ms': duration.inMilliseconds,
          'pattern': pattern,
        },
      );
    }
    _currentScreen = toRoute;
    _navigationTimings[toRoute] = DateTime.now();
  }

  /// Starts tracking a new navigation session
  void startSession() {
    _sessionStart = DateTime.now();
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _logSessionMetrics(),
    );
    LoggerService.debug('Navigation session started');
  }

  /// Ends the current navigation session
  void endSession() {
    _sessionTimer?.cancel();
    _logSessionMetrics();
    _clearSessionData();
    LoggerService.debug('Navigation session ended');
  }

  /// Logs navigation performance metrics
  void _logSessionMetrics() {
    if (_sessionStart == null) return;

    final sessionDuration = DateTime.now().difference(_sessionStart!);
    final metrics = <String, dynamic>{
      'session_duration_minutes': sessionDuration.inMinutes,
      'total_navigations': _navigationPatterns.values.fold(0, (a, b) => a + b),
      'average_screen_durations': _calculateAverageScreenDurations(),
      'common_patterns': _getTopNavigationPatterns(3),
    };

    LoggerService.info(
      'Navigation session metrics',
      data: metrics,
    );
  }

  /// Calculates average duration for each screen
  Map<String, int> _calculateAverageScreenDurations() {
    final averages = <String, int>{};
    
    for (final entry in _screenDurations.entries) {
      if (entry.value.isNotEmpty) {
        final avgDuration = entry.value.fold<Duration>(
          Duration.zero,
          (sum, duration) => sum + duration,
        ).inMilliseconds ~/ entry.value.length;
        
        averages[entry.key] = avgDuration;
      }
    }
    
    return averages;
  }

  /// Gets the most common navigation patterns
  List<MapEntry<String, int>> _getTopNavigationPatterns(int count) {
    final patterns = _navigationPatterns.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return patterns.take(count).toList();
  }

  /// Clears all session data
  void _clearSessionData() {
    _navigationTimings.clear();
    _screenDurations.clear();
    _navigationPatterns.clear();
    _currentScreen = null;
    _sessionStart = null;
  }
} 