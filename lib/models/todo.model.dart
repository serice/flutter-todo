import 'package:json_annotation/json_annotation.dart';
import 'user.model.dart';

part 'todo.model.g.dart';

@JsonSerializable()
class Todo {
  Todo(
    this.uuid,
    this.user,
    this.date,
    this.subject,
    this.todo,
  );

  final String uuid;
  final User user;
  final DateTime date;
  final String subject;
  final String todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
  Map<String, dynamic> toJson() => _$TodoToJson(this);
}