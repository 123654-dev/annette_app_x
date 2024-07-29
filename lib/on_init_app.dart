import 'package:annette_app_x/models/homework_entry.dart';
import 'package:annette_app_x/api/news_provider.dart';
import 'package:annette_app_x/providers/connection_provider.dart';
import 'package:annette_app_x/utilities/homework_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;

/// Enthält Code, der beim Start der App ausgeführt werden soll
class AppInitializer {
  ///Hier wird alles initialisiert, was initialisiert werden möchte

  static Future<void> init() async {
    await dotenv.load(fileName: ".env");

    //Config (Hive) initialisieren
    await Hive.initFlutter();
    await Hive.openBox('user_config');
    await Hive.openBox('cache');
    await Hive.openBox('app_settings');
    await Hive.openBox('timetable');
    await Hive.openBox("subjectDays");
    await Hive.openBox("holidays");
    await Hive.openBox(NewsProvider.newsBoxName);

    // Nachrichten werden initialisiert
    await NewsProvider.initializeNewsHiveBox();

    //TypeAdapter
    HomeworkEntry.registerAdapter();

    //Homework (Hive) initialisieren
    //Hive.deleteBoxFromDisk('homework');
    if (!Hive.isBoxOpen('homework')) await Hive.openBox('homework');

    Hive.box("homework").values.toList().forEach((element) {
      if (element.done &&
          (element as HomeworkEntry)
              .lastUpdated
              .isBefore(DateTime.now().subtract(const Duration(days: 7)))) {
        HomeworkManager.deleteFromBin(element);
      }
    });

    //ConnectionProvider initialisieren
    ConnectionProvider.init();

    //Request permission to load files from the internet

    //Zeitzonen initialisieren (für Notifications)
    tz.initializeTimeZones();
  }

  static bool shouldPerformOnboarding() {
    var userConfig = Hive.box('user_config');
    return userConfig.get('shouldPerformOnboarding') ?? true;
  }
}
