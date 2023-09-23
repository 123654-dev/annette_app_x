import 'dart:convert';

import 'package:annette_app_x/providers/user_settings.dart';
import 'package:hive/hive.dart';

import 'api/api_provider.dart';

class TimetableProvider {
  static String getCurrentSubjectAsString() {
    return "Bubatz";
  }

  //Returns the next day within Mon-Fri range
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
    // ignore: dead_code
    if (true ||
        Hive.box('timetable').get("classId") != UserSettings.classIdString) {
      await _processTimetable();
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
          print("Subjects: ${UserSettings.subjects}");
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
