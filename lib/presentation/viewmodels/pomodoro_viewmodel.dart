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
    if (notificationEnabled) {
      notificationService.cancelOngoingNotification(999);
      notificationService.cancelNotification(1);
    }
  }

  void reset() {
    _timer?.cancel();
    state = Pomodoro(
      duration: pomodoroDuration,
      remaining: pomodoroDuration,
      isRunning: false,
      isBreak: false,
    );
    if (notificationEnabled) {
      notificationService.cancelOngoingNotification(999);
      notificationService.cancelNotification(1);
    }
  }

  void _startTimer() {
    state = state.copyWith(isRunning: true);

    if (notificationEnabled) {
      final scheduledDate = DateTime.now().add(
        Duration(seconds: state.remaining),
      );
      notificationService.scheduleNotification(
        id: 1,
        title: state.isBreak ? 'Mola Bitti!' : 'Pomodoro Tamamlandı!',
        body: state.isBreak
            ? 'Şimdi çalışma zamanı.'
            : 'Harika iş! Kısa bir mola ver.',
        scheduledDate: scheduledDate,
      );
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (state.remaining > 0) {
        state = state.copyWith(remaining: state.remaining - 1);
        if (notificationEnabled) {
          final minutes = (state.remaining ~/ 60).toString().padLeft(2, '0');
          final seconds = (state.remaining % 60).toString().padLeft(2, '0');
          final timeStr = '$minutes:$seconds';
          await notificationService.showOngoingNotification(
            id: 999,
            title: state.isBreak ? 'Mola Zamanı' : 'Pomodoro Zamanı',
            body: 'Kalan süre: $timeStr',
          );
        }
      } else {
        _timer?.cancel();
        state = state.copyWith(isRunning: false);
        if (notificationEnabled) {
          await notificationService.cancelOngoingNotification(999);
          await notificationService.cancelNotification(1);
        }
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
