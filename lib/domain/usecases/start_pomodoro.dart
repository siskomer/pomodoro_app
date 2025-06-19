import '../repositories/pomodoro_repository.dart';

class StartPomodoro {
  final PomodoroRepository repository;

  StartPomodoro(this.repository);

  void call() {
    repository.start();
  }
}
