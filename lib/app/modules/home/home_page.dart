import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/notifier/default_listener_notifier.dart';
import 'package:todo_list/app/core/ui/theme_extensions.dart';
import 'package:todo_list/app/core/ui/todo_list_icons.dart';
import 'package:todo_list/app/models/task_filter_enum.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';
import 'package:todo_list/app/modules/home/widget/home_drawer.dart';
import 'package:todo_list/app/modules/home/widget/home_filter.dart';
import 'package:todo_list/app/modules/home/widget/home_header.dart';
import 'package:todo_list/app/modules/home/widget/home_task.dart';
import 'package:todo_list/app/modules/home/widget/home_week_filter.dart';
import 'package:todo_list/app/modules/tasks/tasks_module.dart';

class HomePage extends StatefulWidget {
  final HomeController _homeController;
  const HomePage({Key? key, required HomeController homeController})
      : _homeController = homeController,
        super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    DefaultListenerNotifier(changeNotifier: widget._homeController).listener(
      context: context,
      successCallback: (notifier, listener) {
        listener.dispose();
      },
    );
    widget._homeController.loadTotalTask();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget._homeController.loadTotalTask();
      widget._homeController.findTask(filter: TaskFilterEnum.today);
    });
  }

  Future<void> _goToCreateTask(BuildContext context) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation =
              CurvedAnimation(parent: animation, curve: Curves.decelerate);
          return ScaleTransition(
            scale: animation,
            alignment: Alignment.bottomRight,
            child: child,
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          return TasksModule().getPage(
            "/task/create",
            context,
          );
        },
      ),
    );
    widget._homeController.refreshPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: context.primaryColor),
        backgroundColor: const Color(0XFFFAFBFE),
        elevation: 0,
        actions: [
          PopupMenuButton(
            onSelected: (value) =>
                widget._homeController.showOrHideFinishingTask(),
            icon: const Icon(TodoListIcons.filter),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: true,
                child: Text(
                    "${widget._homeController.showFinishingTasks ? "Esconder" : "Mostrar"} Tarefas Concluidas!"),
              ),
            ],
          )
        ],
      ),
      backgroundColor: const Color(0XFFFAFBFE),
      drawer: HomeDrawer(),
      body: LayoutBuilder(
        builder: (context, constrains) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constrains.minHeight,
                minWidth: constrains.minWidth,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HomeHeader(),
                      const HomeFilter(),
                      Visibility(
                        visible: context.select<HomeController, bool>((value) =>
                            value.filterSelected == TaskFilterEnum.week),
                        child: const HomeWeekFilter(),
                      ),
                      const HomeTask(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _goToCreateTask(context),
        backgroundColor: context.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}



// 10;00