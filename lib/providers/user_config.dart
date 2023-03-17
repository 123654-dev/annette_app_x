import 'package:annette_app_x/models/class_ids.dart';
import 'package:annette_app_x/models/theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserConfig {
  static final Box _box = Hive.box('user_config');

  static ClassIds get classId {
    return _box.get('class_id', defaultValue: ClassIds.kl_5A);
  }

  static set classId(ClassIds value) {
    _box.put('class_id', value);
  }

  static AnnetteThemeMode get themeMode {
    return _box.get('theme_mode', defaultValue: AnnetteThemeMode.system);
  }
}
