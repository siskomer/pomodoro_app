import 'package:hive/hive.dart';
import '../../domain/entities/todo_item.dart';
import '../../domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  late Box<TodoItem> _box;
  static const String boxName = 'todos_box';

  @override
  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      _box = await Hive.openBox<TodoItem>(boxName);
    } else {
      _box = Hive.box<TodoItem>(boxName);
    }
  }

  @override
  List<TodoItem> getTodos() {
    return _box.values.toList();
  }

  @override
  Future<void> addTodo(TodoItem todo) async {
    await _box.put(todo.id, todo);
  }

  @override
  Future<void> updateTodo(TodoItem todo) async {
    await _box.put(todo.id, todo);
  }

  @override
  Future<void> removeTodo(String id) async {
    await _box.delete(id);
  }
}
