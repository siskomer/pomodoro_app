import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/pomodoro.dart';
import '../../services/notification_service.dart';
import 'stats_viewmodel.dart';
import '../providers/stats_provider.dart';
import 'package:hive/hive.dart';

class PomodoroViewModel extends StateNotifier<Pomodoro> {
  final int pomodoroDuration;
  final int breakDuration;
  final NotificationService notificationService;
  final bool notificationEnabled;
  final Function read;
  Timer? _timer;
  static const String _hiveBox = 'pomodoro_timer_box';
  static const String _hiveKey = 'timer_state';

  PomodoroViewModel({
    required this.pomodoroDuration,
    required this.breakDuration,
    required this.notificationService,
    required this.notificationEnabled,
    required this.read,
  }) : super(
         Pomodoro(duration: pomodoroDuration, remaining: pomodoroDuration),
       ) {
    _restoreTimerState();
  }

  Future<void> _restoreTimerState() async {
    final box = await Hive.openBox(_hiveBox);
    final data = box.get(_hiveKey);
    if (data != null && data is Map) {
      final int? startEpoch = data['startTime'] as int?;
      final int? savedRemaining = data['remaining'] as int?;
      final bool? isBreak = data['isBreak'] as bool?;
      final bool? isRunning = data['isRunning'] as bool?;
      final int? duration = data['duration'] as int?;
      if (startEpoch != null &&
          savedRemaining != null &&
          isBreak != null &&
          isRunning != null &&
          duration != null) {
        final startTime = DateTime.fromMillisecondsSinceEpoch(startEpoch);
        final now = DateTime.now();
        int elapsed = now.difference(startTime).inSeconds;
        int newRemaining = savedRemaining - elapsed;
        if (newRemaining <= 0) {
          state = Pomodoro(
            duration: isBreak ? pomodoroDuration : breakDuration,
            remaining: isBreak ? pomodoroDuration : breakDuration,
            isRunning: false,
            isBreak: !isBreak,
          );
          await box.delete(_hiveKey);
        } else {
          state = Pomodoro(
            duration: duration,
            remaining: newRemaining,
            isRunning: isRunning,
            isBreak: isBreak,
          );
          if (isRunning) {
            _startTimer();
          }
        }
      }
    }
  }

  Future<void> _saveTimerState() async {
    final box = await Hive.openBox(_hiveBox);
    await box.put(_hiveKey, {
      'startTime': DateTime.now().millisecondsSinceEpoch,
      'remaining': state.remaining,
      'isBreak': state.isBreak,
      'isRunning': state.isRunning,
      'duration': state.duration,
    });
  }

  Future<void> _clearTimerState() async {
    final box = await Hive.openBox(_hiveBox);
    await box.delete(_hiveKey);
  }

  void start() {
    if (state.isRunning) {
      pause();
      return;
    }
    if (state.remaining == 0) {
      _switchMode();
    } else {
      state = state.copyWith(isRunning: true);
      _saveTimerState();
      _startTimer();
    }
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
    _clearTimerState();
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
    _clearTimerState();
    if (notificationEnabled) {
      notificationService.cancelOngoingNotification(999);
      notificationService.cancelNotification(1);
    }
  }

  void _startTimer() {
    state = state.copyWith(isRunning: true);
    _saveTimerState();

    if (notificationEnabled) {
      final scheduledDate = DateTime.now().add(
        Duration(seconds: state.remaining),
      );
      try {
        notificationService.scheduleNotification(
          id: 1,
          title: state.isBreak ? 'Mola Bitti!' : 'Pomodoro Tamamlandı!',
          body: state.isBreak
              ? 'Şimdi çalışma zamanı.'
              : 'Harika iş! Kısa bir mola ver.',
          scheduledDate: scheduledDate,
        );
      } catch (e) {
        print('Notification schedule error: $e');
      }
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      try {
        if (state.remaining > 0) {
          state = state.copyWith(remaining: state.remaining - 1);
          _saveTimerState();
          if (notificationEnabled) {
            final minutes = (state.remaining ~/ 60).toString().padLeft(2, '0');
            final seconds = (state.remaining % 60).toString().padLeft(2, '0');
            final timeStr = '$minutes:$seconds';
            try {
              await notificationService.showOngoingNotification(
                id: 999,
                title: state.isBreak ? 'Mola Zamanı' : 'Pomodoro Zamanı',
                body: 'Kalan süre: $timeStr',
              );
            } catch (e) {
              print('Ongoing notification error: $e');
            }
          }
        } else {
          _timer?.cancel();
          state = state.copyWith(isRunning: false);
          _clearTimerState();
          if (notificationEnabled) {
            try {
              await notificationService.cancelOngoingNotification(999);
              await notificationService.cancelNotification(1);
            } catch (e) {
              print('Notification cancel error: $e');
            }
          }
          try {
            _onTimerComplete();
          } catch (e, stack) {
            print('Pomodoro Timer Complete Exception: $e');
            print(stack);
          }
        }
      } catch (e, stack) {
        print('Pomodoro Timer Exception: $e');
        print(stack);
      }
    });
  }

  void _onTimerComplete() async {
    try {
      if (notificationEnabled) {
        await notificationService.cancelNotification(1);
      }
      if (!state.isBreak) {
        final statsViewModel = read(statsProvider.notifier);
        statsViewModel.addRecord(
          focusMinutes: (pomodoroDuration / 60).round(),
          breakMinutes: (breakDuration / 60).round(),
        );
      }
      _switchMode();
    } catch (e) {
      print('onTimerComplete error: $e');
    }
  }

  void _notifyCompletion() {
    if (!notificationEnabled) return;
    try {
      final title = state.isBreak ? 'Mola Bitti!' : 'Pomodoro Tamamlandı!';
      final body = state.isBreak
          ? 'Şimdi çalışma zamanı.'
          : 'Harika iş! Kısa bir mola ver.';
      // notificationService.showNotification(id: 0, title: title, body: body);
    } catch (e) {
      print('notifyCompletion error: $e');
    }
  }

  void _switchMode() {
    final bool wasBreak = state.isBreak;
    final newDuration = wasBreak ? pomodoroDuration : breakDuration;
    state = Pomodoro(
      duration: newDuration,
      remaining: newDuration,
      isRunning: false,
      isBreak: !wasBreak,
    );
    _clearTimerState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
