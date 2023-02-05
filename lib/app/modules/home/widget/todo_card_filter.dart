import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/ui/theme_extensions.dart';
import 'package:todo_list/app/models/task_filter_enum.dart';
import 'package:todo_list/app/models/total_task_model.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';

class TodoCardFilter extends StatelessWidget {
  final String label;
  final TaskFilterEnum taskFilterEnum;
  final TotalTaskModel? totalTaskModel;
  final bool selected;
  const TodoCardFilter({
    Key? key,
    required this.label,
    required this.selected,
    required this.taskFilterEnum,
    this.totalTaskModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        // context.read<HomeController>().filterSelected = taskFilterEnum;
        context.read<HomeController>().findTask(filter: taskFilterEnum);
      },
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 120,
          maxWidth: 150,
        ),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selected ? context.primaryColor : Colors.white,
          border: Border.all(
            width: 1,
            color: Colors.grey.withOpacity(0.8),
          ),
          borderRadius: BorderRadius.circular(
            30,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${totalTaskModel?.totalTasks ?? 0} Tasks",
              style: context.titleStyle.copyWith(
                fontSize: 10,
                color: selected ? Colors.white : Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 8),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.white : Colors.black,
                ),
              ),
            ),
            TweenAnimationBuilder<double>(
              tween:
                  Tween(begin: 0.0, end: totalTaskModel?.percentFinish ?? 0.0),
              duration: const Duration(seconds: 1),
              builder: (context, value, child) => LinearProgressIndicator(
                backgroundColor:
                    selected ? context.primaryColorLight : Colors.grey[300],
                value: value,
                valueColor: AlwaysStoppedAnimation<Color>(
                    selected ? Colors.white : context.primaryColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
