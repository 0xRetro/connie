import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/first_run_provider.dart';
import '../ui/screens/main_screen.dart';
import '../ui/screens/settings_screen.dart';
import '../ui/screens/people_screen.dart';
import '../ui/screens/setup_workflow_screen.dart';
import '../ui/screens/error_screen.dart';
import '../services/logger_service.dart';
import '../services/navigation_analytics_service.dart';
import '../config/environment.dart';

/// Global router configuration for the application
final appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: Environment.isDevelopment,
  errorBuilder: (context, state) {
    LoggerService.error(
      'Navigation error',
      error: state.error,
      data: {'location': state.uri.toString()},
    );
    return ErrorScreen(error: state.error);
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        LoggerService.logNavigation('previous', 'main');
        return const MainScreen();
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) {
        LoggerService.logNavigation('previous', 'settings');
        return const SettingsScreen();
      },
    ),
    GoRoute(
      path: '/people',
      builder: (context, state) {
        LoggerService.logNavigation('previous', 'people');
        return const PeopleScreen();
      },
    ),
    GoRoute(
      path: '/setup',
      builder: (context, state) {
        LoggerService.logNavigation('previous', 'setup');
        return const SetupWorkflowScreen();
      },
    ),
    GoRoute(
      path: '/error',
      builder: (context, state) {
        LoggerService.logNavigation('previous', 'error');
        return ErrorScreen(error: state.error);
      },
    ),
  ],
  observers: [
    GoRouterObserver(),
  ],
);

/// Custom observer for router events
class GoRouterObserver extends NavigatorObserver {
  final _analytics = NavigationAnalyticsService();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final routeName = _getRouteName(route);
    final previousName = _getRouteName(previousRoute);
    
    _analytics.trackNavigationStart(routeName);
    _analytics.trackScreenView(previousName, routeName);
    
    LoggerService.debug(
      'Navigation push',
      data: {
        'to': routeName,
        'from': previousName,
      },
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final routeName = _getRouteName(route);
    final previousName = _getRouteName(previousRoute);
    
    _analytics.trackScreenView(routeName, previousName);
    
    LoggerService.debug(
      'Navigation pop',
      data: {
        'from': routeName,
        'to': previousName,
      },
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final newName = _getRouteName(newRoute);
    final oldName = _getRouteName(oldRoute);
    
    _analytics.trackNavigationStart(newName);
    _analytics.trackScreenView(oldName, newName);
    
    LoggerService.debug(
      'Navigation replace',
      data: {
        'new': newName,
        'old': oldName,
      },
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final routeName = _getRouteName(route);
    final previousName = _getRouteName(previousRoute);
    
    LoggerService.debug(
      'Navigation remove',
      data: {
        'route': routeName,
        'previous': previousName,
      },
    );
  }

  /// Gets a standardized route name for analytics
  String _getRouteName(Route<dynamic>? route) {
    if (route == null) return 'unknown';
    return route.settings.name ?? route.settings.toString().split(' ').last;
  }
} 