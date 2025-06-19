import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
part 'stats_viewmodel.g.dart';

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

class StatsState {
  final List<PomodoroRecord> records;
  StatsState({this.records = const []});

  StatsState copyWith({List<PomodoroRecord>? records}) {
    return StatsState(records: records ?? this.records);
  }

  int getPomodorosFor(DateTime from, DateTime to) {
    return records
        .where((r) => !r.date.isBefore(from) && r.date.isBefore(to))
        .length;
  }

  int getFocusMinutesFor(DateTime from, DateTime to) {
    return records
        .where((r) => !r.date.isBefore(from) && r.date.isBefore(to))
        .fold(0, (sum, r) => sum + r.focusMinutes);
  }

  int getBreakMinutesFor(DateTime from, DateTime to) {
    return records
        .where((r) => !r.date.isBefore(from) && r.date.isBefore(to))
        .fold(0, (sum, r) => sum + r.breakMinutes);
  }
}

class StatsViewModel extends StateNotifier<StatsState> {
  static const String boxName = 'pomodoro_stats';
  late Box<PomodoroRecord> _box;

  StatsViewModel() : super(StatsState()) {
    _init();
  }

  Future<void> _init() async {
    _box = await Hive.openBox<PomodoroRecord>(boxName);
    state = StatsState(records: _box.values.toList());
  }

  Future<void> addRecord({
    required int focusMinutes,
    required int breakMinutes,
  }) async {
    final now = DateTime.now();
    final record = PomodoroRecord(
      date: now,
      focusMinutes: focusMinutes,
      breakMinutes: breakMinutes,
    );
    await _box.add(record);
    state = StatsState(records: _box.values.toList());
  }
}
