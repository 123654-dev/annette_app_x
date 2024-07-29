library files_provider;

import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:annette_app_x/models/class_ids.dart';
import 'package:annette_app_x/providers/api/api_provider.dart';
import 'package:annette_app_x/providers/storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../models/file_format.dart';

///
/// Enthält Methoden zum Herunterladen von Dateien aus dem Backend
///
class FilesProvider {
  /// Lädt den Klausurplan für die Klasse [id] aus dem Backend herunter und gibt ihn als File-Objekt zurück.
  static Future<String> fetchTimetable() async {
    // Get the URL from the ApiProvider (replace with your actual implementation)
    String url = await ApiProvider.getTimetableUrl();

    // Get the directory where the file will be saved
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir.path}/saved_html.html';

    // Check if the file already exists
    File file = File(filePath);
    if (file.existsSync()) {
      return file.path; // Return the previously saved file
    } else {
      // If the file doesn't exist, fetch it from the URL
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Save the HTML content to the file
        await file.writeAsString(response.body);
        return file.path;
      } else {
        throw Exception('Failed to fetch HTML from the URL');
      }
    }
  }

  /// Lädt den Stundenplan für die Klasse [id] aus dem Backend herunter und gibt ihn als File-Objekt zurück.
  /// Das File-Objekt kann dann z.B. mit dem PDFView-Widget angezeigt werden.
  /// Speichert den Klausurplan lokal unter [id.name].pdf
  static Future<File> _loadExamPlansFromNetwork(ClassId id) async {
    var idString = id.fmtName;
    final response = await http
        .get(Uri.http('annette-app-files.vercel.app', 'klausur_$idString.pdf'));
    final bytes = response.bodyBytes;
    StorageProvider.saveExamPlanDate(id);
    return await storeFile(idString, bytes, FileFormat.PDF);
  }

  ///Helper-Methode, die die Datei lokal speichert und ein File-Objekt zurückgibt
  ///Das File-Objekt kann dann z.B. mit dem PDFView-Widget angezeigt werden.
  ///[name] ist der Name. unter dem die Datei gespeichert werden soll
  static Future<File> storeFile(String name, List<int> bytes, FileFormat fileFormat) async {
    final filename = name + '.' + fileFormat.name.toLowerCase();
    final dir = await getApplicationDocumentsDirectory();

    //File lokal speichern
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  ///Helper-Methode, die eine Datei anhand des Namens zurückgibt
  ///[name] ist der Name der Datei
  static Future<File?> getFile(String name, FileFormat fileFormat) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name.${fileFormat.name.toLowerCase()}');
    return file;
  }

  ///Lädt den Klausurplan für die Klasse [id] herunter und gibt ihn als File-Objekt zurück.
  static Future<File> getExamPlanFile(ClassId id) async {
    //Ist der Klausurplan bereits auf dem neuesten Stand?
    if (await StorageProvider.isExamPlanUpToDate(id)) {
      //Dateinamen zusammensetzen
      var idString = id.fmtName;
      final filename = '$idString.pdf';
      final dir = await getApplicationDocumentsDirectory();

      //File laden und zurückgeben
      final file = File('${dir.path}/$filename');
      print("Serving a locally-sourced exam plan for $id");

      return file;
    } else {
      //Der Klausurplan ist veraltet -> herunterladen
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
