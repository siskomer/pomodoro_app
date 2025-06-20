class Pomodoro {
  final int duration;
  final int remaining;
  final bool isRunning;
  final bool isBreak;

  Pomodoro({
    required this.duration,
    required this.remaining,
    this.isRunning = false,
    this.isBreak = false,
  });

  Pomodoro copyWith({
    int? duration,
    int? remaining,
    bool? isRunning,
    bool? isBreak,
  }) {
    return Pomodoro(
      duration: duration ?? this.duration,
      remaining: remaining ?? this.remaining,
      isRunning: isRunning ?? this.isRunning,
      isBreak: isBreak ?? this.isBreak,
    );
  }
}
