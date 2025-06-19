class PomodoroModel {
  final int duration; // saniye cinsinden
  final int remaining;
  final bool isRunning;

  PomodoroModel({
    required this.duration,
    required this.remaining,
    required this.isRunning,
  });

  PomodoroModel copyWith({int? duration, int? remaining, bool? isRunning}) {
    return PomodoroModel(
      duration: duration ?? this.duration,
      remaining: remaining ?? this.remaining,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}
