import 'package:todo_list/app/core/notifier/default_change_notifier.dart';
import 'package:todo_list/app/models/task_filter_enum.dart';
import 'package:todo_list/app/models/task_model.dart';
import 'package:todo_list/app/models/total_task_model.dart';
import 'package:todo_list/app/models/week_tasks_model.dart';
import 'package:todo_list/app/services/tasks/tasks_service.dart';

class HomeController extends DefaultChangeNotifier {
  final TasksService _tasksService;
  var filterSelected = TaskFilterEnum.today;
  TotalTaskModel? todayTotalTasks;
  TotalTaskModel? tomorrowTotalTasks;
  TotalTaskModel? weekTotalTasks;
  List<TaskModel> allTask = [];
  List<TaskModel> filteredTask = [];
  DateTime? initialDateOfWeek;
  DateTime? selectedDay;
  bool showFinishingTasks = false;

  HomeController({
    required TasksService tasksService,
  }) : _tasksService = tasksService;

  Future<void> loadTotalTask() async {
    final allTasks = await Future.wait([
      _tasksService.getToday(),
      _tasksService.getTomorrow(),
      _tasksService.getWeek(),
    ]);
    final todayTasks = allTasks[0] as List<TaskModel>;
    final tomorrowTasks = allTasks[1] as List<TaskModel>;
    final weekTasks = allTasks[2] as WeekTasksModel;

    todayTotalTasks = TotalTaskModel(
        totalTasks: todayTasks.length,
        totalTasksFinish:
            todayTasks.where((element) => element.finished).length);

    tomorrowTotalTasks = TotalTaskModel(
        totalTasks: tomorrowTasks.length,
        totalTasksFinish:
            tomorrowTasks.where((element) => element.finished).length);

    weekTotalTasks = TotalTaskModel(
        totalTasks: weekTasks.tasks.length,
        totalTasksFinish:
            weekTasks.tasks.where((element) => element.finished).length);

    notifyListeners();
  }

  void delete(TaskModel task) {
    try {
      _tasksService.delete(task);
      refreshPage();
    } catch (e) {}
  }

  Future<void> findTask({required TaskFilterEnum filter}) async {
    filterSelected = filter;
    showLoading();
    notifyListeners();
    List<TaskModel> tasks;

    switch (filter) {
      case TaskFilterEnum.today:
        tasks = await _tasksService.getToday();
        break;
      case TaskFilterEnum.tomorrow:
        tasks = await _tasksService.getTomorrow();
        break;
      case TaskFilterEnum.week:
        final weekModel = await _tasksService.getWeek();
        initialDateOfWeek = weekModel.startDate;
        tasks = weekModel.tasks;
        break;
    }

    filteredTask = tasks;
    allTask = tasks;

    if (filter == TaskFilterEnum.week) {
      if (selectedDay != null) {
        filterByDay(selectedDay!);
      } else if (initialDateOfWeek != null) {
        filterByDay(initialDateOfWeek!);
      }
    } else {
      selectedDay = null;
    }

    if (!showFinishingTasks) {
      filteredTask =
          filteredTask.where((element) => !element.finished).toList();
    }
    hideLoading();
    notifyListeners();
  }

  void filterByDay(DateTime date) {
    selectedDay = date;
    filteredTask = allTask.where((task) {
      return task.dateTime == date;
    }).toList();
    notifyListeners();
  }

  Future<void> refreshPage() async {
    await findTask(filter: filterSelected);
    await loadTotalTask();
    notifyListeners();
  }

  Future<void> checkOrUncheckTask(TaskModel task) async {
    showLoadingAndResetState();
    notifyListeners();
    final taskUpdate = task.copyWith(finished: !task.finished);
    await _tasksService.checkOrUncheckTask(taskUpdate);
    hideLoading();
    refreshPage();
  }

  void showOrHideFinishingTask() {
    showFinishingTasks = !showFinishingTasks;
    refreshPage();
  }
}
