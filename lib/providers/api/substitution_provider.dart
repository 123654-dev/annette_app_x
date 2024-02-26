import 'dart:convert';

import 'package:annette_app_x/consts/api_provider_settings.dart';
import 'package:annette_app_x/models/class_ids.dart';
import 'package:annette_app_x/models/substitution.dart';
import 'package:annette_app_x/models/substitution_day.dart';
import 'package:annette_app_x/providers/api/api_provider.dart';
import 'package:annette_app_x/providers/connection_provider.dart';
import 'package:annette_app_x/providers/timetable_provider.dart';
import 'package:annette_app_x/providers/user_settings.dart';
import 'package:hive/hive.dart';

class SubstitutionProvider {
  static Future<void> saveSubstitutionDay(SubstitutionDay substDay) async {
    var substitutionDayBox = Hive.box('substitutionDays');

    var substDayEncoded = jsonEncode(substDay);
    print("Saved substitution day to cache: ${substDay.date.day}");
    //löscht alle alten Einträge

    //fügt den neuen Eintrag hinzu
    //Die ID ist der Tag des Monats (1-31)
    await substitutionDayBox.put("${substDay.date.day}|${UserSettings.classId}", substDayEncoded); 
  }

  static Future<SubstitutionDay> loadSubstitutionDay(DateTime date) async {
    var substitutionDayBox = Hive.box('substitutionDays');

    var substDayEncoded = substitutionDayBox.get("${date.day}|${UserSettings.classId}");
    var substDayDecoded = jsonDecode(substDayEncoded ?? "{}");

    print("Loaded substitution day from cache: ${date.day}");
    if (substDayEncoded == null) {
      return SubstitutionDay.empty();
    }

    return SubstitutionDay.fromJson(substDayDecoded);
  }

  static Future<SubstitutionDay> getSubstitutionDayFromDate(DateTime date,
      {bool forceReload = false}) async {
    if (!ConnectionProvider.hasDownloadConnection()) {
      return SubstitutionDay.empty();
    }

    print("Getting substitution day from date: $date with forceReload: $forceReload");
    SubstitutionDay substitutionSave = await loadSubstitutionDay(date);
    if (!substitutionSave.isEmpty && !forceReload) {
      return substitutionSave;
    }
    print("Substitution day not found in cache, fetching from server");

    String substitutionResult = await ApiProvider.fetchSubstitutionDayFromDate(
        date, UserSettings.classId);

    SubstitutionDay formattedSubstDay =
        await formatSubstitutionDay(substitutionResult, date);
    print(formattedSubstDay.substitutions);
    await saveSubstitutionDay(formattedSubstDay);

    return formattedSubstDay;
  }

  static Future<SubstitutionDay> getSubstitutionDayTodayOrTomorrow(
      bool ofToday, {bool forceReload = false}) async {
    DateTime date = ofToday
    ? TimetableProvider.nextSchoolDayTime()
    : TimetableProvider.nthNextSchoolDayDateTime(1);
    
    return await getSubstitutionDayFromDate(date, forceReload: forceReload);
  }


  static Future<SubstitutionDay> formatSubstitutionDay(
      String substitutionResult, DateTime date) async {
    final json = jsonDecode(substitutionResult);

    String? motd = json["motd"][0].toString();
    DateTime substDate = date;
    List<Substitution> substitutions = [];
    for (var substitutionUnformatted in json["substitutions"]) {
      Substitution substitution = Substitution.fromJson(substitutionUnformatted);
      print("checking");
      if (!UserSettings.hasSubject(substitution.subject) &&
          UserSettings.isDiffOrOberstufe) {
        continue;
      }
      print("added");
      substitutions.add(substitution);
    }
    substitutions.sort((a, b) => a.startLesson.compareTo(b.startLesson));

    for (int i = 0; i < substitutions.length - 1; i++) {
      for (int j = i + 1; j < substitutions.length; j++) {
        if (Substitution.isEqual(substitutions[i], substitutions[j]) &&
            (substitutions[i].endLesson == substitutions[j].startLesson - 1)) {
          substitutions[i].endLesson = substitutions[j].endLesson;
          substitutions.removeAt(j);
          j--;
        }
      }
    }
    SubstitutionDay substDay = SubstitutionDay(
        date: substDate, motd: motd, substitutions: substitutions);
    return substDay;
  }

}
