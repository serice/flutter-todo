import 'package:flutter/cupertino.dart';

import '../../models/todo.model.dart';
import '../../services/todo.service.dart';
import 'auth.provider.dart';

class TodoProvider with ChangeNotifier {

  final _todoService = TodoService();
  late AuthProvider _authProvider;

  List<Todo> _todos = <Todo>[];
  List<Todo> _selectedTodos = <Todo>[];

  TodoProvider() {
    _todos = _todoService.getTodos();
  }

  set(AuthProvider authProvider) {
    _authProvider = authProvider;
  }

  List<Todo> get todos => _todos;
  List<Todo> get selectedTodos => _selectedTodos;

  void setSelectedTodos(List<Todo> todos) {
    _selectedTodos = todos;
    notifyListeners();
  }

  void addTodo({
    required DateTime date,
    required String subject,
    required String todo,
  }) {
    var newTodo = _todoService.addTodo(Todo(
        user: _authProvider.me, date: date, subject: subject , todo: todo
    ));
    _todos.add(newTodo);
    notifyListeners();
  }

  void updateTodo(String uuid, {
    required DateTime date,
    required String subject,
    required String todo,
  }) {
    var index = _todos.indexWhere((e) => e.uuid == uuid);
    var newTodo = _todoService.setTodo(Todo(
      uuid: uuid, user: _todos[index].user, date: date, subject: subject , todo: todo
    ));
    _todos[index] = newTodo;

    var selectedTodoIndex = _selectedTodos.indexWhere((todo) => todo.uuid == uuid);
    _selectedTodos[selectedTodoIndex] = newTodo;
    notifyListeners();
  }

  void deleteTodo(String uuid) {
    debugPrint('delete $uuid');
    var index = _todos.indexWhere((todo) => todo.uuid == uuid);
    var todo = _todoService.deleteTodo(_todos[index]);
    debugPrint('find delete $index ${_todos.length}');
    _todos.removeAt(index);
    debugPrint('find delete $index ${_todos.length}');
    _selectedTodos.removeWhere((e) => e.uuid == todo.uuid);
    notifyListeners();
  }
}