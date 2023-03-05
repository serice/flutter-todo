import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_memo/providers/getx/todo.controller.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../models/todo.model.dart';

class GetXCalendarPage extends StatelessWidget {
  GetXCalendarPage({super.key});

  final String title = 'Todo Calendar';
  final TodoController todoController = Get.put<TodoController>(TodoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          ElevatedButton(
            onPressed: () => Get.toNamed('/profile'),
            child: const Text("Profile"),
          )
        ],
      ),
      body: Obx(()=> SfCalendar(
        view: CalendarView.month,
        dataSource: _TodoDataSource(todoController.todos),
        monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment
        ),
        onTap: onTapCalendarAppointment
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: onPressedFloatingActionButton,
        child: const Icon(Icons.add),
      ),
    );
  }

  void onTapCalendarAppointment(CalendarTapDetails details) {
    switch(details.targetElement) {
      // not working on mobile
      case CalendarElement.appointment:
        if(details.appointments!.isNotEmpty && details.appointments != null){
          final todo = details.appointments![0] as Todo;
          gotoTodoDetailPage(todo);
        }
        break;
      case CalendarElement.calendarCell:
        if(details.appointments!.isNotEmpty && details.appointments != null){
          final todos = details.appointments!.map((e) => e as Todo).toList();
          gotoTodoListPage(todos);
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
  }

  void gotoTodoDetailPage(Todo todo) {
    Get.toNamed('/todo', arguments: todo);
  }

  void gotoTodoListPage(List<Todo> selectedTodos) {
    todoController.setSelectedTodos(selectedTodos);
    Get.toNamed('/todo-list');
  }

  void onPressedFloatingActionButton() {
    Get.toNamed('/todo');
  }
}

// https://pub.dev/documentation/syncfusion_flutter_calendar/latest/calendar/Appointment-class.html
class _TodoDataSource extends CalendarDataSource {
  _TodoDataSource(RxList<Todo> source) {
    appointments = source.toList();
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
