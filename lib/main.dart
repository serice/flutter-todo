import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:my_memo/providers/getx/auth.controller.dart';
import 'package:my_memo/providers/getx/todo.controller.dart';
import 'package:my_memo/providers/provider/auth.provider.dart';
import 'package:my_memo/providers/provider/todo.provider.dart';
import 'package:my_memo/ui/pages/getx/calendar.page.dart';
import 'package:my_memo/ui/pages/getx/profile.page.dart';
import 'package:my_memo/ui/pages/getx/todo.page.dart';
import 'package:my_memo/ui/pages/getx/todo_list.page.dart';
import 'package:my_memo/ui/pages/provider/calendar.page.dart';
import 'package:my_memo/ui/pages/provider/profile.page.dart';
import 'package:my_memo/ui/pages/provider/todo.page.dart';
import 'package:my_memo/ui/pages/provider/todo_list.page.dart';
import 'package:provider/provider.dart';

import './ui/pages/calendar.page.dart';
import 'models/todo.model.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  TodoApp({super.key});

  final AuthController authController =
  Get.put<AuthController>(AuthController());

  @override
  Widget build(BuildContext context) {
    /*
    return MaterialApp(
      title: 'Todo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalendarPage(),
      // initialRoute: '/calendar',
      // routes: {
      //   '/calendar': (BuildContext context) => const CalendarPage(),
      //   '/profile': (BuildContext context) => const ProfilePage(me: me),
      // },
    );
    */

    /*
    // return GetMaterialApp(
    //   title: 'Todo',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   initialRoute: '/calendar',
    //   getPages: [
    //     GetPage(name: '/calendar', page: () => GetXCalendarPage(),
    //       binding: BindingsBuilder(() {
    //         Get.lazyPut(() => TodoController());
    //       }),
    //     ),
    //     GetPage(name: '/profile', page: () => const GetXProfilePage(),
    //       binding: BindingsBuilder(() {
    //         Get.lazyPut(() => AuthController());
    //       }),
    //     ),
    //     GetPage(name: '/todo-list', page: () => const GetXTodoListPage(),
    //       binding: BindingsBuilder(() {
    //         Get.lazyPut(() => TodoController());
    //       }),
    //     ),
    //     GetPage(name: '/todo', page: () => const GetXTodoPage(),
    //       binding: BindingsBuilder(() {
    //         Get.lazyPut(() => AuthController());
    //         Get.lazyPut(() => TodoController());
    //       }),
    //     ),
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
    */

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TodoProvider()),
      ],
      child: Builder(
        builder: (context) {
          context.read<AuthProvider>().init();
          context.read<TodoProvider>().init(context);

          return MaterialApp.router(
            title: 'Todo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            routerConfig: GoRouter(
              routes: <RouteBase>[
                GoRoute(
                  path: '/',
                  builder: (BuildContext context, GoRouterState state) {
                    return const ProviderCalendarPage();
                  },
                  routes: <RouteBase>[
                    GoRoute(
                      path: 'profile',
                      builder: (BuildContext context, GoRouterState state) {
                        return const ProviderProfilePage();
                      },
                    ),
                    GoRoute(
                      path: 'todo-list',
                      builder: (BuildContext context, GoRouterState state) {
                        return const ProviderTodoListPage();
                      },
                    ),
                    GoRoute(
                      path: 'todo',
                      builder: (BuildContext context, GoRouterState state) {
                        Todo? todo = state.extra != null? state.extra as Todo: null;
                        return ProviderTodoPage(todo: todo);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}