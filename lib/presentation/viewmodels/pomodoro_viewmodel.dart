import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/pomodoro.dart';

class PomodoroViewModel extends StateNotifier<Pomodoro> {
  final int pomodoroDuration;
  final int breakDuration;
  Timer? _timer;

  PomodoroViewModel({
    required this.pomodoroDuration,
    required this.breakDuration,
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
      }
    });
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
