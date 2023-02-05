import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo_list/app/core/database/sqlite_adm_connection.dart';
import 'package:todo_list/app/core/navigator/todo_list_navigator.dart';
import 'package:todo_list/app/core/ui/todo_list_ui_config.dart';
import 'package:todo_list/app/modules/auth/auth_module.dart';
import 'package:todo_list/app/modules/home/home_module.dart';
import 'package:todo_list/app/modules/splash/splash_page.dart';
import 'package:todo_list/app/modules/tasks/tasks_module.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

final connection = SqliteAdmConnection();

class _AppWidgetState extends State<AppWidget> {
  @override
  void initState() {
    FirebaseAuth auth = FirebaseAuth.instance;
    WidgetsBinding.instance.addObserver(connection);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(connection);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Todo List",
      theme: TodoListUiConfig.theme,
      navigatorKey: TodoListNavigator.navigatorKey,
      // initialRoute: "/login",
      localizationsDelegates: GlobalMaterialLocalizations.delegates,

      supportedLocales: const [Locale("pt", "PT")],
      routes: {
        ...AuthModule().routers,
        ...HomeModule().routers,
        ...TasksModule().routers,
      },
      home: const SplashPage(),
    );
  }
}


// 22Minutos