import '../../domain/entities/pomodoro.dart';
import '../../domain/repositories/pomodoro_repository.dart';

class PomodoroRepositoryImpl implements PomodoroRepository {
  Pomodoro _pomodoro = Pomodoro(
    duration: 1500,
    remaining: 1500,
    isRunning: false,
  );

  @override
  Pomodoro getCurrentPomodoro() => _pomodoro;

  @override
  void start() {
    _pomodoro = Pomodoro(
      duration: _pomodoro.duration,
      remaining: _pomodoro.remaining,
      isRunning: true,
    );
  }

  @override
  void pause() {
    _pomodoro = Pomodoro(
      duration: _pomodoro.duration,
      remaining: _pomodoro.remaining,
      isRunning: false,
    );
  }

  @override
  void reset() {
    _pomodoro = Pomodoro(
      duration: _pomodoro.duration,
      remaining: _pomodoro.duration,
      isRunning: false,
    );
  }
}
