import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../services/app_preferences.dart';

part 'app_preferences_provider.freezed.dart';
part 'app_preferences_provider.g.dart';

@freezed
class PreferencesState with _$PreferencesState {
  const factory PreferencesState({
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(false) bool highContrast,
    @Default(true) bool showOnboarding,
  }) = _PreferencesState;
}

@riverpod
class PreferencesNotifier extends _$PreferencesNotifier {
  late final AppPreferences _prefs = AppPreferences();

  @override
  FutureOr<PreferencesState> build() async {
    await _prefs.initialize();
    
    final themeMode = await _prefs.getThemeMode();
    final highContrast = await _prefs.getHighContrast();
    final showDebugInfo = await _prefs.getShowDebugInfo();

    return PreferencesState(
      themeMode: themeMode,
      highContrast: highContrast,
      showOnboarding: showDebugInfo,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _prefs.setThemeMode(mode);
      final currentState = await future;
      return currentState.copyWith(themeMode: mode);
    });
  }

  Future<void> setHighContrast(bool enabled) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _prefs.setHighContrast(enabled);
      final currentState = await future;
      return currentState.copyWith(highContrast: enabled);
    });
  }

  Future<void> setShowOnboarding(bool show) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _prefs.setShowDebugInfo(show);
      final currentState = await future;
      return currentState.copyWith(showOnboarding: show);
    });
  }
}