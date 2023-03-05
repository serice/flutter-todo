import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:my_memo/models/todo.model.dart';
import 'package:my_memo/services/todo.service.dart';

import '../../models/user.model.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key, required this.me, this.todo});

  final User me;
  final Todo? todo;

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {

  final TodoService todoService = TodoService();
  final DateTime now = DateTime.now();

  late User me;
  late Todo? todo;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _subjectHasError = false;
  bool _todoHasError = false;

  @override
  void initState() {
    me = widget.me;
    todo = widget.todo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(todo != null ? '${me.name} Todo 수정 하기' : '${me.name} Todo 만들기'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FormBuilder(
                  key: _formKey,
                  // enabled: false,
                  onChanged: () {
                    _formKey.currentState!.save();
                  },
                  autovalidateMode: AutovalidateMode.always,
                  initialValue: {
                    'name': me.name,
                    'date' : todo != null ? todo?.date : DateTime(now.year, now.month, now.day),
                    'subject' : todo?.subject,
                    'todo' : todo?.todo,
                  },
                  // skipDisabled: true,
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      FormBuilderTextField(
                        readOnly: true,
                        enabled: false,
                        name: 'name',
                        decoration: const InputDecoration(
                          labelText: '이름',
                          suffixIcon: Icon(Icons.check),
                        ),
                        // initialValue: '12',
                        // valueTransformer: (text) => num.tryParse(text),
                      ),
                      FormBuilderDateTimePicker(
                        name: 'date',
                        initialEntryMode: DatePickerEntryMode.calendar,
                        inputType: InputType.date,
                        format: DateFormat('yyyy/MM/dd'),
                        decoration: const InputDecoration(
                          labelText: '날짜',
                          suffixIcon: Icon(Icons.check, color: Colors.green),
                        ),
                      ),
                      FormBuilderTextField(
                        autovalidateMode: AutovalidateMode.always,
                        name: 'subject',
                        decoration: InputDecoration(
                          labelText: '제목',
                          suffixIcon: _subjectHasError
                              ? const Icon(Icons.error, color: Colors.red)
                              : const Icon(Icons.check, color: Colors.green),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _subjectHasError = !(
                                _formKey.currentState?.fields['subject'] ?.validate() ?? false
                            );
                          });
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.maxLength(20),
                        ]),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                      FormBuilderTextField(
                        autovalidateMode: AutovalidateMode.always,
                        name: 'todo',
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: '내용',
                          suffixIcon: _todoHasError
                              ? const Icon(Icons.error, color: Colors.red)
                              : const Icon(Icons.check, color: Colors.green),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _todoHasError = !(
                                _formKey.currentState?.fields['todo'] ?.validate() ?? false
                            );
                          });
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.maxLength(100),
                        ]),
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.next,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.saveAndValidate() ?? false) {
                            debugPrint(_formKey.currentState?.value.toString());
                            onSaveTodo(_formKey.currentState!.value);
                          } else {
                            debugPrint(_formKey.currentState?.value.toString());
                            debugPrint('validation failed');
                          }
                        },
                        child: Text(
                          todo == null ? '추가' : '저장',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    todo != null ? Expanded(
                      child: OutlinedButton(
                        onPressed: onDeleteTodo,
                        child: Text(
                          '삭제',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error),
                        ),
                      ),
                    ) : const SizedBox.shrink(),
                    const SizedBox(width: 20),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onCloseTodo,
                        child: Text(
                          'Close',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }

  void onSaveTodo(Map<String, dynamic> value) {
    Todo newTodo = todoService.addTodo(Todo(
      todo == null ? const Uuid().v4() : todo!.uuid,
      me,
      value['date'],
      value['subject'],
      value['todo'],
    ));
    // TODO : 갱신을 위해 돌려 줘야 함
    Navigator.pop( context, { 'todo': newTodo, 'action': todo == null ? 'NEW' : 'MODIFY'} );
  }

  void onDeleteTodo() {
    // TODO : 갱신을 위해 돌려 줘야 함
    Navigator.pop( context, { 'todo': todo, 'action': 'DELETE'} );
  }

  void onCloseTodo() {
    // TODO : 갱신을 위해 돌려 줘야 함
    Navigator.pop( context );
  }
}