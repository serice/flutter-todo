import 'dart:convert';
import '../models/todo.model.dart';

class TodoService {
  List<Todo> getTodos() {
    final List<Todo> todos = [];
    Iterable i = jsonDecode( '['
        '{"user": { "name": "forrest"}, "uuid": "1", "date": "2023-02-28T00:00:00", "subject": "meeting", "todo": "with liam"},'
        '{"user": { "name": "liz"}, "uuid": "2", "date": "2023-03-02T00:00:00", "subject": "work out", "todo": "gym for PT"},'
        '{"user": { "name": "forrest"}, "uuid": "3", "date": "2023-03-02T00:00:00", "subject": "meeting", "todo": "with corn"},'
        '{"user": { "name": "forrest"}, "uuid": "4", "date": "2023-03-02T00:00:00", "subject": "meeting", "todo": "with stella"},'
        '{"user": { "name": "forrest"}, "uuid": "5", "date": "2023-03-03T00:00:00", "subject": "meeting", "todo": "with mino"},'
        '{"user": { "name": "stella"}, "uuid": "6", "date": "2023-03-04T00:00:00", "subject": "cleaning", "todo": "house keeping"},'
        '{"user": { "name": "corn"}, "uuid": "7", "date": "2023-03-05T00:00:00", "subject": "eating", "todo": "eating budai-zzigai"},'
        '{"user": { "name": "bomm"}, "uuid": "8", "date": "2023-03-05T00:00:00", "subject": "photo", "todo": "wedding photo"}'
        ']' );

    for (var todo in i) {
      todos.add(Todo.fromJson(todo));
    }
    return todos;
  }

  Todo addTodo(Todo todo) {
    return Todo.fromJson({...todo.toJson(), 'user': todo.user.toJson()});
  }

  Todo setTodo(Todo todo) {
    return Todo.fromJson({...todo.toJson(), 'user': todo.user.toJson()});
  }

  Todo deleteTodo(Todo todo) {
    return Todo.fromJson({...todo.toJson(), 'user': todo.user.toJson()});
  }
}
