import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/pomodoro.dart';

class PomodoroViewModel extends StateNotifier<Pomodoro> {
  int pomodoroDuration; // saniye
  int breakDuration; // saniye
  Timer? _timer;

  PomodoroViewModel({this.pomodoroDuration = 1500, this.breakDuration = 300})
    : super(
        Pomodoro(
          duration: pomodoroDuration,
          remaining: pomodoroDuration,
          isRunning: false,
        ),
      );

  void start() {
    if (state.isRunning) return;
    state = Pomodoro(
      duration: state.duration,
      remaining: state.remaining,
      isRunning: true,
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remaining > 0 && state.isRunning) {
        state = Pomodoro(
          duration: state.duration,
          remaining: state.remaining - 1,
          isRunning: true,
        );
      } else {
        timer.cancel();
        state = Pomodoro(
          duration: state.duration,
          remaining: 0,
          isRunning: false,
        );
      }
    });
  }

  void pause() {
    if (!state.isRunning) return;
    _timer?.cancel();
    state = Pomodoro(
      duration: state.duration,
      remaining: state.remaining,
      isRunning: false,
    );
  }

  void reset() {
    _timer?.cancel();
    state = Pomodoro(
      duration: pomodoroDuration,
      remaining: pomodoroDuration,
      isRunning: false,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
