import 'package:annette_app_x/models/timetable_unit.dart';

class LessonBlock extends TimetableUnit {
  final String subject;
  final String room;

  LessonBlock(
      {required super.startTime,
      required super.endTime,
      required this.subject,
      required this.room});
}
