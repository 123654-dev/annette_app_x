import 'dart:convert';

import 'package:annette_app_x/consts/api_provider_settings.dart';
import 'package:annette_app_x/providers/user_settings.dart';
import 'package:http/http.dart' as http;

///Enthält alle Methoden, die mit dem Backend kommunizieren
class ApiProvider {
  static Future<String> fetchChoiceOptions(String id) async {
    //Workaround für einen Bug/eine Fehlkonfiguration auf der Seite von WebUntis,
    //durch den nur die Pläne für a-Klassen alle Diff-Optionen enthalten
    // if (id.startsWith("9") || id.startsWith("10")) {
    //  id = "${id.substring(0)}A";
    // }

    var result = await http.get(Uri.http(
        ApiProviderSettings.baseURL, 'api/annette_app/info/optionen/$id'));

    var success = (result.statusCode == 200);

    if (!success) {
      throw Exception('Code ${result.statusCode}: Server error');
    }

    return result.body;
  }

  /// Alle Klassen, die ausgewählt werden können, aus der API laden und als JSON-String zurückgeben
  /// z.B. "7A", "Q1", "Q2"
  static Future<String> fetchClasses() async {
    var result = await http.Request(
            'GET',
            Uri.http(
                ApiProviderSettings.baseURL, 'api/annette_app/info/classes'))
        .send();

    var success = (result.statusCode == 200);

    if (!success) {
      throw Exception('‼️ http.get error: statusCode= ${result.statusCode}');
    }

    return result.stream.bytesToString();
  }

  static Future<String> fetchClassesAsList() async {
    var result = await http.get(
        Uri.http(ApiProviderSettings.baseURL, 'api/annette_app/info/classes'),
        headers: {
          "Accept": "application/json;charset=UTF-8",
          "Content-Encoding": "gzip, deflate, br",
        });

    var success = (result.statusCode == 200);

    if (!success) {
      throw Exception('‼️ http.get error: statusCode= ${result.statusCode}');
    }

    return result.body;
  }

  static Future<String> fetchTimetable(String id) async {
    var result = await http.get(
        Uri.http(ApiProviderSettings.baseURL, 'api/annette_app/timetable/$id'),
        headers: {
          "Accept": "application/json;charset=UTF-8",
          "Content-Encoding": "gzip, deflate, br",
        });

    var success = (result.statusCode == 200);

    if (!success) {
      throw Exception(
          '‼️ http.get error @ fetchTimetable: statusCode= ${result.statusCode}');
    }

    return utf8.decode(result.bodyBytes);
  }

  static Future<String> getTimetableUrl() async {
    print("Getting timetable URL");
    var classes = jsonDecode(await fetchClassesAsList());
    print("Classes: $classes");
    String htmlSuffix =
        (classes.indexOf(UserSettings.classIdString.toUpperCase())).toString();
    htmlSuffix = htmlSuffix.padLeft(5, "0");
    return "plaene.annettegymnasium.de/stundenplan_oL/c/P4/c$htmlSuffix.htm";
  }

  static Future<String> fetchHolidays() async {
    var result = await http.get(
        Uri.http(ApiProviderSettings.baseURL, 'api/annette_app/info/holidays'),
        headers: {
          "Accept": "application/json;charset=UTF-8",
          "Content-Encoding": "gzip, deflate, br",
        });

    var success = (result.statusCode == 200);

    if (!success) {
      throw Exception(
          '‼️ http.get error @ fetchHolidays: statusCode= ${result.statusCode}');
    }

    return result.body;
  }
}
