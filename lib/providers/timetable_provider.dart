import 'dart:convert';

import 'package:annette_app_x/models/lesson_block.dart';
import 'package:annette_app_x/providers/user_settings.dart';
import 'package:annette_app_x/screens/timetable_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'api/api_provider.dart';

class TimetableProvider {
  static String getCurrentSubjectAsString() {
    String name = "Kein Unterricht";
    var today = getTableForDay(DateTime.now().weekday);
    if (today == null || today.isEmpty) return name;
    for (var element in today) {
      var lb = element as LessonBlock;

      if (lb.startTime.hour * 60 + lb.startTime.minute <
              TimeOfDay.now().hour * 60 + TimeOfDay.now().minute &&
          lb.endTime.hour * 60 + lb.endTime.minute >
              TimeOfDay.now().hour * 60 + TimeOfDay.now().minute) {
        name = lb.subject;
      }
    }
    return name;
  }

  ///Returns all lessons of the next schoolday
  static List<dynamic>? getTableForNextSchoolday() {
    return getTableForDay(nextSchoolday());
  }

  static List<dynamic>? getTableForDay(int day) {
    print(weekdays[day]);
    if (day == 0 || day == 6) return [];
    if (Hive.box("timetable").get(day) == null) return [];

    return Hive.box("timetable").get(day).cast<Map>()?.map((e) {
      return LessonBlock.fromJson(e);
    }).toList();
  }

  ///0: Sunday, 1: Monday, 2: Tuesday, 3: Wednesday, 4: Thursday, 5: Friday, 6: Saturday
  ///
  ///Returns the next schoolday if it's a weekend
  static int nextSchoolday() {
    var day = DateTime.now().weekday;
    if (day <= 5) {
      return day;
    } else {
      return 1; //0: Sunday, 1: Monday
    }
  }

  static Future<bool> getTimetable() async {
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
    print("Next schoolday: ${Hive.box('timetable').get(nextSchoolday())}");
    return true;
  }

  static Future<void> _processTimetable() async {
    var timetableBox = Hive.box('timetable');

    var timetableString =
        await ApiProvider.fetchTimetable(UserSettings.classIdString);

    var timetable = jsonDecode(timetableString);

    const weekDaysPerWeek = 5;

    //Anfangen bei Montag (Tag "1" statt Sonntag ("0"))
    for (int i = 1; i <= weekDaysPerWeek; i++) {
      List<dynamic> day = [];
      List<dynamic> deleteBeforeNextPass = [];

      /**
       * Anmerkung: Unbedingt internal_id und nicht name vergleichen,
       * da sich die Namen von manchen Kursen überschneiden! WebUntis ist manchmal
       * sehr inkonsistent.
       */

      for (var t in timetable) {
        if (t["weekday"] == i && t["startTime"] != null) {
          for (var sub in UserSettings.subjects) {
            if (t["lessonid"] == sub["lessons"]?[0]["internal_id"] ||
                t["lessonid"] == sub["internal_id"] ||
                t["name"] == sub["name"] ||
                t["name"] == sub["lessons"]?[0]["name"]) {
              print("☺️ Added ${t["name"]} to timetable");
              day.add(t);
              deleteBeforeNextPass.add(t);
            }
          }
        }
      }
      print("------------ Subjects!!! ------------");
      print(UserSettings.subjects);
      print(UserSettings.subjectNames);

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
