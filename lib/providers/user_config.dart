import 'package:annette_app_x/models/class_ids.dart';
import 'package:annette_app_x/models/theme_mode.dart';
import 'package:hive_flutter/hive_flutter.dart';

///Speichert User-Einstellungen, z.B. Klasse, Theme etc.
class UserConfig {
  ///Hive-Box, in der die Einstellungen gespeichert werden
  static final Box _box = Hive.box('user_config');

  ///[ClassId] ist Klasse, die der User ausgewählt hat
  static ClassId get classId {
    var classIdString = _box.get('class_id', defaultValue: ClassId.Q1.name);
    return ClassId.values
        .firstWhere((e) => e.name.toUpperCase() == classIdString.toUpperCase());
  }

  static set classId(ClassId value) {
    _box.put('class_id', value.name);
  }

  ///[AnnetteThemeMode] ist das Theme, das der User ausgewählt hat (aus dem [AnnetteThemeMode] Enum)
  static AnnetteThemeMode get themeMode {
    return _box.get('theme_mode', defaultValue: AnnetteThemeMode.material3);
  }

  static set themeMode(AnnetteThemeMode value) {
    _box.put('theme_mode', value);
  }

  static bool get isMaterial3 {
    return _box.get('is_material_three', defaultValue: false);
  }

  static set isMaterial3(bool value) {
    _box.put('is_material_three', value);
  }

  ///[downloadViaMobileData] ist ein bool, der angibt, ob die App auch über mobile Daten die Stunden-, Klausur- und Vertretungspläne aktualisieren darf (oder nur über WLAN)
  static bool get downloadViaMobileData {
    return _box.get('download_via_mobile_data', defaultValue: false);
  }

  static set downloadViaMobileData(bool value) {
    _box.put('download_via_mobile_data', value);
  }

  ///Hilfsfunktion, die prüft, ob die Klasse Oberstufe ist.
  ///Vereinfacht das Schreiben von Code (statt [ClassId.EF, ClassId.Q1, ClassId.Q2].contains(classId)) und so
  static bool get isOberstufe {
    return [ClassId.EF, ClassId.Q1, ClassId.Q2].contains(classId);
  }

  static String get subjectLastClassId {
    return _box.get('subject_last_class_id', defaultValue: classId.name);
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
}
