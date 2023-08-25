import 'package:annette_app_x/models/class_ids.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'api/subjects_provider.dart';

///Speichert User-Einstellungen, z.B. Klasse, Theme etc.
class UserSettings {
  ///Hive-Box, in der die Einstellungen gespeichert werden
  static final Box _config = Hive.box('user_config');
  static final Box _appSettings = Hive.box('app_settings');

  ///[ClassId] ist Klasse, die der User ausgewählt hat
  static ClassId get classId {
    var classIdString =
        _config.get('class_id', defaultValue: ClassId.Q1.fmtName);
    return ClassId.values.firstWhere(
        (e) => e.fmtName.toUpperCase() == classIdString.toUpperCase());
  }

  static set classId(ClassId value) {
    _config.put('class_id', value.fmtName);
  }

  static void saveSubjects(List<dynamic> parallelSubjects) async {
    if (parallelSubjects == []) {
      parallelSubjects = selectedSubjects;
    } else {
      selectedSubjects = parallelSubjects;
    }
    List<dynamic> allSubjects = [];
    subjects = [];

    // Get all subjects from the selected class
    var allSubjectsFromAPI = await SubjectsProvider.getSubjects(classId);

    // Sort out all parallel subjects
    var nonParallelSubjects = allSubjectsFromAPI
        .where((subject) => (subject["lessons"].length == 1))
        .toList();

    print("Parallel subjects: $parallelSubjects");

    for (var element in parallelSubjects) {
      for (var subject in allSubjectsFromAPI) {
        if (element["selection"][0]["id"] == -420) {
          break;
        }
        var lesson = subject["lessons"].firstWhere(
            (lesson) => lesson["internal_id"] == element["selection"][0]["id"],
            orElse: () => null);
        if (lesson != null) {
          subject["lessons"] = [lesson];
          allSubjects.add(subject);
        }
      }
    }

    allSubjects.addAll(nonParallelSubjects);

    print(allSubjects);

    _saveSubjectNames(allSubjects);

    subjectFullNames = subjectNames + ["Sonstiges"];

    print(subjectNames);
    subjects = allSubjects;
  }

  static void _saveSubjectNames(List<dynamic> subjects) {
    List<String> names = [];
    for (var subject in subjects) {
      names.add(subject["lessons"][0]["name"]);
    }
    subjectNames = names;
  }

  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.dark);

  ///[ThemeMode] ist das Theme, das der User ausgewählt hat
  static ThemeMode get themeMode {
    return ThemeMode.values[_appSettings.get('theme_mode',
        defaultValue: ThemeMode.values.indexOf(ThemeMode.dark))];
  }

  static bool get useMaterial3 {
    return _appSettings.get('use_material3', defaultValue: false);
  }

  static set useMaterial3(bool value) {
    _appSettings.put('use_material3', value);
  }

  static set themeMode(ThemeMode value) {
    themeNotifier.value = value;
    _appSettings.put('theme_mode', ThemeMode.values.indexOf(value));
  }

  ///Hilfsfunktion, die prüft, ob die Klasse Oberstufe ist.
  ///Vereinfacht das Schreiben von Code (statt [ClassId.EF, ClassId.Q1, ClassId.Q2].contains(classId)) und so
  static bool get isOberstufe {
    return [ClassId.EF, ClassId.Q1, ClassId.Q2].contains(classId);
  }

  static String get subjectLastClassId {
    return _config.get('subject_last_class_id', defaultValue: classId.fmtName);
  }

  static set subjectLastClassId(String value) {
    _config.put('subject_last_class_id', value);
  }

  static List<dynamic> get selectedSubjects {
    return _config.get('selected_subjects', defaultValue: []);
  }

  static set selectedSubjects(List<dynamic> value) {
    _config.put('selected_subjects', value);
  }

  static List<dynamic> get subjects {
    return _config.get('subjects', defaultValue: []);
  }

  static set subjects(List<dynamic> value) {
    _config.put('subjects', value);
  }

  static List<String> get subjectNames {
    var namesDynamic = _config.get('subjectNames', defaultValue: []);
    List<String> namesStrings = List<String>.from(namesDynamic);
    return namesStrings;
  }

  static set subjectNames(List<dynamic> value) {
    _config.put('subjectNames', value);
  }

  static List<String> get subjectFullNames {
    var namesDynamic = _config.get('subjectFullNames', defaultValue: []);
    List<String> namesStrings = List<String>.from(namesDynamic);
    return namesStrings;
  }

  static set subjectFullNames(List<dynamic> value) {
    _config.put('subjectFullNames', value);
  }

  static set shouldPerformOnboarding(bool value) {
    _config.put('shouldPerformOnboarding', value);
  }
}
