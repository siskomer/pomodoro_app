import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_app/domain/entities/pomodoro.dart';
import 'package:pomodoro_app/presentation/viewmodels/pomodoro_viewmodel.dart';
import '../providers/pomodoro_provider.dart';
import '../providers/stats_provider.dart';
import '../providers/settings_provider.dart';
import '../../domain/entities/settings_state.dart';
import '../theme.dart';
import 'dart:async';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:easy_localization/easy_localization.dart';

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
      // Bu alan artık ViewModel tarafından yönetildiği için boş bırakılabilir.
      // Gelecekte sadece UI ile ilgili state dinlemeleri için kullanılabilir.
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        formatTime(pomodoro.remaining),
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          fontFamily: 'monospace',
                        ),
                      ),
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
                      child: Text(
                        'exit_full_focus_prompt'.tr(),
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
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'pomodoro_timer'.tr(),
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: theme.colorScheme.background,
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
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height - kToolbarHeight - 48,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    Center(child: _buildTimer(theme, pomodoro)),
                    const SizedBox(height: 40),
                    if (pomodoro.isWaitingForNext)
                      ElevatedButton(
                        onPressed: () {
                          viewModel.switchMode();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: pomodoro.isBreak
                              ? AppTheme.primaryColor
                              : AppTheme.successColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          pomodoro.isBreak ? 'Pomodoro Başlat' : 'Mola Başlat',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else
                      _buildControls(viewModel, pomodoro, theme, settings),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimer(ThemeData theme, Pomodoro pomodoro) {
    final isBreak = pomodoro.isBreak;
    final gradient = isBreak
        ? [AppTheme.successColor, const Color(0xFF4ADE80)]
        : [AppTheme.primaryColor, AppTheme.accentColor];
    return SizedBox(
      width: 260,
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Çok katmanlı, gradientli progress bar
          ShaderMask(
            shaderCallback: (rect) {
              return SweepGradient(
                startAngle: -1.57,
                endAngle: 4.71,
                colors: gradient,
                stops: const [0.0, 1.0],
                transform: GradientRotation(-1.57),
              ).createShader(rect);
            },
            child: CircularProgressIndicator(
              value: pomodoro.duration > 0
                  ? pomodoro.remaining / pomodoro.duration
                  : 0,
              strokeWidth: 16,
              backgroundColor: theme.colorScheme.surface.withOpacity(0.10),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          // Glassmorphism Effect
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        formatTime(pomodoro.remaining),
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
            if (settings != null && settings.keepScreenOn) {
              WakelockPlus.enable();
            } else {
              WakelockPlus.disable();
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
            onPressed: () {
              WakelockPlus.disable();
              viewModel.reset();
            },
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
