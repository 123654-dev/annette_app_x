import 'dart:collection';

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
  static const String spaceID = "mr1v1r1x37i0";

  // dieser Wert muss bei jeder API Request angegeben werden, um Inhalte von Contentful zurückzubekommen
  // stellt euch es vor wie ein Passwort, damit Contentful weiß, dass du es auch wirklich bist
  static const String contentDeliveryApiAccessToken = "B7d8auyBaT6BOR3_dc-i4Klp2YzdoL7jg0NK2dXC5B0";

  // selber Nutzen wie oben, aber für "Preview-Content", also Inhalte, die als Entwürfe vorhanden sind,
  // jedoch noch nicht publiziert wurden.
  static const String contentPreviewApiAccessToken = "A8xgwjwpKgUJDi5T0nVfxNYqjz4GYFbjApq3ryv_viM";


  // für die Nachrichten:
  static const String newsBoxName = "news";
  static const String latestViewedNewsKey = "latestViewedNews";

  // dieser Wert wird abgespeichert unter dem Schlüssel "latestViewedNews", wenn noch keine Nachrichteneinträge gelesen wurden.
  static final DateTime latestViewedNewsDefaultValue = DateTime.utc(0);

  // dieser Cache ist für die Nachrichtenseite, wo alle Nachrichten angezeigt werden.
  static final List newsCollectionCache = List.empty();

  // dieser Cache ist für die detaillierte Ansicht der Nachrichten
  // dieser Cache ordnet dem ID eines Nachrichteneintrags ihrem detaillierten Inhalt zu, sodass keine Nachricht zweimal von Contentful abgefragt werden muss.
  static final HashMap detailedNewsCache = HashMap();

  // gibt an, ob oben rechts eine Notifikation kommen soll, die angibt, dass es neue Nachrichten gibt.
  static ValueNotifier shouldShowInAppNotification = ValueNotifier(false);

  /// diese Methode macht einen API request an Contentful, um den Wert von "newsEntries" zu setzen. "newsEntries"
  /// kann dann von der Rest der App genutzt werden, um die Nachrichten anzuzeigen
  /// diese Methode vergleicht gleichzeitig das Datum der neusten Nachricht und die neuste, schon vom User gelesene Nachricht 
  /// legt damit fest, ob [shouldShowInAppNotification] auf true gesetzt werden soll
  static updateShouldShowInAppNotification() async {

    // gönnt sich erst mal die Daten von Contentful
    final QueryResult contentfulQueryResults = await NewsProvider.graphQLClient.query(
      QueryOptions(
        document: gql(
          """
            query {
              newsEntryCollection(limit: 1, order: sys_firstPublishedAt_DESC) {
                items {
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

    final List entries = contentfulQueryResults.data?["newsEntryCollection"]["items"] as List;

    // das ist das Datum, an dem die neuste Nachricht publiziert wurde, als String
    final String dateOfLatestPublicationAsString = entries[0]["sys"]["firstPublishedAt"];

    // todo: diese Logik auslagern
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
      print("soll Notifikation zeigen");
      NewsProvider.shouldShowInAppNotification.value = true;
    }


  }

  /// Mit der Angabe einer ID wird der detaillierte Inhalt dieser Nachricht zurückgegeben und in den Cache [newsCollectionCache] reingetan
  /// das ist für die Seite der Nachricht
  static getDetailedNewsEntry(String id) async {

  }

  /// gönnt sich die gesamte Anzahl an Einträge, die es gibt
  static getTotalEntries() async {

    // gönnt sich erst mal die Daten von Contentful
    final QueryResult contentfulQueryResults = await NewsProvider.graphQLClient.query(
      QueryOptions(
        document: gql(
          """
            query {
              newsEntryCollection {
                total
              }
            }
          """
        )
      )
    );

    // todo

  }

  /// Mit der Angabe einer Anzahl [count] und einer Anzahl an übersprungenen Einträgen [skip] werden die 
  /// undetaillierten Inhalte von [count] Nachrichteneinträge zurückgegeben.
  /// Das ist für die "Vorschau"
  static getNewsEntries([int count=0, int skip=0]) async {


    // erst gucken, ob der Inhalt schon im Cache vorhanden ist oder nicht
    if (newsCollectionCache.length >= count + skip) return newsCollectionCache.sublist(skip, skip + count);

    // ansonsten wird Contentful gefragt.
    final QueryResult contentfulQueryResults = await NewsProvider.graphQLClient.query(
      QueryOptions(
        document: gql(
          """
            query {
              newsEntryCollection(skip: ${skip}, limit: ${count}, order: sys_firstPublishedAt_DESC) {
                items {
                  title
                  optionalMedia {
                    url
                    width
                    height
                  }
                  sys {
                    id
                  }
                }
              }
            }
          """
        )
      )
    );

    final List entries = contentfulQueryResults.data?["newsEntryCollection"]["items"] as List;

    // und dann werden die Entries zum Cache hinzugefügt.
    newsCollectionCache.fillRange(skip, skip + count, null);
    newsCollectionCache.replaceRange(skip, skip + count, entries);

    return entries;

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