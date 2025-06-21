import 'package:hive/hive.dart';
import '../../domain/entities/settings_state.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  late Box<SettingsState> _box;
  static const String boxName = 'settings_box';
  static const String settingsKey = 'settings';

  @override
  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      _box = await Hive.openBox<SettingsState>(boxName);
    } else {
      _box = Hive.box<SettingsState>(boxName);
    }
  }

  @override
  SettingsState? getSettings() {
    return _box.get(settingsKey, defaultValue: SettingsState());
  }

  @override
  Future<void> saveSettings(SettingsState settings) async {
    await _box.put(settingsKey, settings);
  }
}
