import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pomodoro_provider.dart';
import '../providers/stats_provider.dart';
import '../providers/settings_provider.dart';
import '../../l10n/app_localizations.dart';

class PomodoroScreen extends ConsumerStatefulWidget {
  const PomodoroScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends ConsumerState<PomodoroScreen> {
  bool isFocusMode = false;

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  final List<String> motivasyonSozleri = [
    "Harikasın! Devam et! 🚀",
    "Odaklan, başaracaksın! 💪",
    "Küçük adımlar büyük fark yaratır! 🌱",
    "Bir Pomodoro daha, bir adım daha! 🕒",
    "Kendine güven! ⭐️",
  ];

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    if (settingsAsync.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (settingsAsync.hasError) {
      return Scaffold(body: Center(child: Text('Ayarlar yüklenemedi')));
    }
    final settings = settingsAsync.value!;
    final pomodoro = ref.watch(pomodoroViewModelProvider(settings));
    final viewModel = ref.read(pomodoroViewModelProvider(settings).notifier);
    final statsViewModel = ref.read(statsProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Sadece odak zamanı olduğu için sabit renk
    final gradientColors = [colorScheme.primary, colorScheme.secondary];

    // Pomodoro tamamlandığında istatistiklere kayıt ekle
    if (pomodoro.remaining == 0 && pomodoro.isRunning == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final focusMinutes = (viewModel.pomodoroDuration / 60).round();
        final breakMinutes = (viewModel.breakDuration / 60).round();
        statsViewModel.addRecord(
          focusMinutes: focusMinutes,
          breakMinutes: breakMinutes,
        );
      });
    }

    if (isFocusMode) {
      // ODAK MODU: Sadece siyah arka plan ve sayaç + çıkış butonu
      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 180,
                        height: 180,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: 1.0,
                            end: pomodoro.remaining / pomodoro.duration,
                          ),
                          duration: const Duration(milliseconds: 500),
                          builder: (context, value, child) {
                            return CircularProgressIndicator(
                              value: value,
                              strokeWidth: 12,
                              backgroundColor: Colors.white12,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                      Text(
                        formatTime(pomodoro.remaining),
                        style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 32),
                  onPressed: () {
                    setState(() {
                      isFocusMode = false;
                    });
                  },
                  tooltip: 'Odak modundan çık',
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Normal mod
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text('Pomodoro'),
        backgroundColor: colorScheme.primary,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.focusTime,
              style: theme.textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: 1.0,
                        end: pomodoro.remaining / pomodoro.duration,
                      ),
                      duration: const Duration(milliseconds: 500),
                      builder: (context, value, child) {
                        return CircularProgressIndicator(
                          value: value,
                          strokeWidth: 10,
                          backgroundColor: Colors.white24,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                  Text(
                    formatTime(pomodoro.remaining),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    if (pomodoro.isRunning) {
                      viewModel.pause();
                    } else {
                      viewModel.start();
                      if (settings.fullFocusMode) {
                        setState(() {
                          isFocusMode = true;
                        });
                      }
                    }
                  },
                  icon: Icon(
                    pomodoro.isRunning ? Icons.pause : Icons.play_arrow,
                  ),
                  label: Text(
                    pomodoro.isRunning
                        ? AppLocalizations.of(context)!.pause
                        : AppLocalizations.of(context)!.start,
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 6,
                    shadowColor: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: viewModel.reset,
                  icon: const Icon(Icons.refresh),
                  label: Text(AppLocalizations.of(context)!.reset),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    elevation: 6,
                    shadowColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
