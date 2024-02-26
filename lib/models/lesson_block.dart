import 'package:annette_app_x/models/timetable_unit.dart';
import 'package:flutter/material.dart';

class LessonBlock extends TimetableUnit {
  final String subject;
  final String? room;
  final int lessonIndex;

  LessonBlock(
      {required super.startTime,
      required super.endTime,
      required this.subject,
      this.room,
      required this.lessonIndex});

  static LessonBlock fromJson(t) {
    var startTime = t["startTime"].toString();
    var endTime = t["endTime"].toString();

    startTime =
        "${startTime.substring(0, startTime.length - 2)}:${startTime.substring(startTime.length - 2)}";
    endTime =
        "${endTime.substring(0, endTime.length - 2)}:${endTime.substring(endTime.length - 2)}";

    return LessonBlock(
        subject: t["longname"],
        room: t["room"],
        lessonIndex: _inferLessonIndexFromTime(startTime.replaceFirst(":", "")),
        startTime: TimeOfDay(
            hour: int.parse(startTime.split(":")[0]),
            minute: int.parse(startTime.split(":")[1])),
        endTime: TimeOfDay(
            hour: int.parse(endTime.split(":")[0]),
            minute: int.parse(endTime.split(":")[1])));
  }
}

int _inferLessonIndexFromTime(String startTime) {
  Map<String, int> lessonIndexMap = {
    "800": 1,
    "850": 2,
    "955": 3,
    "1045": 4,
    "1150": 5,
    "1240": 6,
    "1335": 7,
    "1430": 8,
    "1520": 9,
    "1610": 10,
    "1700": 11,
  };

  return lessonIndexMap[startTime] ?? 0;
}
