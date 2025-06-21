import '../entities/pomodoro_record.dart';

abstract class StatsRepository {
  Future<void> init();
  List<PomodoroRecord> getRecords();
  Future<void> addRecord(PomodoroRecord record);
}
