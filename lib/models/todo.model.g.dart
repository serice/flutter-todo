// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) => Todo(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      date: DateTime.parse(json['date'] as String),
      subject: json['subject'] as String,
      todo: json['todo'] as String,
      uuid: json['uuid'] as String?,
    );

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'user': instance.user,
      'date': instance.date.toIso8601String(),
      'subject': instance.subject,
      'todo': instance.todo,
    };
