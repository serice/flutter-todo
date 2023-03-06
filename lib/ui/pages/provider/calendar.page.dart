import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_memo/ui/pages/todo_list.page.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../models/todo.model.dart';
import '../../../providers/provider/auth.provider.dart';
import '../../../providers/provider/todo.provider.dart';

class ProviderCalendarPage extends StatelessWidget {
  const ProviderCalendarPage({super.key});

  final String title = 'Todo Calendar';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          ElevatedButton(
            onPressed: () => context.go('/profile'),
            child: const Text("Profile"),
          )
        ],
      ),
      body: calendarWidget(context),
      floatingActionButton: floatingActionButtonWidget(context)
    );
  }

  Widget calendarWidget(BuildContext context) {
    // return Consumer<TodoProvider>(
    //   builder: (context, todoProvider, child) =>
    //       SfCalendar(
    //         view: CalendarView.month,
    //         dataSource: _TodoDataSource(todoProvider.todos),
    //         monthViewSettings: const MonthViewSettings(
    //             appointmentDisplayMode: MonthAppointmentDisplayMode.appointment
    //         ),
    //         onTap: (CalendarTapDetails details) {
    //           switch(details.targetElement) {
    //           // not working on mobile
    //             case CalendarElement.appointment:
    //               if(details.appointments!.isNotEmpty && details.appointments != null){
    //                 final todo = details.appointments![0] as Todo;
    //                 gotoTodoDetailPage(context, todo);
    //               }
    //               break;
    //             case CalendarElement.calendarCell:
    //               if(details.appointments!.isNotEmpty && details.appointments != null){
    //                 final todos = details.appointments!.map((e) => e as Todo).toList();
    //                 gotoTodoListPage(context, todos);
    //               }
    //               break;
    //             case CalendarElement.header:
    //             case CalendarElement.viewHeader:
    //             case CalendarElement.agenda:
    //             case CalendarElement.allDayPanel:
    //             case CalendarElement.moreAppointmentRegion:
    //             case CalendarElement.resourceHeader:
    //               break;
    //           }
    //         },
    //       ),
    // );
    var todoProvider = Provider.of<TodoProvider>(context, listen: false);
    return SfCalendar(
      view: CalendarView.month,
      dataSource: _TodoDataSource(todoProvider.todos),
      monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment
      ),
      onTap: (CalendarTapDetails details) {
        switch(details.targetElement) {
        // not working on mobile
          case CalendarElement.appointment:
            if(details.appointments!.isNotEmpty && details.appointments != null){
              final todo = details.appointments![0] as Todo;
              gotoTodoDetailPage(context, todo);
            }
            break;
          case CalendarElement.calendarCell:
            if(details.appointments!.isNotEmpty && details.appointments != null){
              final todos = details.appointments!.map((e) => e as Todo).toList();
              gotoTodoListPage(context, todos);
            }
            break;
          case CalendarElement.header:
          case CalendarElement.viewHeader:
          case CalendarElement.agenda:
          case CalendarElement.allDayPanel:
          case CalendarElement.moreAppointmentRegion:
          case CalendarElement.resourceHeader:
            break;
        }
      },
    );
  }

  void gotoTodoDetailPage(BuildContext context, Todo todo) {
    context.push('/todo', extra: todo);
  }

  void gotoTodoListPage(BuildContext context, List<Todo> selectedTodos) {
    context.read<TodoProvider>().setSelectedTodos(selectedTodos);
    context.push('/todo-list');
  }

  Widget floatingActionButtonWidget(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => context.push('/todo'),
      child: const Icon(Icons.add),
    );
  }
}

// https://pub.dev/documentation/syncfusion_flutter_calendar/latest/calendar/Appointment-class.html
class _TodoDataSource extends CalendarDataSource {
  _TodoDataSource(List<Todo> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getTodoData(index).date;
  }

  @override
  DateTime getEndTime(int index) {
    return _getTodoData(index).date;
  }

  @override
  String getSubject(int index) {
    Todo todo = _getTodoData(index);
    return '${todo.user.name}: ${todo.subject}';
  }

  // @override
  // Color getColor(int index) {
  //   return _getTodoData(index).background;
  // }

  @override
  bool isAllDay(int index) => true;

  Todo _getTodoData(int index) {
    return appointments![index] as Todo;
  }
}
