import 'package:annette_app_x/widgets/timetable/timetable_day.dart';
import 'package:annette_app_x/widgets/timetable/timetable_time_slots.dart';
import 'package:annette_app_x/widgets/timetable/timetable_week_all.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TimetableType {
  current,
  all,
  timeSlots,
}

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});
  @override
  State<StatefulWidget> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  bool showWebView = false;
  TimetableType timetableType = TimetableType.current;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      buttonRow(),
      timetableWidget(timetableType),
    ]);
  }

  Widget buttonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CupertinoSlidingSegmentedControl(
            children: {
              0: Container(
                child: Text('Aktuell'),
                padding: EdgeInsets.symmetric(horizontal: 25),
              ),
              1: Container(
                child: Text('Gesamt'),
                padding: EdgeInsets.symmetric(horizontal: 25),
              ),
              2: Container(
                child: Text('Zeitplan'),
                padding: EdgeInsets.symmetric(horizontal: 25),
              ),
            },
            onValueChanged: (int? value) {
              setState(() {
                timetableType = getTimetableType(value!);
              });
            }),
      ],
    );
  }

  TimetableType getTimetableType(int index) {
    switch (index) {
      case 0:
        return TimetableType.current;
      case 1:
        return TimetableType.all;
      case 2:
        return TimetableType.timeSlots;
      default:
        return TimetableType.current;
    }
  }

  Widget timetableWidget(TimetableType type) {
    switch (type) {
      case TimetableType.current:
        return const TimetableDay();
      case TimetableType.all:
        return const TimetableWeekAll();
      case TimetableType.timeSlots:
        return const TimetableTimeSlots();
      default:
        return const TimetableDay();
    }
  }
}
