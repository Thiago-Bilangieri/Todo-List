import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/ui/theme_extensions.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';

class HomeWeekFilter extends StatelessWidget {
  const HomeWeekFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          "DIA DA SEMANA",
          style: context.titleStyle,
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          height: 95,
          child: Selector<HomeController, DateTime>(
            selector: (_, controller) {
              return DateTime.now()
                  .subtract(Duration(days: DateTime.now().weekday - 1));

              // return controller.initialDateOfWeek ?? DateTime.now();

              // if (controller.initialDateOfWeek != null) {
              //   return controller.initialDateOfWeek!;
              // } else {
              //   return DateTime.now();
              // }
            },
            builder: (_, initialDateOfWeek, __) {
              return DatePicker(
                initialDateOfWeek,
                locale: "pt_PT",
                height: 2,
                initialSelectedDate: initialDateOfWeek,
                selectionColor: context.primaryColor,
                selectedTextColor: Colors.white,
                daysCount: 7,
                dayTextStyle: const TextStyle(fontSize: 8.2),
                monthTextStyle: const TextStyle(fontSize: 12),
                dateTextStyle: const TextStyle(fontSize: 30),
                onDateChange: (selectedDate) =>
                    context.read<HomeController>().filterByDay(selectedDate),
              );
            },
          ),
        )
      ],
    );
  }
}
