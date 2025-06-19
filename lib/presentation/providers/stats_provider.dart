import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/stats_viewmodel.dart';

final statsProvider = StateNotifierProvider<StatsViewModel, StatsState>((ref) {
  return StatsViewModel();
});
