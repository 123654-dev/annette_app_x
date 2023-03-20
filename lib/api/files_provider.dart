library files_provider;

import 'dart:io';
import 'package:annette_app_x/models/class_ids.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

///
/// Enthält Methoden zum Herunterladen von Dateien aus dem Backend
///
class FilesProvider {
  /// Lädt den Stundenplan für die Klasse [id] aus dem Backend herunter und gibt ihn als File-Objekt zurück.
  /// Das File-Objekt kann dann z.B. mit dem PDFView-Widget angezeigt werden.
  static Future<File> loadExamPlansFromNetwork(ClassId id) async {
    var idString = id.name;
    print(idString);
    final response = await http
        .get(Uri.http('annette-app-files.vercel.app', 'klausur_$idString.pdf'));
    final bytes = response.bodyBytes;
    return await _storeFile(idString, bytes);
  }

  ///Helper-Methode, die die Datei lokal speichert und ein File-Objekt zurückgibt
  ///Das File-Objekt kann dann z.B. mit dem PDFView-Widget angezeigt werden.
  ///[className] ist der Name der Klasse, für die der Stundenplan gespeichert werden soll (daraus wird der Dateiname abgeleitet)
  static Future<File> _storeFile(className, bytes) async {
    final filename = '$className.pdf';
    final dir = await getApplicationDocumentsDirectory();

    //File lokal speichern
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}
