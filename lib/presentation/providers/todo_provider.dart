import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/todo_viewmodel.dart';

final todoProvider = StateNotifierProvider<TodoViewModel, TodoState>((ref) {
  return TodoViewModel();
});
