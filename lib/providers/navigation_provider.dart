import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/environment.dart';
import '../services/navigation_analytics_service.dart';

/// Provider for managing navigation state
final navigationStateProvider = StateNotifierProvider<NavigationStateNotifier, NavigationState>((ref) {
  return NavigationStateNotifier();
});

/// State for navigation configuration and tracking
class NavigationState {
  final bool isFirstRun;
  final bool analyticsEnabled;
  final String? currentRoute;
  final String? previousRoute;
  final Map<String, int> visitCounts;
  final DateTime? sessionStart;

  const NavigationState({
    this.isFirstRun = false,
    this.analyticsEnabled = false,
    this.currentRoute,
    this.previousRoute,
    this.visitCounts = const {},
    this.sessionStart,
  });

  NavigationState copyWith({
    bool? isFirstRun,
    bool? analyticsEnabled,
    String? currentRoute,
    String? previousRoute,
    Map<String, int>? visitCounts,
    DateTime? sessionStart,
  }) {
    return NavigationState(
      isFirstRun: isFirstRun ?? this.isFirstRun,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      currentRoute: currentRoute ?? this.currentRoute,
      previousRoute: previousRoute ?? this.previousRoute,
      visitCounts: visitCounts ?? this.visitCounts,
      sessionStart: sessionStart ?? this.sessionStart,
    );
  }
}

/// Notifier for managing navigation state
class NavigationStateNotifier extends StateNotifier<NavigationState> {
  final _analytics = NavigationAnalyticsService();
  
  NavigationStateNotifier() : super(NavigationState(
    analyticsEnabled: !Environment.isDevelopment,
    sessionStart: DateTime.now(),
  ));

  void recordNavigation(String route) {
    final counts = Map<String, int>.from(state.visitCounts);
    counts[route] = (counts[route] ?? 0) + 1;
    
    state = state.copyWith(
      previousRoute: state.currentRoute,
      currentRoute: route,
      visitCounts: counts,
    );

    if (state.analyticsEnabled) {
      _analytics.trackScreenView(state.previousRoute, route);
    }
  }

  void startSession() {
    if (state.analyticsEnabled) {
      _analytics.startSession();
    }
    
    state = state.copyWith(
      sessionStart: DateTime.now(),
      visitCounts: {},
    );
  }

  void endSession() {
    if (state.analyticsEnabled) {
      _analytics.endSession();
    }
  }

  void setAnalyticsEnabled(bool enabled) {
    if (enabled != state.analyticsEnabled) {
      state = state.copyWith(analyticsEnabled: enabled);
      if (enabled) {
        _analytics.startSession();
      } else {
        _analytics.endSession();
      }
    }
  }
} 