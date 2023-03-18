import 'package:flutter/material.dart';
import 'package:flutter_factory_calendar_scheduler/components/main_calendar.dart';
import 'package:flutter_factory_calendar_scheduler/components/schedule_bottom_sheet.dart';
import 'package:flutter_factory_calendar_scheduler/components/schedule_card.dart';
import 'package:flutter_factory_calendar_scheduler/components/today_banner.dart';
import 'package:flutter_factory_calendar_scheduler/consts/colors.dart';
import 'package:flutter_factory_calendar_scheduler/database/drift_database.dart';
import 'package:flutter_factory_calendar_scheduler/provider/schedule_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

//이 git버전은 18장 일정관리앱에서 drift를 대신 서버와 REST API 으로 일정을 연동함

class HomeScreen extends StatelessWidget {
  final DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  @override
  Widget build(BuildContext context) {
    // final provider = context.watch<ScheduleProvider>();
    final provider = Provider.of<ScheduleProvider>(context, listen: true);
    final selectedDate = provider.selectedDate;
    final schedules = provider.cache[selectedDate] ?? [];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isDismissible: true,
            builder: (_) => ScheduleBottomSheet(
              selectedDate: selectedDate,
            ),
            isScrollControlled: true,
          );
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            MainCalendar(
              selectedDate: selectedDate,
              onDaySelected: (selectedDate, focusedDate) =>
                  onDaySelected(selectedDate, focusedDate, context),
            ),
            SizedBox(height: 8.0),
            // StreamBuilder<List<Schedule>>(
            //   stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
            //   builder: (context, snapshot) {
            //     return TodayBanner(
            //       selectedDate: selectedDate,
            //       count: snapshot.data?.length ?? 0,
            //     );
            //   },
            // ),
            TodayBanner(
              selectedDate: selectedDate,
              count: schedules.length,
            ),
            Expanded(
              // child: StreamBuilder<List<Schedule>>(
              //   stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
              //   builder: (context, snapshot) {
              //     if (!snapshot.hasData) {
              //       return Container();
              //     }
              child: ListView.builder(
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  final schedule = schedules[index];
                  return Dismissible(
                    key: ObjectKey(schedule.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (DismissDirection direction) {
                      // GetIt.I<LocalDatabase>().removeSchedule(schedule.id);
                      provider.deleteSchedule(
                          date: selectedDate, id: schedule.id);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8.0, left: 8.0, right: 8.0),
                      child: ScheduleCard(
                        startTime: schedule.startTime,
                        endTime: schedule.endTime,
                        content: schedule.content,
                      ),
                    ),
                  );
                },
              ),
              // }),
            ),
          ],
        ),
      ),
    );
  }

  void onDaySelected(
    DateTime selectedDate,
    DateTime focusedDate,
    BuildContext context,
  ) {
    final provider = context.read<ScheduleProvider>();
    provider.changeSelectedDate(date: selectedDate);
    provider.getSchedules(date: selectedDate);
  }
}
