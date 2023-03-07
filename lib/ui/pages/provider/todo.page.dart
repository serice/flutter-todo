import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_memo/models/todo.model.dart';
import 'package:my_memo/providers/provider/auth.provider.dart';
import 'package:my_memo/providers/provider/todo.provider.dart';
import 'package:provider/provider.dart';

class ProviderTodoPage extends StatefulWidget {
  const ProviderTodoPage({super.key, this.todo});

  final Todo? todo;

  @override
  State<ProviderTodoPage> createState() => _ProviderTodoPageState();
}

class _ProviderTodoPageState extends State<ProviderTodoPage> {

  final DateTime now = DateTime.now();

  final _formKey = GlobalKey<FormBuilderState>();
  late AuthProvider _authProvider;
  late TodoProvider _todoProvider;
  bool _subjectHasError = false;
  bool _todoHasError = false;

  @override
  Widget build(BuildContext context) {
    _authProvider = context.read<AuthProvider>();
    _todoProvider = context.read<TodoProvider>();
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.todo != null ? '${widget.todo!.user.name} Todo 수정 하기' : '${_authProvider.me.name} Todo 만들기'),
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
                    'name': widget.todo != null ? widget.todo!.user.name : _authProvider.me.name,
                    'date' : widget.todo != null ? widget.todo?.date : DateTime(now.year, now.month, now.day),
                    'subject' : widget.todo?.subject,
                    'todo' : widget.todo?.todo,
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
                            onSaveTodo(context, _formKey.currentState!.value);
                          } else {
                            debugPrint(_formKey.currentState?.value.toString());
                            debugPrint('validation failed');
                          }
                        },
                        child: Text(
                          widget.todo == null ? '추가' : '저장',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    widget.todo != null ? Expanded(
                      child: deleteButtonWidget(context),
                    ) : const SizedBox.shrink(),
                    const SizedBox(width: 20),
                    Expanded(
                      child: closeButtonWidget(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }

  void onSaveTodo(BuildContext context, Map<String, dynamic> value) {
    if(widget.todo == null) {
      _todoProvider.addTodo(
        date: value['date'],
        subject: value['subject'],
        todo: value['todo'],
      );
    } else {
      _todoProvider.updateTodo(widget.todo!.uuid, date: value['date'],
        subject: value['subject'],
        todo: value['todo'],
      );
    }
    context.pop();
  }

  Widget deleteButtonWidget(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        _todoProvider.deleteTodo(widget.todo!.uuid);
        context.pop();
      },
      child: Text(
        '삭제',
        style: TextStyle(
            color: Theme.of(context).colorScheme.error),
      ),
    );
  }

  Widget closeButtonWidget(BuildContext context) {
    return OutlinedButton(
      onPressed: () => context.pop(),
      child: Text(
        'Close',
        style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary),
      ),
    );
  }
}
