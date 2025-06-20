import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'theme_mode_provider.g.dart';

@HiveType(typeId: 10)
enum AppThemeMode {
  @HiveField(0)
  system,
  @HiveField(1)
  light,
  @HiveField(2)
  dark,
}

class ThemeModeNotifier extends StateNotifier<AppThemeMode> {
  static const String boxName = 'theme_mode_box';
  static const String key = 'theme_mode';
  late Box box;

  ThemeModeNotifier() : super(AppThemeMode.system) {
    _init();
  }

  Future<void> _init() async {
    box = await Hive.openBox(boxName);
    final saved = box.get(key);
    if (saved != null && saved is int) {
      state = AppThemeMode.values[saved];
    }
  }

  Future<void> setTheme(AppThemeMode mode) async {
    state = mode;
    await box.put(key, mode.index);
  }
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, AppThemeMode>(
      (ref) => ThemeModeNotifier(),
    );
