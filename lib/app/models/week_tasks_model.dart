// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:todo_list/app/models/task_model.dart';

class WeekTasksModel {
  final DateTime startDate;
  final DateTime endDate;
  final List<TaskModel> tasks;
  WeekTasksModel({
    required this.startDate,
    required this.endDate,
    required this.tasks,
  });
}
