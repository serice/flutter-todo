import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:my_memo/models/todo.model.dart';

import '../../../providers/getx/auth.controller.dart';
import '../../../providers/getx/todo.controller.dart';

class GetXTodoPage extends StatefulWidget {
  const GetXTodoPage({super.key});

  @override
  State<GetXTodoPage> createState() => _GetXTodoPageState();
}

class _GetXTodoPageState extends State<GetXTodoPage> {

  final TodoController todoController = TodoController.to;
  final AuthController authController = AuthController.to;
  final DateTime now = DateTime.now();

  late Todo? todo;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _subjectHasError = false;
  bool _todoHasError = false;

  @override
  void initState() {
    todo = Get.arguments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(todo != null ? '${todo!.user.name} Todo 수정 하기' : '${authController.me.value.name} Todo 만들기'),
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
                    'name': todo != null ? todo!.user.name : authController.me.value.name,
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
    if(todo == null) {
      todoController.addTodo(
        date: value['date'],
        subject: value['subject'],
        todo: value['todo'],
      );
    } else {
      todoController.updateTodo(todo!.uuid, date: value['date'],
        subject: value['subject'],
        todo: value['todo'],
      );
    }
    Get.back();
  }

  void onDeleteTodo() {
    todoController.deleteTodo(todo!.uuid);
    Get.back();
  }

  void onCloseTodo() {
    Get.back();
  }
}
