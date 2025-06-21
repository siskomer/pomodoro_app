import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/todo_item.dart';
import '../../domain/repositories/todo_repository.dart';

class TodoState {
  final List<TodoItem> todos;
  TodoState({this.todos = const []});

  TodoState copyWith({List<TodoItem>? todos}) {
    return TodoState(todos: todos ?? this.todos);
  }
}

class TodoViewModel extends StateNotifier<TodoState> {
  final TodoRepository _repository;

  TodoViewModel(this._repository) : super(TodoState()) {
    _init();
  }

  void _init() {
    state = state.copyWith(todos: _repository.getTodos());
  }

  Future<void> addTodo(String title) async {
    final newTodo = TodoItem(
      id: DateTime.now().toIso8601String(),
      title: title,
    );
    await _repository.addTodo(newTodo);
    state = state.copyWith(todos: _repository.getTodos());
  }

  Future<void> toggleTodo(String id) async {
    final todo = state.todos.firstWhere((t) => t.id == id);
    final updatedTodo = todo.copyWith(isDone: !todo.isDone);
    await _repository.updateTodo(updatedTodo);
    state = state.copyWith(todos: _repository.getTodos());
  }

  Future<void> removeTodo(String id) async {
    await _repository.removeTodo(id);
    state = state.copyWith(todos: _repository.getTodos());
  }
}
