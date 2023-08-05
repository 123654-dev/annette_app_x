import 'package:annette_app_x/api/news_provider.dart';
import 'package:annette_app_x/screens/news/news_collection_screen.dart';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';

///
/// Diese Datei enthält den Code für das Aussehen der roten Notifikation oben rechts, wenn es neue Nachrichten gibt.
/// Diese Datei enthält auch die Logik dafür, da
///

class NewsNotification extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _NewsNotificationState();

}

class _NewsNotificationState extends State<NewsNotification> {

    /// Sinn dieser Function ist es, die neusten Nachrichten zu laden und gegebenenfalls eine Notifikation oben rechts anzuzeigen
  updateNewsNotification() async {
    await NewsProvider.updateShouldShowInAppNotification();

    /// setState muss gerufen werden, da nach dem Aufruf von NewsProvider.updateNewsEntries() der Wert von 
    setState(() {});
  }


  @override
  void initState() {
    // sobald dieser Widget initialisiert wird, wird auch "nachgeschaut", welche neuen Nachrichten es gibt.
    updateNewsNotification();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NewsProvider.shouldShowInAppNotification.value ? 
            Positioned(
              right: 10,
              top: 10,
              child: SizedBox(
                height: 30,
                width: 30,
                child: IconButton( 
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  color: Colors.white,
                  onPressed: () {

                    // redirect to newspage
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => NewsCollectionScreen())
                    );
                  },
                  icon: const Icon(Icons.priority_high, size: 10)
                )
              ) 
            ) : Container();
  }



}