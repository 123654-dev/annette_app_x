import 'dart:io';

import 'package:annette_app_x/providers/user_config.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppInitializer {
  static Future<void> init() async {
    //Initialize all providers here

    //Config initialization (Hive)
    await Hive.initFlutter();

    await Hive.openBox('user_config');
    //
    // ...
  }
}
