import '../repositories/pomodoro_repository.dart';

class ResetPomodoro {
  final PomodoroRepository repository;

  ResetPomodoro(this.repository);

  void call() {
    repository.reset();
  }
}
