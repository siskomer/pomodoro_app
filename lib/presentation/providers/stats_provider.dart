import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/stats_repository_impl.dart';
import '../../domain/repositories/stats_repository.dart';
import '../viewmodels/stats_viewmodel.dart';

final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  return StatsRepositoryImpl();
});

final statsProvider = StateNotifierProvider<StatsViewModel, StatsState>((ref) {
  final repository = ref.watch(statsRepositoryProvider);
  return StatsViewModel(repository);
});
