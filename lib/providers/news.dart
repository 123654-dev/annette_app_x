import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

///
/// Der Code dieser Datei wird vom Programm herangezogen, sobald es startet, damit
/// Nachrichtenfunktionalität gewährleistet wird.
///

class NewsProvider {

  // todo: use environment variables
  // eindeutige ID der Umgebung, in der die Nachrichten abgespeichert werden
  static const spaceID = "mr1v1r1x37i0";

  // dieser Wert muss bei jeder API Request angegeben werden, um Inhalte von Contentful zurückzubekommen
  // stellt euch es vor wie ein Passwort, damit Contentful weiß, dass du es auch wirklich bist
  static const contentDeliveryApiAccessToken = "B7d8auyBaT6BOR3_dc-i4Klp2YzdoL7jg0NK2dXC5B0";

  // selber Nutzen wie oben, aber für "Preview-Content", also Inhalte, die als Entwürfe vorhanden sind,
  // jedoch noch nicht publiziert wurden.
  static const contentPreviewApiAccessToken = "A8xgwjwpKgUJDi5T0nVfxNYqjz4GYFbjApq3ryv_viM";


  // für die Nachrichten:
  static const newsBox = "news";
  static const latestViewedNewsKey = "latestViewedNews";

  // dieser Wert wird abgespeichert unter dem Schlüssel "latestViewedNews", wenn noch keine Nachrichteneinträge gelesen wurden.
  static const latestViewedNewsDefaultValue = "none";


  static String newsEntries = "";

  // gibt an, ob oben rechts eine Notifikation kommen soll, die angibt, dass es neue Nachrichten gibt.
  static bool shouldShowInAppNotification = false;

  /// diese Methode macht einen API request an Contentful, um den Wert von "newsEntries" zu setzen. "newsEntries"
  /// kann dann von der Rest der App genutzt werden, um die Nachrichten anzuzeigen
  /// diese Methode vergleicht gleichzeitig das Datum der neusten Nachricht und die neuste, schon vom User gelesene Nachricht 
  /// legt damit fest, ob [shouldShowInAppNotification] auf true gesetzt werden soll
  static updateNewsEntries() async {

    final uri = Uri.https(
      "cdn.contentful.com",
      "/spaces/${NewsProvider.spaceID}/environments/master/entries",
      {"access_token": NewsProvider.contentDeliveryApiAccessToken}
    );
    final response = await http.get(uri);

    print("Contentful Response: ");
    print(response.body);

  }

  /// diese Methode wird in on_init_app aufgerufen, um den Speicher zu initialisieren, damit überhaupt ein Wert drin ist.
  static initializeNewsHiveBox() async {
    if (!Hive.isBoxOpen(newsBox)) {
      Box newsBox = await Hive.openBox(NewsProvider.newsBox); 
      if (!newsBox.containsKey(NewsProvider.latestViewedNewsKey)) {
        newsBox.put(NewsProvider.latestViewedNewsKey, NewsProvider.latestViewedNewsDefaultValue);
      }
      updateNewsEntries();
    }
  }

}