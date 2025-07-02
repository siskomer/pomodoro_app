class Pomodoro {
  final int duration;
  final int remaining;
  final bool isRunning;
  final bool isBreak;
  final bool isWaitingForNext;

  Pomodoro({
    required this.duration,
    required this.remaining,
    this.isRunning = false,
    this.isBreak = false,
    this.isWaitingForNext = false,
  });

  Pomodoro copyWith({
    int? duration,
    int? remaining,
    bool? isRunning,
    bool? isBreak,
    bool? isWaitingForNext,
  }) {
    return Pomodoro(
      duration: duration ?? this.duration,
      remaining: remaining ?? this.remaining,
      isRunning: isRunning ?? this.isRunning,
      isBreak: isBreak ?? this.isBreak,
      isWaitingForNext: isWaitingForNext ?? this.isWaitingForNext,
    );
  }
}
