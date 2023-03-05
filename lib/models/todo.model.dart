import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'user.model.dart';

part 'todo.model.g.dart';

@JsonSerializable()
class Todo {
  Todo({
    required this.user,
    required this.date,
    required this.subject,
    required this.todo,
    String? uuid,
    }
  ) {
    this.uuid = uuid ?? const Uuid().v4();
  }

  late String uuid;
  User user;
  DateTime date;
  String subject;
  String todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
  Map<String, dynamic> toJson() => _$TodoToJson(this);
}