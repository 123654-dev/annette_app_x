import 'dart:async';
import 'dart:io';

import 'package:annette_app_x/models/class_ids.dart';
import 'package:annette_app_x/models/file_format.dart';
import 'package:annette_app_x/providers/storage.dart';
import 'package:annette_app_x/providers/user_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:annette_app_x/providers/api/files_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import 'package:annette_app_x/providers/api/files_provider.dart';

import 'package:pdfx/pdfx.dart';

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
  var _classId = UserSettings.classId;

  //Enthält später den Pfad zur heruntergeladenen PDF-Datei
  late File _file;

  //Bestimmt, ob das Menü zum Teilen des Klausurplans angezeigt wird
  bool showFileChoiceMenu = false;

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
            //Das Menü zum Teilen des Klausurplans, das angezeigt wird, wenn der User auf den Share-Button drückt
            PopupMenuButton(
              onSelected: (value) {
                _shareExamPlan(value);
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: FileFormat.PDF,
                  child: Text("als PDF teilen"),
                ),
                PopupMenuItem(
                  value: FileFormat.PNG,
                  child: Text("als Bilder teilen"),
                ),
              ],
              icon: PhosphorIcon(PhosphorIcons.duotone.shareFat,
                  color: Theme.of(context).colorScheme.primary),
              offset: const Offset(0, 60),
            ),
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
  void _shareExamPlan(FileFormat fileFormat) async {
    print(
        "sharing exam plan for ${_classId.fmtName} as ${fileFormat == FileFormat.JPG ? "image" : "pdf"}");
    if (fileFormat == FileFormat.PDF) {
      Share.shareXFiles([XFile(_file.path)],
          text: 'Klausurplan ${_classId.fmtName}');
    } else {
      //Öffnet die PDF-Datei
      var document = await PdfDocument.openFile(_file.path);

      //Iteriert über alle Seiten und speichert sie als JPG-Dateien in einer Liste
      List<XFile> pages = [];
      for (int i = 1; i <= document.pagesCount; i++) {
        //Öffnet die Datei erneut (eigentlich ist das nicht nötig, aber sonst gibt es einen "unknown error" mit cause "null" vom Plugin)
        document = await PdfDocument.openFile(_file.path);

        var page = await document.getPage(i);
        var pageImage = await page.render(
            width: page.width, height: page.height, backgroundColor: '#FFFFFF');
        File file = await FilesProvider.storeFile("examPlan$_classId;page$i", pageImage!.bytes, FileFormat.JPG);
        pages.add(XFile(file.path));
      }
      Share.shareXFiles(pages, text: 'Klausurplan ${_classId.fmtName}');

      //Löscht die temporär gespeicherten JPG-Dateien
      for (XFile file in pages) {
        await File(file.path).delete();
      }
    }
  }
}
