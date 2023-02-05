import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/ui/theme_extensions.dart';
import 'package:todo_list/app/models/task_filter_enum.dart';
import 'package:todo_list/app/models/task_model.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';
import 'package:todo_list/app/modules/home/widget/task.dart';

class HomeTask extends StatelessWidget {
  const HomeTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Selector<HomeController, String>(
            selector: (context, controller) =>
                controller.filterSelected.description,
            builder: (context, value, child) => Text(
              "TASK'S DE $value",
              style: context.titleStyle,
            ),
          ),
          Selector<HomeController, List<TaskModel>>(
              selector: (context, controller) => controller.filteredTask,
              builder: (context, value, child) {
                return Column(
                  children: context
                      .select<HomeController, List<TaskModel>>(
                          (value) => value.filteredTask)
                      .map(
                        (task) => Task(
                          taskModel: task,
                        ),
                      )
                      .toList(),
                );
              })
        ],
      ),
    );
  }
}
