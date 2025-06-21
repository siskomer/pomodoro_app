import '../entities/todo_item.dart';

abstract class TodoRepository {
  Future<void> init();
  List<TodoItem> getTodos();
  Future<void> addTodo(TodoItem todo);
  Future<void> updateTodo(TodoItem todo);
  Future<void> removeTodo(String id);
}
