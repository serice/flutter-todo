import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_memo/providers/getx/auth.controller.dart';
import 'package:my_memo/providers/getx/todo.controller.dart';
import 'package:my_memo/ui/pages/getx/calendar.page.dart';
import 'package:my_memo/ui/pages/getx/profile.page.dart';
import 'package:my_memo/ui/pages/getx/todo.page.dart';
import 'package:my_memo/ui/pages/getx/todo_list.page.dart';

import './ui/pages/calendar.page.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  TodoApp({super.key});

  final AuthController authController =
  Get.put<AuthController>(AuthController());

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Todo',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: const CalendarPage(),
    //   // initialRoute: '/calendar',
    //   // routes: {
    //   //   '/calendar': (BuildContext context) => const CalendarPage(),
    //   //   '/profile': (BuildContext context) => const ProfilePage(me: me),
    //   // },
    // );

    // return GetMaterialApp(
    //   title: 'Todo',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   initialRoute: '/calendar',
    //   getPages: [
    //     GetPage(name: '/calendar', page: () => GetXCalendarPage()),
    //     GetPage(name: '/profile', page: () => const GetXProfilePage()),
    //     GetPage(name: '/todo-list', page: () => const GetXTodoListPage()),
    //     GetPage(name: '/todo', page: () => const GetXTodoPage()),
    //   ],
    // );

    return GetMaterialApp(
      title: 'Todo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/calendar',
      getPages: [
        GetPage(name: '/calendar', page: () => GetXCalendarPage()),
        GetPage(name: '/profile', page: () => const GetXProfilePage()),
        GetPage(name: '/todo-list', page: () => const GetXTodoListPage()),
        GetPage(name: '/todo', page: () => const GetXTodoPage()),
      ],
    );
  }
}