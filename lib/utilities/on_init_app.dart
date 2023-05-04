import 'package:hive_flutter/hive_flutter.dart';

/// Enthält Code, der beim Start der App ausgeführt werden soll
class AppInitializer {
  ///Hier wird alles initialisiert, was initialisiert werden möchte
  static Future<void> init() async {
    //Config (Hive) initialisieren
    await Hive.initFlutter();
    await Hive.openBox('user_config');
    await Hive.openBox('cache');

    //hier weiteren Code einfügen:
  }
}
