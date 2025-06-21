import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/entities/settings_state.dart';
import '../../domain/repositories/settings_repository.dart';
import '../viewmodels/settings_viewmodel.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl();
});

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState?>((ref) {
      final repository = ref.watch(settingsRepositoryProvider);
      return SettingsNotifier(repository);
    });
