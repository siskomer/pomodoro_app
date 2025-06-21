import 'package:hive/hive.dart';

part 'pomodoro_record.g.dart';

@HiveType(typeId: 0)
class PomodoroRecord extends HiveObject {
  @HiveField(0)
  final DateTime date;
  @HiveField(1)
  final int focusMinutes;
  @HiveField(2)
  final int breakMinutes;
  PomodoroRecord({
    required this.date,
    required this.focusMinutes,
    required this.breakMinutes,
  });
}
