import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/todo.model.dart';
import '../../../providers/provider/todo.provider.dart';

class ProviderTodoListPage extends StatelessWidget {
  const ProviderTodoListPage({super.key});

  final String title = 'Todo List';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          Consumer<TodoProvider>(
            builder: (context, todoProvider, __) => DataTable(
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
              rows: toDataTableDatasource(context, todoProvider.selectedTodos),
            ),
          ),
          const SizedBox(height: 20),
          closeButtonWidget(context),
        ],
      ),
    );
  }

  List<DataRow> toDataTableDatasource(BuildContext context, List<Todo> todos) {
    return todos.map((todo) => DataRow(
      onSelectChanged: (bool? selected) {
        if (selected!) {
          context.push('/todo', extra: todo);
          debugPrint('row-selected: ${todo.user.name.toString()}');
        }
      },
      cells: <DataCell>[
        DataCell(Text(todo.user.name)),
        DataCell(Text(DateFormat('yyyy/MM/dd').format(todo.date))),
        DataCell(Text(todo.subject)),
        DataCell(Text(todo.todo)),
      ],
    )).toList();
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