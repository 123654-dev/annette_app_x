import 'package:annette_app_x/models/class_ids.dart';
import 'package:annette_app_x/models/theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

  static set shouldPerformOnboarding(bool value) {
    _config.put('shouldPerformOnboarding', value);
  }
}
