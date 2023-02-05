enum TaskFilterEnum {
  today,
  tomorrow,
  week;
}

extension TaskFilterDescription on TaskFilterEnum {
  String get description {
    switch (this) {
      case TaskFilterEnum.today:
        return "HOJE";
      case TaskFilterEnum.tomorrow:
        return "AMANHÃ";
      case TaskFilterEnum.week:
        return "SEMANA";
    }
  }
}
