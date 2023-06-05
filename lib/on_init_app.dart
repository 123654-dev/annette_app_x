import 'package:annette_app_x/models/homework_entry.dart';
import 'package:annette_app_x/providers/news.dart';
import 'package:annette_app_x/providers/notifications.dart';
import 'package:annette_app_x/utilities/homework_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:timezone/data/latest.dart' as tz;

/// Enthält Code, der beim Start der App ausgeführt werden soll
class AppInitializer {
  ///Hier wird alles initialisiert, was initialisiert werden möchte
  

  static Future<void> init() async {
    //Config (Hive) initialisieren
    await Hive.initFlutter();
    await Hive.openBox('user_config');
    await Hive.openBox('cache');
    await Hive.openBox(NewsProvider.newsBox);

    
    // Nachrichten werden initialisiert
    await NewsProvider.initializeNewsHiveBox();

    //TypeAdapter
    HomeworkEntry.registerAdapter();

    //Homework (Hive) initialisieren
    //Hive.deleteBoxFromDisk('homework');
    if (!Hive.isBoxOpen('homework')) await Hive.openBox('homework');

    Hive.box("homework").values.toList().forEach((element) {
      print(element);

      if (element.done &&
          (element as HomeworkEntry)
              .lastUpdated
              .isBefore(DateTime.now().subtract(const Duration(days: 7)))) {
        HomeworkManager.deleteFromBin(element);
      }
    });

    //Notifications initialisieren
    await NotificationProvider().init();

    //Zeitzonen initialisieren (für Notifications)
    tz.initializeTimeZones();


    //hier weiteren Code einfügen:
    
    // GraphQl Verbindung wird initialisiert (https://pub.dev/packages/graphql_flutter#usage)
    // schließlich benutzen wir GraphQl, um die Informationen von Contentful zu holen
    final HttpLink httpLink = HttpLink(
      "https://graphql.contentful.com/content/v1/spaces/${NewsProvider.spaceID}/environments/master"
    );

    final AuthLink authLink = AuthLink(
      getToken: () => "Bearer ${NewsProvider.contentDeliveryApiAccessToken}"
    );

    final Link fullLink = authLink.concat(httpLink);

     = ValueNotifier(
      GraphQLClient(
        link: fullLink,
        cache: GraphQLCache()
      ),
    );
    

  }
}
