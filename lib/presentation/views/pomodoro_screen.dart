import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_app/domain/entities/pomodoro.dart';
import 'package:pomodoro_app/presentation/viewmodels/pomodoro_viewmodel.dart';
import '../providers/pomodoro_provider.dart';
import '../providers/stats_provider.dart';
import '../providers/settings_provider.dart';
import '../viewmodels/settings_viewmodel.dart';
import '../theme.dart';
import 'dart:async';

class PomodoroScreen extends ConsumerStatefulWidget {
  const PomodoroScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends ConsumerState<PomodoroScreen> {
  bool isFullFocusActive = false;
  bool showInfo = true;
  Timer? _infoTimer;

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  void dispose() {
    _infoTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    if (settings == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final pomodoro = ref.watch(pomodoroViewModelProvider(settings));
    final viewModel = ref.read(pomodoroViewModelProvider(settings).notifier);
    final statsViewModel = ref.read(statsProvider.notifier);
    final theme = Theme.of(context);

    ref.listen<Pomodoro>(pomodoroViewModelProvider(settings), (previous, next) {
      if (previous != null &&
          previous.remaining > 0 &&
          next.remaining == 0 &&
          !next.isRunning) {
        final focusMinutes = (viewModel.pomodoroDuration / 60).round();
        final breakMinutes = (viewModel.breakDuration / 60).round();
        statsViewModel.addRecord(
          focusMinutes: focusMinutes,
          breakMinutes: breakMinutes,
        );
      }
    });

    if (isFullFocusActive) {
      // TAM ODAKLANMA MODU (sadece başlatınca aktif)
      return Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              isFullFocusActive = false;
              showInfo = true;
              _infoTimer?.cancel();
            });
          },
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    formatTime(pomodoro.remaining),
                    style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 80),
                  if (showInfo)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'Çıkmak için herhangi bir yere dokunun',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // NORMAL MOD
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: AppBar(
        title: Text(
          'Pomodoro Sayacı',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: const Color(0xFFF5F3FF),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: theme.colorScheme.onBackground,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              AppTheme.modernCard(
                backgroundColor: Colors.white,
                child: _buildTimer(theme, pomodoro),
              ),
              const Spacer(),
              _buildControls(viewModel, pomodoro, theme, settings),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimer(ThemeData theme, Pomodoro pomodoro) {
    return SizedBox(
      width: 300,
      height: 300,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(
          begin: 1.0,
          end: pomodoro.duration > 0
              ? pomodoro.remaining / pomodoro.duration
              : 0,
        ),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, child) {
          return Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: value,
                strokeWidth: 12,
                backgroundColor: theme.colorScheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(
                  pomodoro.isBreak
                      ? AppTheme.successColor
                      : AppTheme.primaryColor,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    formatTime(pomodoro.remaining),
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w300,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildControls(
    PomodoroViewModel viewModel,
    Pomodoro pomodoro,
    ThemeData theme,
    SettingsState? settings,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            if (!pomodoro.isRunning && settings!.fullFocusMode) {
              setState(() {
                isFullFocusActive = true;
                showInfo = true;
                _infoTimer?.cancel();
                _infoTimer = Timer(const Duration(seconds: 5), () {
                  if (mounted) {
                    setState(() {
                      showInfo = false;
                    });
                  }
                });
              });
            }
            viewModel.start();
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: pomodoro.isBreak
                ? AppTheme.successColor
                : AppTheme.primaryColor,
            minimumSize: const Size(72, 72),
            padding: EdgeInsets.zero,
            elevation: 2,
          ),
          child: Icon(
            pomodoro.isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
            size: 40,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        const SizedBox(width: 24),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.surfaceVariant,
          ),
          child: IconButton(
            onPressed: viewModel.reset,
            icon: Icon(
              Icons.refresh_rounded,
              size: 32,
              color: theme.colorScheme.onSurface,
            ),
            iconSize: 56,
            splashRadius: 28,
          ),
        ),
      ],
    );
  }
}
