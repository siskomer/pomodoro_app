import 'package:hive/hive.dart';

part 'settings_state.g.dart';

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
