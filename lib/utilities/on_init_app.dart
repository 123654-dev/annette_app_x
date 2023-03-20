import 'dart:io';

import 'package:annette_app_x/providers/user_config.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Enthält Code, der beim Start der App ausgeführt werden soll
class AppInitializer {
  ///Hier wird alles initialisiert, was initialisiert werden möchte
  static Future<void> init() async {
    //Config (Hive) initialisieren
    await Hive.initFlutter();
    await Hive.openBox('user_config');

    //hier weiteren Code einfügen:
  }
}
