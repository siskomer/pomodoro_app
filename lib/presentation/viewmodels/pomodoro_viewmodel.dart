import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/pomodoro.dart';
import '../../services/notification_service.dart';
import 'stats_viewmodel.dart';
import '../providers/stats_provider.dart';

class PomodoroViewModel extends StateNotifier<Pomodoro> {
  final int pomodoroDuration;
  final int breakDuration;
  final NotificationService notificationService;
  final bool notificationEnabled;
  final Function read;
  Timer? _timer;

  PomodoroViewModel({
    required this.pomodoroDuration,
    required this.breakDuration,
    required this.notificationService,
    required this.notificationEnabled,
    required this.read,
  }) : super(Pomodoro(duration: pomodoroDuration, remaining: pomodoroDuration));

  void start() {
    if (state.isRunning) {
      pause();
      return;
    }

    if (state.remaining == 0) {
      _switchModeAndStart();
    } else {
      _startTimer();
    }
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    _timer?.cancel();
    state = Pomodoro(
      duration: pomodoroDuration,
      remaining: pomodoroDuration,
      isRunning: false,
      isBreak: false,
    );
  }

  void _startTimer() {
    state = state.copyWith(isRunning: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remaining > 0) {
        state = state.copyWith(remaining: state.remaining - 1);
      } else {
        _timer?.cancel();
        state = state.copyWith(isRunning: false);
        _onTimerComplete();
      }
    });
  }

  void _onTimerComplete() {
    if (!state.isBreak) {
      final statsViewModel = read(statsProvider.notifier);
      statsViewModel.addRecord(
        focusMinutes: (pomodoroDuration / 60).round(),
        breakMinutes: (breakDuration / 60).round(),
      );
    }
    _notifyCompletion();
  }

  void _notifyCompletion() {
    if (!notificationEnabled) return;

    final title = state.isBreak ? 'Mola Bitti!' : 'Pomodoro Tamamlandı!';
    final body = state.isBreak
        ? 'Şimdi çalışma zamanı.'
        : 'Harika iş! Kısa bir mola ver.';
    notificationService.showNotification(id: 0, title: title, body: body);
  }

  void _switchModeAndStart() {
    final bool wasBreak = state.isBreak;
    final newDuration = wasBreak ? pomodoroDuration : breakDuration;

    state = Pomodoro(
      duration: newDuration,
      remaining: newDuration,
      isRunning: false,
      isBreak: !wasBreak,
    );

    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
