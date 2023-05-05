import 'package:annette_app_x/models/homework_entry.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Enthält Code, der beim Start der App ausgeführt werden soll
class AppInitializer {
  ///Hier wird alles initialisiert, was initialisiert werden möchte
  static Future<void> init() async {
    //Config (Hive) initialisieren
    await Hive.initFlutter();
    await Hive.openBox('user_config');
    await Hive.openBox('cache');

    //TypeAdapter
    HomeworkEntry.registerAdapter();

    //Homework (Hive) initialisieren
    if (!Hive.isBoxOpen('homework')) await Hive.openBox('homework');
    Hive.box("homework").values.toList().forEach((element) {
      print(element);
      if (element.done) {
        Hive.box("homework")
            .deleteAt(Hive.box("homework").values.toList().indexOf(element));
      }
    });
    //hier weiteren Code einfügen:
  }
}
