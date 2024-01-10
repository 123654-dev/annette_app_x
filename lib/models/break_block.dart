import 'package:annette_app_x/models/timetable_unit.dart';

class BreakBlock extends TimetableUnit {
  final String? name;

  BreakBlock({required super.startTime, required super.endTime, this.name});
}
