library files_provider;

import 'dart:async';
import 'dart:io';
import 'package:annette_app_x/models/class_ids.dart';
import 'package:annette_app_x/providers/storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../models/file_format.dart';

///
/// Enthält Methoden zum Herunterladen von Dateien aus dem Backend
///
class FilesProvider {
  /// Lädt den Stundenplan für die Klasse [id] aus dem Backend herunter und gibt ihn als File-Objekt zurück.
  /// Das File-Objekt kann dann z.B. mit dem PDFView-Widget angezeigt werden.
  /// Speichert den Stundenplan lokal unter [id.name].pdf
  static Future<File> _loadExamPlansFromNetwork(ClassId id) async {
    var idString = id.name;
    final response = await http
        .get(Uri.http('annette-app-files.vercel.app', 'klausur_$idString.pdf'));
    final bytes = response.bodyBytes;
    StorageProvider.saveExamPlanDate(id);
    return await storeFile(idString, bytes, FileFormat.PDF);
  }

  ///Helper-Methode, die die Datei lokal speichert und ein File-Objekt zurückgibt
  ///Das File-Objekt kann dann z.B. mit dem PDFView-Widget angezeigt werden.
  ///[name] ist der Name. unter dem die Datei gespeichert werden soll
  static Future<File> storeFile(name, bytes, FileFormat fileFormat) async {
    final filename = fileFormat == FileFormat.PDF ? '$name.pdf' : fileFormat == FileFormat.PNG ? '$name.png' : '$name.jpg';
    final dir = await getApplicationDocumentsDirectory();

    //File lokal speichern
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  ///Lädt den Stundenplan für die Klasse [id] herunter und gibt ihn als File-Objekt zurück.
  static Future<File> getExamPlanFile(ClassId id) async {
    //Ist der Stundenplan bereits auf dem neuesten Stand?
    if (await StorageProvider.isExamPlanUpToDate(id)) {
      //Dateinamen zusammensetzen
      var idString = id.name;
      final filename = '$idString.pdf';
      final dir = await getApplicationDocumentsDirectory();

      //File laden und zurückgeben
      final file = File('${dir.path}/$filename');
      print("Serving a locally-sourced exam plan for $id");

      return file;
    } else {
      //Der Stundenplan ist veraltet -> herunterladen
      try {
        File file = await _loadExamPlansFromNetwork(id)
            .timeout(const Duration(seconds: 100), onTimeout: () {
          throw TimeoutException('Timeout downloading exam plan');
        });
        return file;
      } catch (e) {
        throw Exception('Error downloading exam plan: $e');
      }
    }
  }
}
