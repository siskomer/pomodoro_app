import '../entities/pomodoro.dart';

abstract class PomodoroRepository {
  Pomodoro getCurrentPomodoro();
  void start();
  void pause();
  void reset();
}
