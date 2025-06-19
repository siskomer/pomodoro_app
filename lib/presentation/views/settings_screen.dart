import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../generated/l10n.dart';

class SettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final settingsViewModel = ref.read(settingsProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).settings)),
      body: settingsAsync.when(
        data: (settings) => Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pomodoro Süresi (dakika):',
                style: TextStyle(fontSize: 18),
              ),
              Slider(
                value: settings.pomodoroMinutes.toDouble(),
                min: 10,
                max: 60,
                divisions: 10,
                label: settings.pomodoroMinutes.toString(),
                onChanged: (value) =>
                    settingsViewModel.setPomodoroMinutes((value ~/ 5) * 5),
              ),
              Text(
                S.of(context).minutes(settings.pomodoroMinutes),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              const Text(
                'Mola Süresi (dakika):',
                style: TextStyle(fontSize: 18),
              ),
              Slider(
                value: settings.breakMinutes.toDouble(),
                min: 5,
                max: 30,
                divisions: 5,
                label: settings.breakMinutes.toString(),
                onChanged: (value) =>
                    settingsViewModel.setBreakMinutes((value ~/ 5) * 5),
              ),
              Text(
                S.of(context).minutes(settings.breakMinutes),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tam Odaklanma Modu',
                    style: TextStyle(fontSize: 18),
                  ),
                  Switch(
                    value: settings.fullFocusMode,
                    onChanged: (value) {
                      settingsViewModel.setFullFocusMode(value);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Hata: $e')),
      ),
    );
  }
}
