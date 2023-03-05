import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_memo/ui/pages/todo.page.dart';

import '../../models/todo.model.dart';
import '../../models/user.model.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key, required this.me, required this.todos, required this.selectedTodos});

  final User me;
  final List<Todo> todos;
  final List<Todo> selectedTodos;

  final String title = 'Todo List';

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {

  late User me;
  late List<Todo> todos;
  late List<Todo> selectedTodos;

  @override
  void initState() {
    me = widget.me;
    todos = widget.todos;
    selectedTodos = widget.selectedTodos;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Expanded(
                  child: Text('Name', style: TextStyle(fontStyle: FontStyle.italic))
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text('Date', style: TextStyle(fontStyle: FontStyle.italic))
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text('Subject', style: TextStyle(fontStyle: FontStyle.italic)),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text('Todo', style: TextStyle(fontStyle: FontStyle.italic)),
                ),
              ),
            ],
            rows: toDataTableDatasource(selectedTodos),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: onCloseTodoList,
            child: Text(
              'Close',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary),
            ),
          ),
        ],
      ),
    );
  }

  List<DataRow> toDataTableDatasource(List<Todo> todos) {
    return todos.map((e) => DataRow(
      onSelectChanged: (bool? selected) {
        if (selected!) {
          gotoTodoDetailPage(e);
          debugPrint('row-selected: ${e.user.name.toString()}');
        }
      },
      cells: <DataCell>[
        DataCell(Text(e.user.name)),
        DataCell(Text(DateFormat('yyyy/MM/dd').format(e.date))),
        DataCell(Text(e.subject)),
        DataCell(Text(e.todo)),
      ],
    )).toList();
  }

  Future<void> gotoTodoDetailPage(Todo todo) async {
    Map<String, dynamic>? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TodoPage(
        me: me,
        todo: todo,
      )),
    );

    if(result == null) return;

    // TODO : question
    // result format = {todo: Todo, action: DELETE | MODIFY}
    // action이 DELETE인 경우 todos에서 uuid가 같은 item 삭제
    // action이 UPDATE인 경우 todos에서 uuid가 같은 item 교체
    setState(() {
      if(result['action'] == 'DELETE') {
        selectedTodos.removeWhere((todo) => todo.uuid == result['todo'].uuid);
        todos.removeWhere((todo) => todo.uuid == result['todo'].uuid);
      } else if(result['action'] == 'MODIFY') {
        var index = todos.indexWhere((todo) => todo.uuid == result['todo'].uuid);
        todos[index] = result['todo'];

        var selectedTodoIndex = selectedTodos.indexWhere((todo) => todo.uuid == result['todo'].uuid);
        selectedTodos[selectedTodoIndex] = result['todo'];
      }
    });
    // TODO END
  }

  void onCloseTodoList() {
    Navigator.pop( context );
  }
}