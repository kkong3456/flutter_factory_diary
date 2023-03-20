import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_factory_calendar_scheduler/components/banner_ad_widget.dart';
import 'package:flutter_factory_calendar_scheduler/components/main_calendar.dart';
import 'package:flutter_factory_calendar_scheduler/components/schedule_bottom_sheet.dart';
import 'package:flutter_factory_calendar_scheduler/components/schedule_card.dart';
import 'package:flutter_factory_calendar_scheduler/components/today_banner.dart';
import 'package:flutter_factory_calendar_scheduler/consts/colors.dart';
import 'package:flutter_factory_calendar_scheduler/models/schedule_model.dart';

//이 git버전은 19장 일정관리앱에서 REST API연동대신 파이어스토어 사용 일정을 연동함

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
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
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('schedule')
                  .where('date',
                      isEqualTo:
                          '${selectedDate.year}${selectedDate.month.toString().padLeft(2, '0')}${selectedDate.day.toString().padLeft(2, '0')}')
                  .snapshots(),
              builder: (context, snapshot) {
                log('snapshot is ${snapshot.data?.docs.length}');
                return TodayBanner(
                  selectedDate: selectedDate,
                  count: snapshot.data?.docs.length ?? 0,
                );
              },
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('schedule')
                    .where('date',
                        isEqualTo:
                            '${selectedDate.year}${selectedDate.month.toString().padLeft(2, '0')}${selectedDate.day.toString().padLeft(2, '0')}')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: const Text('일정 정보를 가져오지 못했습니다.'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // log('${selectedDate.year}${selectedDate.month.toString().padLeft(2, '0')}${selectedDate.day}');
                    return Container();
                  }

                  final schedules = snapshot.data!.docs
                      .map((QueryDocumentSnapshot e) => ScheduleModel.fromJson(
                          json: (e.data() as Map<String, dynamic>)))
                      .toList();

                  return ListView.separated(
                    itemCount: schedules.length,
                    separatorBuilder: (context, index) {
                      return BannerAdWidget();
                    },
                    itemBuilder: (context, index) {
                      log('schedules is $schedules');
                      final schedule = schedules[index];
                      return Dismissible(
                        key: ObjectKey(schedule.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (DismissDirection direction) {
                          FirebaseFirestore.instance
                              .collection('schedule')
                              .doc(schedule.id)
                              .delete();
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
                  );
                },
              ),
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
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
