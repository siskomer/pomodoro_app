import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

part 'todo_viewmodel.g.dart';

@HiveType(typeId: 2) // Benzersiz bir typeId
class TodoItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
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
  late Box<TodoItem> _box;
  static const String boxName = 'todos_box';

  TodoViewModel() : super(TodoState()) {
    _init();
  }

  Future<void> _init() async {
    _box = await Hive.openBox<TodoItem>(boxName);
    state = state.copyWith(todos: _box.values.toList());
  }

  void addTodo(String title) {
    final newTodo = TodoItem(
      id: DateTime.now().toIso8601String(),
      title: title,
    );
    _box.put(newTodo.id, newTodo);
    state = state.copyWith(todos: [...state.todos, newTodo]);
  }

  void toggleTodo(String id) {
    final todo = _box.get(id);
    if (todo != null) {
      final updatedTodo = todo.copyWith(isDone: !todo.isDone);
      _box.put(id, updatedTodo);
      state = state.copyWith(
        todos: state.todos.map((t) => t.id == id ? updatedTodo : t).toList(),
      );
    }
  }

  void removeTodo(String id) {
    _box.delete(id);
    state = state.copyWith(
      todos: state.todos.where((todo) => todo.id != id).toList(),
    );
  }
}
