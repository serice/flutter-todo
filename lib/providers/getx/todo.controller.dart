import 'package:get/get.dart';

import '../../models/todo.model.dart';
import '../../services/todo.service.dart';
import 'auth.controller.dart';

class TodoController extends GetxController {
  static TodoController to = Get.find();

  final todoService = TodoService();
  final authController = AuthController.to;
  late final RxList<Todo> todos;// = User(name: '').obs;
  final RxList<Todo> selectedTodos = <Todo>[].obs;

  @override
  void onInit() {
    todos = todoService.getTodos().obs;
    super.onInit();
  }

  void setSelectedTodos(List<Todo> todos) {
    selectedTodos.assignAll(todos);
  }

  void addTodo({
    required DateTime date,
    required String subject,
    required String todo,
  }) {
    var me = authController.me;
    var newTodo = todoService.addTodo(Todo(
        user: me.value, date: date, subject: subject , todo: todo
    ));
    todos.add(newTodo);
  }

  void updateTodo(String uuid, {
    required DateTime date,
    required String subject,
    required String todo,
  }) {
    var index = todos.indexWhere((e) => e.uuid == uuid);
    var newTodo = todoService.setTodo(Todo(
      uuid: uuid, user: todos[index].user, date: date, subject: subject , todo: todo
    ));
    todos[index] = newTodo;

    var selectedTodoIndex = selectedTodos.indexWhere((todo) => todo.uuid == uuid);
    selectedTodos[selectedTodoIndex] = newTodo;
  }

  void deleteTodo(String uuid) {
    var index = todos.indexWhere((todo) => todo.uuid == uuid);
    var todo = todoService.deleteTodo(todos[index]);
    todos.removeAt(index);
    selectedTodos.removeWhere((e) => e.uuid == todo.uuid);
  }
}