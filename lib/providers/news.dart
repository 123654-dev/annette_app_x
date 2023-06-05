import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:graphql/client.dart';


///
/// Der Code dieser Datei wird vom Programm herangezogen, sobald es startet, damit
/// Nachrichtenfunktionalität gewährleistet wird.
///

class NewsProvider {

  static GraphQLClient graphQLClient = GraphQLClient(
    link: AuthLink(
      getToken: () => "Bearer ${NewsProvider.contentDeliveryApiAccessToken}"
    ).concat(
      HttpLink(
        "https://graphql.contentful.com/content/v1/spaces/${NewsProvider.spaceID}/environments/master"
      )
    ),
    cache: GraphQLCache()
  );

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
  static const newsBoxName = "news";
  static const latestViewedNewsKey = "latestViewedNews";

  // dieser Wert wird abgespeichert unter dem Schlüssel "latestViewedNews", wenn noch keine Nachrichteneinträge gelesen wurden.
  static final latestViewedNewsDefaultValue = DateTime.utc(0);


  // ValueNotifiers werden genutzt, damit die App wieder was neues anzeigt, wenn neue Nachrichten vorhanden sind.
  static ValueNotifier<dynamic> newsEntries = ValueNotifier(null);

  // gibt an, ob oben rechts eine Notifikation kommen soll, die angibt, dass es neue Nachrichten gibt.
  static ValueNotifier shouldShowInAppNotification = ValueNotifier(false);

  /// diese Methode macht einen API request an Contentful, um den Wert von "newsEntries" zu setzen. "newsEntries"
  /// kann dann von der Rest der App genutzt werden, um die Nachrichten anzuzeigen
  /// diese Methode vergleicht gleichzeitig das Datum der neusten Nachricht und die neuste, schon vom User gelesene Nachricht 
  /// legt damit fest, ob [shouldShowInAppNotification] auf true gesetzt werden soll
  static updateNewsEntries() async {

    // gönnt sich erst mal die Daten von Contentful
    final QueryResult contentfulQueryResults = await NewsProvider.graphQLClient.query(
      QueryOptions(
        document: gql(
          """
            query {
              newsEntryCollection(order: sys_firstPublishedAt_DESC) {
                total
                items {
                  title
                  body {
                    json
                  }
                  optionalMedia {
                    url
                    width
                    height
                  }
                  sys {
                    firstPublishedAt
                  }
                }
              }
            }
          """
        )
      )
    );

    print("Contentful Response: ");
    print(contentfulQueryResults.data);

    final List entries = contentfulQueryResults.data?["newsEntryCollection"]["items"] as List;

    // das ist das Datum, an dem die neuste Nachricht publiziert wurde, als String
    final String dateOfLatestPublicationAsString = entries[0]["sys"]["firstPublishedAt"];

    // dieser String muss dann geparsed werden
    // von Contentful vorgegebenes Format: yyyy-mm-ddThh:mm Gemäß dessen wird im Folgenden geparsed
    final List<String> dateTimeParts = dateOfLatestPublicationAsString.split("T");
    final List<String> dateParts = dateTimeParts.first.split("-");
    final List<String> timeParts = dateTimeParts.last.split(":");

    final DateTime dateOfPublicationNewestArticle = DateTime(
      int.parse(dateParts[0]),
      int.parse(dateParts[1]),
      int.parse(dateParts[2]),
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );

    final newsBox = await Hive.openBox(NewsProvider.newsBoxName);
    final latestViewedNewsDate = newsBox.get(NewsProvider.latestViewedNewsKey) as DateTime;

    if (
      latestViewedNewsDate == NewsProvider.latestViewedNewsDefaultValue || 
      latestViewedNewsDate.isBefore(dateOfPublicationNewestArticle)
    ) {
      shouldShowInAppNotification.value = true;
      newsEntries.value = entries;
    }


  }

  /// diese Methode wird in on_init_app aufgerufen, um den Speicher zu initialisieren, damit überhaupt ein Wert drin ist.
  static initializeNewsHiveBox() async {

    // Speicher wird initialisiert
    Box newsBox = await Hive.openBox(NewsProvider.newsBoxName); 
    if (!newsBox.containsKey(NewsProvider.latestViewedNewsKey)) {
      newsBox.put(NewsProvider.latestViewedNewsKey, NewsProvider.latestViewedNewsDefaultValue);
    }

  }

}