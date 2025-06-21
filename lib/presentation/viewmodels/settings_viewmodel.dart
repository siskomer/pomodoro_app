import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/settings_state.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsNotifier extends StateNotifier<SettingsState?> {
  final SettingsRepository _repository;

  SettingsNotifier(this._repository) : super(null) {
    _initializeSettings();
  }

  void _initializeSettings() {
    state = _repository.getSettings();
  }

  Future<void> setPomodoroMinutes(int minutes) async {
    if (state == null) return;
    final newState = state!.copyWith(pomodoroMinutes: minutes);
    state = newState;
    await _repository.saveSettings(newState);
  }

  Future<void> setBreakMinutes(int minutes) async {
    if (state == null) return;
    final newState = state!.copyWith(breakMinutes: minutes);
    state = newState;
    await _repository.saveSettings(newState);
  }

  Future<void> setFullFocusMode(bool value) async {
    if (state == null) return;
    final newState = state!.copyWith(fullFocusMode: value);
    state = newState;
    await _repository.saveSettings(newState);
  }

  Future<void> setNotificationEnabled(bool value) async {
    if (state == null) return;
    final newState = state!.copyWith(notificationEnabled: value);
    state = newState;
    await _repository.saveSettings(newState);
  }

  Future<void> setKeepScreenOn(bool value) async {
    if (state == null) return;
    final newState = state!.copyWith(keepScreenOn: value);
    state = newState;
    await _repository.saveSettings(newState);
  }
}
