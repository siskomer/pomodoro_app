import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/todo_repository_impl.dart';
import '../../domain/repositories/todo_repository.dart';
import '../viewmodels/todo_viewmodel.dart';

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  return TodoRepositoryImpl();
});

final todoProvider = StateNotifierProvider<TodoViewModel, TodoState>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return TodoViewModel(repository);
});
