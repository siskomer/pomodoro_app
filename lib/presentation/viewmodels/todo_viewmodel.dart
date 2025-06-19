import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoItem {
  final String id;
  final String title;
  final bool isDone;

  TodoItem({required this.id, required this.title, this.isDone = false});

  TodoItem copyWith({String? id, String? title, bool? isDone}) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }
}

class TodoState {
  final List<TodoItem> todos;
  TodoState({this.todos = const []});

  TodoState copyWith({List<TodoItem>? todos}) {
    return TodoState(todos: todos ?? this.todos);
  }
}

class TodoViewModel extends StateNotifier<TodoState> {
  TodoViewModel() : super(TodoState());

  void addTodo(String title) {
    final newTodo = TodoItem(
      id: DateTime.now().toIso8601String(),
      title: title,
    );
    state = state.copyWith(todos: [...state.todos, newTodo]);
  }

  void toggleTodo(String id) {
    state = state.copyWith(
      todos: state.todos
          .map(
            (todo) =>
                todo.id == id ? todo.copyWith(isDone: !todo.isDone) : todo,
          )
          .toList(),
    );
  }

  void removeTodo(String id) {
    state = state.copyWith(
      todos: state.todos.where((todo) => todo.id != id).toList(),
    );
  }
}
