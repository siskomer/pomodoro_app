import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/pomodoro_record.dart';
import '../../domain/repositories/stats_repository.dart';

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
  final StatsRepository _repository;

  StatsViewModel(this._repository) : super(StatsState()) {
    _init();
  }

  void _init() {
    state = StatsState(records: _repository.getRecords());
  }

  Future<void> addRecord({
    required int focusMinutes,
    required int breakMinutes,
  }) async {
    final record = PomodoroRecord(
      date: DateTime.now(),
      focusMinutes: focusMinutes,
      breakMinutes: breakMinutes,
    );
    await _repository.addRecord(record);
    state = StatsState(records: _repository.getRecords());
  }
}
