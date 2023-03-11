import 'package:flutter/material.dart';
import 'package:flutter_factory_calendar_scheduler/consts/colors.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.content,
  });

  final int startTime;
  final int endTime;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: PRIMARY_COLOR,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Time(
                startTime: startTime,
                endTime: endTime,
              ),
              SizedBox(width: 16.0),
              _Content(
                content: content,
              ),
              SizedBox(width: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}

class _Time extends StatelessWidget {
  _Time({
    required this.startTime,
    required this.endTime,
  });

  final int startTime;
  final int endTime;

  final textStyle = TextStyle(
    fontWeight: FontWeight.w600,
    color: PRIMARY_COLOR,
    fontSize: 16.0,
  );
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${startTime.toString().padLeft(2, '0')}:00',
          style: textStyle,
        ),
        Text(
          '${endTime.toString().padLeft(2, '0')}:00',
          style: textStyle.copyWith(
            fontSize: 10.0,
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.content,
  });
  final String content;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(content),
    );
  }
}
