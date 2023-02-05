import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/ui/theme_extensions.dart';
import 'package:todo_list/app/models/task_filter_enum.dart';
import 'package:todo_list/app/models/total_task_model.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';
import 'package:todo_list/app/modules/home/widget/todo_card_filter.dart';

class HomeFilter extends StatelessWidget {
  const HomeFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "FILTROS",
          style: context.titleStyle,
        ),
        const SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              TodoCardFilter(
                selected: context.select<HomeController, TaskFilterEnum>(
                        (value) => value.filterSelected) ==
                    TaskFilterEnum.today,
                label: "Hoje",
                taskFilterEnum: TaskFilterEnum.today,
                totalTaskModel: context.select<HomeController, TotalTaskModel?>(
                    (controller) => controller.todayTotalTasks),
              ),
              TodoCardFilter(
                selected: context.select<HomeController, TaskFilterEnum>(
                        (value) => value.filterSelected) ==
                    TaskFilterEnum.tomorrow,
                label: "Amanhã",
                taskFilterEnum: TaskFilterEnum.tomorrow,
                totalTaskModel: context.select<HomeController, TotalTaskModel?>(
                    (controller) => controller.tomorrowTotalTasks),
              ),
              TodoCardFilter(
                selected: context.select<HomeController, TaskFilterEnum>(
                        (value) => value.filterSelected) ==
                    TaskFilterEnum.week,
                label: "Semana",
                taskFilterEnum: TaskFilterEnum.week,
                totalTaskModel: context.select<HomeController, TotalTaskModel?>(
                    (controller) => controller.weekTotalTasks),
              ),
            ],
          ),
        )
      ],
    );
  }
}
