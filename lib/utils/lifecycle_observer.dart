import 'package:flutter/material.dart';
import '../services/logger_service.dart';

/// A widget binding observer that handles application lifecycle state changes.
/// 
/// This observer is primarily used to manage cleanup operations when the app
/// is terminated or moved to a detached state.
class LifecycleObserver extends WidgetsBindingObserver {
  /// Callback function to be executed when the app enters detached state
  final Future<void> Function() onDetach;
  
  /// Callback function to be executed when the app is paused
  final void Function()? onPause;
  
  /// Callback function to be executed when the app is resumed
  final Future<void> Function()? onResume;
  
  /// Creates a new [LifecycleObserver] instance
  /// 
  /// Requires an [onDetach] callback that will be called when the app
  /// enters a detached state. Optional [onPause] and [onResume] callbacks
  /// can be provided to handle those lifecycle states.
  LifecycleObserver({
    required this.onDetach,
    this.onPause,
    this.onResume,
  });

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    LoggerService.debug('App lifecycle state changed to: $state');
    switch (state) {
      case AppLifecycleState.detached:
        await onDetach();
        break;
      case AppLifecycleState.paused:
        onPause?.call();
        break;
      case AppLifecycleState.resumed:
        await onResume?.call();
        break;
      default:
        break;
    }
  }
} 