import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/settings_viewmodel.dart';

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState?>(
      (ref) => SettingsNotifier(),
    );
