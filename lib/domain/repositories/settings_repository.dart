import '../entities/settings_state.dart';

abstract class SettingsRepository {
  Future<void> init();
  SettingsState? getSettings();
  Future<void> saveSettings(SettingsState settings);
}
