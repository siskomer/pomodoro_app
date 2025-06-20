import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
part 'settings_viewmodel.g.dart';

@HiveType(typeId: 1)
class SettingsState extends HiveObject {
  @HiveField(0)
  final int pomodoroMinutes;
  @HiveField(1)
  final int breakMinutes;
  @HiveField(2)
  final bool fullFocusMode;

  SettingsState({
    this.pomodoroMinutes = 25,
    this.breakMinutes = 5,
    this.fullFocusMode = false,
  });

  SettingsState copyWith({
    int? pomodoroMinutes,
    int? breakMinutes,
    bool? fullFocusMode,
  }) {
    return SettingsState(
      pomodoroMinutes: pomodoroMinutes ?? this.pomodoroMinutes,
      breakMinutes: breakMinutes ?? this.breakMinutes,
      fullFocusMode: fullFocusMode ?? this.fullFocusMode,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  static const String boxName = 'settings_box';
  late Box<SettingsState> _box;

  SettingsNotifier() : super(SettingsState()) {
    _initializeSettings();
  }

  Future<void> _initializeSettings() async {
    _box = await Hive.openBox<SettingsState>(boxName);
    if (_box.isNotEmpty) {
      final savedSettings = _box.get('settings');
      if (savedSettings != null) {
        state = savedSettings;
      }
    } else {
      final defaultState = SettingsState();
      await _box.put('settings', defaultState);
      state = defaultState;
    }
  }

  Future<void> setPomodoroMinutes(int minutes) async {
    final newState = state.copyWith(pomodoroMinutes: minutes);
    state = newState;
    await _box.put('settings', newState);
  }

  Future<void> setBreakMinutes(int minutes) async {
    final newState = state.copyWith(breakMinutes: minutes);
    state = newState;
    await _box.put('settings', newState);
  }

  Future<void> setFullFocusMode(bool value) async {
    final newState = state.copyWith(fullFocusMode: value);
    state = newState;
    await _box.put('settings', newState);
  }
}
