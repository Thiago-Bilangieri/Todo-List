import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/ui/theme_extensions.dart';
import 'package:todo_list/app/models/task_model.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';

class Task extends StatelessWidget {
  final TaskModel taskModel;
  Task({Key? key, required this.taskModel}) : super(key: key);
  final dateFormat = DateFormat("dd/MM/yyyy");

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.grey),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: IntrinsicHeight(
        child: Dismissible(
          resizeDuration: null,
          onDismissed: (direction) {
            context.read<HomeController>().delete(taskModel);
          },
          background: Container(
            padding: const EdgeInsets.only(left: 15),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.red,
            ),
            child: const Icon(Icons.delete_forever_outlined),
          ),
          key: GlobalKey(),
          direction: DismissDirection.startToEnd,
          child: ListTile(
            leading: Checkbox(
              activeColor: context.primaryColor,
              value: taskModel.finished,
              onChanged: (value) =>
                  context.read<HomeController>().checkOrUncheckTask(taskModel),
            ),
            title: Text(
              taskModel.description,
              style: TextStyle(
                  decoration:
                      taskModel.finished ? TextDecoration.lineThrough : null),
            ),
            subtitle: Text(
              dateFormat.format(taskModel.dateTime),
              style: TextStyle(
                  decoration:
                      taskModel.finished ? TextDecoration.lineThrough : null),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(width: 1)),
          ),
        ),
      ),
    );
  }
}
