import 'dart:convert';

import 'package:annette_app_x/providers/user_settings.dart';
import 'package:hive/hive.dart';

import 'api/api_provider.dart';

class TimetableProvider {
  static String getCurrentSubjectAsString() {
    String name = "Kein Unterricht";
    var today = getTableForDay(DateTime.now().weekday);
    if (today == null || today.isEmpty) return name;
    today.forEach((element) {
      if (element["startTime"] != null) {
        var startTime = int.parse(element["startTime"].toString());
        var endTime = int.parse(element["endTime"].toString());
        if (startTime <= DateTime.now().hour &&
            DateTime.now().hour <= endTime) {
          name = element["name"];
        }
      }
    });
    return name;
  }

  ///Returns all lessons of the next schoolday
  static List<dynamic>? getTableForNextSchoolday() {
    return getTableForDay(_nextSchoolday());
  }

  static List<dynamic>? getTableForDay(int day) {
    return Hive.box("timetable").get(day);
  }

  ///0: Sunday, 1: Monday, 2: Tuesday, 3: Wednesday, 4: Thursday, 5: Friday, 6: Saturday
  ///
  ///Returns the next schoolday if it's a weekend
  static int _nextSchoolday() {
    var day = DateTime.now().weekday;
    if (day <= 5) {
      return day;
    } else {
      return 1; //0: Sunday, 1: Monday
    }
  }

  static Future<List<dynamic>> getTimetable() async {
    final isTimetableExpired = Hive.box('timetable').get("lastUpdate") ==
            null ||
        ((Hive.box("timetable").get("lastUpdate") ?? DateTime(0)) as DateTime)
            .isBefore(DateTime.now().subtract(const Duration(days: 7)));

    final classIdChanged =
        Hive.box('timetable').get("classId") != UserSettings.classIdString;

    if (classIdChanged || isTimetableExpired) {
      await _processTimetable();
      Hive.box('timetable').put("lastUpdate", DateTime.now());
      // ignore: dead_code
    } else {
      print("Timetable is up to date");
    }
    print("Next schoolday: ${Hive.box('timetable').get(_nextSchoolday())}");
    return Hive.box('timetable').get(_nextSchoolday());
  }

  static Future<void> _processTimetable() async {
    var timetableBox = Hive.box('timetable');

    var timetableString =
        await ApiProvider.fetchTimetable(UserSettings.classIdString);

    var timetable = jsonDecode(timetableString);

    const daysPerWeek = 5;

    for (int i = 0; i < daysPerWeek; i++) {
      List<dynamic> day = [];
      List<dynamic> deleteBeforeNextPass = [];

      /**
       * Anmerkung: Unbedingt internal_id und nicht name vergleichen,
       * da sich die Namen von manchen Kursen überschneiden! WebUntis ist manchmal
       * sehr inkonsistent.
       */

      for (var t in timetable) {
        if (t["weekday"] == i && t["startTime"] != null) {
          if (UserSettings.subjects.firstWhere(
                  (element) =>
                      t["lessonid"] == element["lessons"]?[0]["internal_id"] ||
                      t["lessonid"] == element["internal_id"],
                  orElse: () => null) !=
              null) {
            day.add(t);
          }
          deleteBeforeNextPass.add(t);
        }
      }

      for (var t in deleteBeforeNextPass) {
        timetable.remove(t);
      }

      print(day);

      day.sort((a, b) => a["startTime"].compareTo(b["startTime"]));
      timetableBox.put(i, day);
    }
    timetableBox.put("classId", UserSettings.classIdString);
  }
}
