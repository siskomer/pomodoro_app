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
  @HiveField(3)
  final bool notificationEnabled;
  @HiveField(4)
  final bool keepScreenOn;

  SettingsState({
    this.pomodoroMinutes = 25,
    this.breakMinutes = 5,
    this.fullFocusMode = false,
    this.notificationEnabled = true,
    this.keepScreenOn = false,
  });

  SettingsState copyWith({
    int? pomodoroMinutes,
    int? breakMinutes,
    bool? fullFocusMode,
    bool? notificationEnabled,
    bool? keepScreenOn,
  }) {
    return SettingsState(
      pomodoroMinutes: pomodoroMinutes ?? this.pomodoroMinutes,
      breakMinutes: breakMinutes ?? this.breakMinutes,
      fullFocusMode: fullFocusMode ?? this.fullFocusMode,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      keepScreenOn: keepScreenOn ?? this.keepScreenOn,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState?> {
  static const String boxName = 'settings_box';
  late Box<SettingsState> _box;

  SettingsNotifier() : super(null) {
    _initializeSettings();
  }

  Future<void> _initializeSettings() async {
    print('[DEBUG] Ayarlar kutusu açılıyor...');
    try {
      _box = await Hive.openBox<SettingsState>(boxName);
      print('[DEBUG] Kutudaki anahtarlar: [36m${_box.keys}[0m');
      final savedSettings = _box.get('settings');
      print('[DEBUG] savedSettings: [33m$savedSettings[0m');
      if (savedSettings != null) {
        state = savedSettings;
        print('[DEBUG] State yüklendi: [32m$state[0m');
      } else {
        final defaultState = SettingsState();
        await _box.put('settings', defaultState);
        state = defaultState;
        print('[DEBUG] Default state kaydedildi: [35m$defaultState[0m');
      }
    } catch (e, s) {
      print('[HATA] Ayarlar kutusu açılırken hata: $e\n$s');
    }
  }

  Future<void> setPomodoroMinutes(int minutes) async {
    if (state == null) return;
    final newState = state!.copyWith(pomodoroMinutes: minutes);
    state = newState;
    await _box.put('settings', newState);
    print('[DEBUG] Pomodoro süresi kaydedildi: ${newState.pomodoroMinutes}');
  }

  Future<void> setBreakMinutes(int minutes) async {
    if (state == null) return;
    final newState = state!.copyWith(breakMinutes: minutes);
    state = newState;
    await _box.put('settings', newState);
    print('[DEBUG] Mola süresi kaydedildi: ${newState.breakMinutes}');
  }

  Future<void> setFullFocusMode(bool value) async {
    if (state == null) return;
    print('[SettingsViewModel] setFullFocusMode çağrıldı, değer: $value');
    final newState = state!.copyWith(fullFocusMode: value);
    state = newState;
    await _box.put('settings', newState);
    print('[DEBUG] Tam odaklanma modu kaydedildi: ${newState.fullFocusMode}');
    print(
      '[SettingsViewModel] State güncellendi. Yeni fullFocusMode: \u001b[32m${state!.fullFocusMode}\u001b[0m',
    );
  }

  Future<void> setNotificationEnabled(bool value) async {
    if (state == null) return;
    final newState = state!.copyWith(notificationEnabled: value);
    state = newState;
    await _box.put('settings', newState);
  }

  Future<void> setKeepScreenOn(bool value) async {
    if (state == null) return;
    final newState = state!.copyWith(keepScreenOn: value);
    state = newState;
    await _box.put('settings', newState);
  }
}
