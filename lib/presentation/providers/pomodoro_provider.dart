import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/pomodoro_repository_impl.dart';
import '../../domain/usecases/start_pomodoro.dart';
import '../../domain/usecases/pause_pomodoro.dart';
import '../../domain/usecases/reset_pomodoro.dart';
import '../../domain/entities/pomodoro.dart';
import '../../services/notification_service.dart';
import '../viewmodels/pomodoro_viewmodel.dart';
import 'settings_provider.dart';

final notificationServiceProvider = Provider((ref) => NotificationService());

final pomodoroRepositoryProvider = Provider((ref) => PomodoroRepositoryImpl());

final pomodoroViewModelProvider =
    StateNotifierProvider.family<PomodoroViewModel, Pomodoro, dynamic>((
      ref,
      settings,
    ) {
      final notificationService = ref.watch(notificationServiceProvider);
      return PomodoroViewModel(
        pomodoroDuration: (settings.pomodoroMinutes ?? 25) * 60,
        breakDuration: (settings.breakMinutes ?? 5) * 60,
        notificationService: notificationService,
        notificationEnabled: settings.notificationEnabled,
        read: ref.read,
      );
    });
