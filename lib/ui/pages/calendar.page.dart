import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_memo/ui/pages/profile.page.dart';
import 'package:my_memo/ui/pages/todo.page.dart';
import 'package:my_memo/ui/pages/todo_list.page.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../models/todo.model.dart';
import '../../services/auth.service.dart';
import '../../services/todo.service.dart';
import '../../models/user.model.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  final String title = 'Todo Calendar';

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  final TodoService todoService = TodoService();
  final AuthService authService = AuthService();

  List<Todo> todos = [];
  late User me;

  @override
  void initState() {
    todos.addAll(todoService.getTodos());
    me = authService.me();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          ElevatedButton(
            onPressed: onPressedAppBarProfile,
            child: const Text("Profile"),
          )
        ],
      ),
      body: SfCalendar(
        view: CalendarView.month,
        dataSource: _TodoDataSource(todos),
        monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment
        ),
        onTap: onTapCalendarAppointment
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onPressedFloatingActionButton,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> onPressedAppBarProfile() async {
    User? newMe = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage(
          me: me,
      )),
    );

    if(newMe == null) return;
    // TODO : 꼭 갱신 해줘야 함
    setState(() {
      me = newMe;
    });
    // TODO end
    debugPrint('newMe : ${newMe.toJson()}');
  }

  void onTapCalendarAppointment(CalendarTapDetails details) {
    switch(details.targetElement) {
      // not working on mobile
      case CalendarElement.appointment:
        if(details.appointments!.isNotEmpty && details.appointments != null){
          final todo = details.appointments![0] as Todo;
          log('${todo.user.name} - ${todo.subject}');
          gotoTodoDetailPage(todo);
        }
        break;
      case CalendarElement.calendarCell:
        if(details.appointments!.isNotEmpty && details.appointments != null){
          final todos = details.appointments!.map((e) => e as Todo).toList();
          log(todos.toString());
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
    log(details.targetElement.toString());
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
        todos.removeWhere((todo) => todo.uuid == result['todo'].uuid);
      } else if(result['action'] == 'MODIFY') {
        var index = todos.indexWhere((todo) => todo.uuid == result['todo'].uuid);
        todos[index] = result['todo'];
      }
    });
    // TODO END
  }

  Future<void> gotoTodoListPage(List<Todo> selectedTodos) async {
    // TODO todos, selectedTodos 를 왜 같이 넘겨야 할까?
    Map<String, dynamic>? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TodoListPage(
        me: me,
        todos: todos,
        selectedTodos: selectedTodos,
      )),
    );

    // TODO : question
    setState(() {
    });
    // TODO end
  }

  Future<void> onPressedFloatingActionButton() async {
    Map<String, dynamic>? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TodoPage(
        me: me,
      )),
    );

    if(result == null) return;

    // TODO : question
    // result format = {todo: Todo, action: NEW}
    // todos에 item 추가
    setState(() {
      todos.add(result['todo']);
    });
    // TODO END
    debugPrint('newTodo : ${todos.toString()}');
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
