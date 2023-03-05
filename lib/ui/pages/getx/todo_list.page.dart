import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../models/todo.model.dart';
import '../../../providers/getx/todo.controller.dart';

class GetXTodoListPage extends StatelessWidget {
  const GetXTodoListPage({super.key});

  final String title = 'Todo List';

  @override
  Widget build(BuildContext context) {
    final TodoController todoController = TodoController.to;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          Obx(() => DataTable(
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
            rows: toDataTableDatasource(todoController.selectedTodos),
          )),
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

  List<DataRow> toDataTableDatasource(RxList<Todo> todos) {
    return todos.toList().map((e) => DataRow(
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

  void gotoTodoDetailPage(Todo todo) async {
    Get.toNamed('/todo', arguments: todo);
  }

  void onCloseTodoList() {
    Get.back();
  }
}