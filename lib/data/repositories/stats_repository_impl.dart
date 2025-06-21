import 'package:hive/hive.dart';
import '../../domain/entities/pomodoro_record.dart';
import '../../domain/repositories/stats_repository.dart';

class StatsRepositoryImpl implements StatsRepository {
  late Box<PomodoroRecord> _box;
  static const String boxName = 'pomodoro_stats';

  @override
  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      _box = await Hive.openBox<PomodoroRecord>(boxName);
    } else {
      _box = Hive.box<PomodoroRecord>(boxName);
    }
  }

  @override
  List<PomodoroRecord> getRecords() {
    return _box.values.toList();
  }

  @override
  Future<void> addRecord(PomodoroRecord record) async {
    await _box.add(record);
  }
}
