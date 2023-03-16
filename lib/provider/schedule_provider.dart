import 'package:flutter/material.dart';
import 'package:flutter_factory_calendar_scheduler/models/schedule_model.dart';
import 'package:flutter_factory_calendar_scheduler/repository/schedule_repository.dart';

class ScheduleProvider extends ChangeNotifier {
  final ScheduleRepository repository;

  ScheduleProvider({
    required this.repository,
  }) : super() {
    getSchedules(date: selectedDate);
  }

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  void getSchedules({required DateTime date}) async {
    final resp = await repository.getSchedules(date: date);
    cache.update(date, (value) => resp, ifAbsent: () => resp);

    notifyListeners();
  }

  void createSchedule({required ScheduleModel schedule}) async {
    final targetDate = schedule.date;
    final savedSchedule = await repository.createSchedule(schedule: schedule);

    cache.update(
      targetDate,
      (value) => [
        ...value,
        schedule.copyWith(
          id: savedSchedule,
        ),
      ]..sort(
          (a, b) => a.startTime.compareTo(
            b.startTime,
          ),
        ),
      ifAbsent: () => [schedule],
    );
    notifyListeners();
  }

  void deleteSchedule({
    required DateTime date,
    required String id,
  }) async {
    final resp = await repository.deleteSchedule(id: id);

    cache.update(
      date,
      (value) => value.where((e) => e.id != id).toList(),
      ifAbsent: () => [],
    );

    notifyListeners();
  }

  void changeSelectedDate({
    required DateTime date,
  }) {
    selectedDate = date;
    notifyListeners();
  }

  Map<DateTime, List<ScheduleModel>> cache = {};
}
