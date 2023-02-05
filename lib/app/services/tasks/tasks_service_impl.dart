import 'package:todo_list/app/models/task_model.dart';
import 'package:todo_list/app/models/week_tasks_model.dart';
import 'package:todo_list/app/repositories/tasks/tasks_repository.dart';

import 'tasks_service.dart';

class TasksServiceImpl implements TasksService {
  final TasksRepository _tasksRepository;

  TasksServiceImpl({required TasksRepository tasksRepository})
      : _tasksRepository = tasksRepository;
  @override
  Future<void> save(DateTime date, String description) =>
      _tasksRepository.save(date, description);

  @override
  Future<List<TaskModel>> getToday() async {
    return await _tasksRepository.findByPeriod(DateTime.now(), DateTime.now());
  }

  @override
  Future<List<TaskModel>> getTomorrow() async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return await _tasksRepository.findByPeriod(tomorrow, tomorrow);
  }

  @override
  Future<WeekTasksModel> getWeek() async {
    final today = DateTime.now();
    var startfilter = DateTime(today.year, today.month, today.day, 0, 0, 0);
    DateTime endFilter;
    if (startfilter.weekday != DateTime.monday) {
      startfilter =
          startfilter.subtract(Duration(days: startfilter.weekday - 1));
    }
    endFilter = startfilter.add(const Duration(days: 7));
    final tasks = await _tasksRepository.findByPeriod(startfilter, endFilter);
    return WeekTasksModel(
        startDate: startfilter, endDate: endFilter, tasks: tasks);
  }

  @override
  Future<void> checkOrUncheckTask(TaskModel task) =>
      _tasksRepository.checkOrUncheckTask(task);

  @override
  Future<void> delete(TaskModel task) => _tasksRepository.delete(task);
}
