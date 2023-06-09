import 'package:annette_app_x/api/news_provider.dart';
import 'package:flutter/material.dart';

///
/// Diese Datei enthält den Frontend Code für die Nachrichten-Seite
/// Auf dieser Seite werden alle Nachrichten angezeigt und man kann auf eine Nachricht klicken, um die Nachricht genauer anzuschauen.
/// Die Nachrichten werden auf Contentful gespeichert und geschrieben.
/// 


class NewsCollectionScreen extends StatefulWidget {

  /// gibt an, wie viele Einträge pro Seite vorhanden sein sollten.
  final entriesPerPage = 5;

  @override
  State<StatefulWidget> createState() => _NewsCollectionScreenState();

}

class _NewsCollectionScreenState extends State<NewsCollectionScreen> {

  /// da die Nachrichtenseite wie auf Google unterteilt ist (mehrere Seiten mit unterschiedlichem Content)
  /// gibt diese Anzahl an, auf welcher "Seite" wir uns gerade befinden
  /// Hierbei fängt man mit 0 an:
  /// _page = 0 -> Seite 1
  /// _page = 1 -> Seite 2
  /// ...
  int _page = 0;

  /// das braucht man für die "Seiten-Bar" unten
  int _totalPages = 0;
  dynamic _newsEntries;

  updateNewsEntries() async {

    final updatedNewsEntries = await NewsProvider.getNewsEntries(widget.entriesPerPage, _page * widget.entriesPerPage);
    print(updatedNewsEntries);
    setState(() {
      _newsEntries = updatedNewsEntries;
    });

    final totalEntries = await NewsProvider.getTotalEntries();
    setState(() {
      _totalPages = (totalEntries / 5).ceil();
    });

  }


  @override
  void initState() {
    updateNewsEntries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // todo: design
    return Container();
  }

}