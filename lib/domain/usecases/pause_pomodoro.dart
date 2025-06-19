import '../repositories/pomodoro_repository.dart';

class PausePomodoro {
  final PomodoroRepository repository;

  PausePomodoro(this.repository);

  void call() {
    repository.pause();
  }
}
