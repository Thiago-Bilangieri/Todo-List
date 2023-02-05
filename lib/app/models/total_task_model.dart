class TotalTaskModel {
  final int totalTasks;
  final int totalTasksFinish;

  TotalTaskModel({required this.totalTasks, required this.totalTasksFinish});

  double get percentFinish =>
      totalTasksFinish > 0 ? totalTasksFinish / totalTasks : 0.0;
}
