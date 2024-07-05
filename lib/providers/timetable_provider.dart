import 'dart:convert';

import 'package:annette_app_x/models/lesson_block.dart';
import 'package:annette_app_x/providers/user_settings.dart';
import 'package:annette_app_x/widgets/timetable/timetable_day.dart';
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
    if (day <= 5 && day > 0) {
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
    var subjectDayBox = Hive.box("subjectDays");

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
                //  t["name"] == sub["name"] ||
                t["longname"] == sub["longname"]) {
              print("☺️ Added ${t["name"]} to timetable");
              //Add this weekday to the days where the subject is taught
              String? ln = t["longname"];
              if (ln != null) {
                if (subjectDayBox.get(ln) == null ||
                    !subjectDayBox.get(ln).contains(i)) {
                  subjectDayBox.put(ln, (subjectDayBox.get(ln) ?? [])..add(i));
                  print("Added day $i to ${ln} in timetable");
                  print("Days: ${subjectDayBox.get(ln)}");
                }
              }

              day.add(t);
              deleteBeforeNextPass.add(t);
            }
          }
        }
      }

      for (var t in deleteBeforeNextPass) {
        timetable.remove(t);
      }

      day.sort((a, b) => a["startTime"].compareTo(b["startTime"]));
      timetableBox.put(i, day);
    }
    timetableBox.put("classId", UserSettings.classIdString);
  }

  static DateTime getNextClassDay(String subject) {
    List<dynamic> days = Hive.box("subjectDays").get(subject);
    //Sort so that the next day is first, not monday
    days = days.toSet().toList();
    days.forEach((element) {
      print(element);
    });
    days.sort((a, b) => a.compareTo(b));

    var wd = days.firstWhere((element) => element > DateTime.now().weekday,
        orElse: () => days.first);

    //Get next date with this weekday:
    var nextDate = DateTime.now()
        .add(Duration(days: wd - DateTime.now().weekday))
        .add(const Duration(days: 7))
        .copyWith(
            hour: 8, minute: 0, second: 0, millisecond: 0, microsecond: 0);

    return nextDate;
  }

  static Future<String> getCurrentHoliday() async {
    print("Getting current holiday");

    if (Hive.box("cache").get("lastHolidayUpdate") == null ||
        (Hive.box("cache").get("lastHolidayUpdate") as DateTime)
            .isBefore(DateTime.now().subtract(const Duration(days: 24)))) {
      Hive.box("holidays").clear();
    }

    if (Hive.box("Holidays").isEmpty) {
      print("Updating holidays");
      //Fetch holidays
      var holidays = jsonDecode(await ApiProvider.fetchHolidays());
      for (var h in holidays) {
        var startDay = DateTime.parse(h["startDate"]);
        var endDay = DateTime.parse(h["endDate"]);
        var diff = endDay.difference(startDay).inDays;
        do {
          print(
              "Adding ${h["name"]} to ${startDay.year}${startDay.month.toString().padLeft(2, "0")}${startDay.day.toString().padLeft(2, "0")}");
          Hive.box("holidays").put(
              "${startDay.year}${startDay.month.toString().padLeft(2, "0")}${startDay.day.toString().padLeft(2, "0")}",
              h["name"]);
          startDay = startDay.add(const Duration(days: 1));
          diff--;
        } while (diff >= 0);
      }
      Hive.box("cache").put("lastHolidayUpdate", DateTime.now());
    }

    String date =
        "${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, "0")}${DateTime.now().day.toString().padLeft(2, "0")}";
    var holidays = Hive.box("holidays").get(date);
    if (holidays == null) return "###";

    return holidays;
  }
}
