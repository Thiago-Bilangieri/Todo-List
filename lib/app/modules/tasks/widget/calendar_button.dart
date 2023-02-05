import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/modules/tasks/task_create_controller.dart';

class CalendarButton extends StatelessWidget {
  CalendarButton({Key? key}) : super(key: key);
  final dateFormat = DateFormat("dd/MM/yyyy");

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () async {
        final DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2022),
          lastDate: DateTime(2025),
        );
        context.read<TaskCreateController>().selectedDate = selectedDate;
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.today, color: Colors.grey),
            const SizedBox(
              width: 10,
            ),
            Selector<TaskCreateController, String>(
              selector: (context, controller)
                  //  =>                  dateFormat.format(controller.selectedDate ?? DateTime.now()),
                  {
                if (controller.selectedDate == null) {
                  return "Selecione uma data";
                }
                var date = controller.selectedDate!;
                return dateFormat.format(date);
              },
              builder: (context, value, child) => Text(value),
            )
          ],
        ),
      ),
    );
  }
}
