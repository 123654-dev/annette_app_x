import 'package:annette_app_x/models/class_ids.dart';
import 'package:annette_app_x/models/theme_mode.dart';
import 'package:hive_flutter/hive_flutter.dart';

///Speichert User-Einstellungen, z.B. Klasse, Theme etc.
class UserConfig {
  ///Hive-Box, in der die Einstellungen gespeichert werden
  static final Box _box = Hive.box('user_config');

  ///[ClassId] ist Klasse, die der User ausgewählt hat
  static ClassId get classId {
    var classIdString = _box.get('class_id', defaultValue: ClassId.Q1.fmtName);
    return ClassId.values.firstWhere(
        (e) => e.fmtName.toUpperCase() == classIdString.toUpperCase());
  }

  static set classId(ClassId value) {
    _box.put('class_id', value.fmtName);
  }

  ///[AnnetteThemeMode] ist das Theme, das der User ausgewählt hat (aus dem [AnnetteThemeMode] Enum)
  static AnnetteThemeMode get themeMode {
    return _box.get('theme_mode', defaultValue: AnnetteThemeMode.material3);
  }

  ///Hilfsfunktion, die prüft, ob die Klasse Oberstufe ist.
  ///Vereinfacht das Schreiben von Code (statt [ClassId.EF, ClassId.Q1, ClassId.Q2].contains(classId)) und so
  static bool get isOberstufe {
    return [ClassId.EF, ClassId.Q1, ClassId.Q2].contains(classId);
  }

  static String get subjectLastClassId {
    return _box.get('subject_last_class_id', defaultValue: classId.fmtName);
  }

  static set subjectLastClassId(String value) {
    _box.put('subject_last_class_id', value);
  }

  static List<dynamic> get selectedSubjects {
    return _box.get('selected_subjects', defaultValue: []);
  }

  static set selectedSubjects(List<dynamic> value) {
    _box.put('selected_subjects', value);
  }

  static set shouldPerformOnboarding(bool value) {
    _box.put('shouldPerformOnboarding', value);
  }
}
