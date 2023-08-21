import 'dart:convert';

import 'package:annette_app_x/providers/user_settings.dart';
import 'package:hive/hive.dart';

import 'api/api_provider.dart';

class TimetableProvider {
  static String getCurrentSubjectAsString() {
    return "Bubatz";
  }

  //Returns the next day within Mon-Fri range
  static int _nextSchoolday() {
    var day = DateTime.now().weekday;
    if (day < 5) {
      return day;
    } else {
      return 0;
    }
  }

  static Future<List<dynamic>> getTimetable() async {
    if (true ||
        Hive.box('timetable').get("classId") != UserSettings.classIdString) {
      await _processTimetable();
    } else {
      print("Timetable is up to date");
    }
    print(Hive.box('timetable').get(_nextSchoolday()));
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
                      t["internal_id"] == element["lessons"]?[0]["internal_id"],
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

      day.sort((a, b) => a["startTime"].compareTo(b["startTime"]));
      timetableBox.put(i, day);
    }
    timetableBox.put("classId", UserSettings.classIdString);

    print(timetable);
  }
}
