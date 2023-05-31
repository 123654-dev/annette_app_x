import 'dart:async';
import 'dart:io';

import 'package:annette_app_x/models/class_ids.dart';
import 'package:annette_app_x/providers/storage.dart';
import 'package:annette_app_x/providers/user_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:annette_app_x/api/files_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';

///Diese Seite zeigt Klausurpläne an.
class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  //Falls der Download noch läuft, soll ein Ladebalken angezeigt werden
  bool _isLoading = true;

  Key _pdfViewerKey = UniqueKey();

  //Bei Fehlschlagen des Downloads (_catastrophicFailure == true) wird ein Fehler angezeigt.
  bool _catastrophicFailure = false;

  //Klassen-ID aus der User Config (siehe lib/providers/user_config.dart) laden
  var _classId = UserConfig.classId;

  //Enthält später den Pfad zur heruntergeladenen PDF-Datei
  late File _file;

  @override
  void initState() {
    //Beim erstmaligen Laden der Seite wird versucht, den Klausurplan herunterzuladen
    switchClass(ClassId.Q1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      Padding(
          padding: const EdgeInsets.all(15),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            //SegmentedButton zur Auswahl der Stufe
            //Standardwert ist dabei die Stufe aus der User Config
            //aktuelle Auswahl wird in _classId gespeichert
            SegmentedButton<ClassId>(
              multiSelectionEnabled: false,
              segments: const [
                ButtonSegment<ClassId>(value: ClassId.EF, label: Text("EF")),
                ButtonSegment<ClassId>(value: ClassId.Q1, label: Text("Q1")),
                ButtonSegment<ClassId>(value: ClassId.Q2, label: Text("Q2")),
              ],
              selected: <ClassId>{_classId},
              onSelectionChanged: (Set<ClassId> sel) => switchClass(sel.first),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
                height: 60,
                width: 20,
                child: VerticalDivider(
                  width: 20,
                  thickness: 1,
                  indent: 15,
                  endIndent: 15,
                  color: Theme.of(context).colorScheme.onBackground,
                )),
            //TODO: implementieren
            //mit diesem Button sollen alle Klausurtermine vorgeschlagen werden,
            //der User kann nun alle ihn betreffenden Termine auswählen und automatisch
            //in den Kalender importieren.
            // ? Welchen Kalender, den des Handys?
            /*IconButton(
              onPressed: () {},
              icon: PhosphorIcon(PhosphorIcons.duotone.download,
                  color: Theme.of(context).colorScheme.primary),
            ),*/

            IconButton(
              onPressed: _shareExamPlan,
              icon: PhosphorIcon(PhosphorIcons.duotone.shareFat,
                  color: Theme.of(context).colorScheme.primary),
            )
          ])),
      Expanded(
        child: _catastrophicFailure
            ? const Center(
                child: Text(
                    'Es ist ein Fehler aufgetreten. Bitte versuche es später erneut.'),
              )
            : (_isLoading
                ? const Center(child: CircularProgressIndicator())
                : Center(
                    child: PDFView(
                      key: _pdfViewerKey,
                      filePath: _file.path,
                    ),
                  )),
      )
    ]));
  }

  ///kleine Callback-Funktion, die aufgerufen wird, wenn der User eine andere Stufe auswählt
  ///Setzt _isLoading auf true zurück und löst erneut attemptDownload() mit aktualisierter _classId aus
  void switchClass(ClassId id) async {
    setState(() {
      _classId = id;
      _isLoading = true;
    });
    File file = await FilesProvider.getExamPlanFile(id);
    setState(() {
      _file = file;
      _isLoading = false;
      _pdfViewerKey = UniqueKey();
    });
  }

  ///Diese Funktion wird aufgerufen, wenn der User den Share-Button drückt
  ///Sie teilt die PDF-Datei mit anderen Apps
  void _shareExamPlan() async {
    Share.shareXFiles([XFile(_file.path)],
        text: 'Klausurplan ${_classId.name}');
  }
}
