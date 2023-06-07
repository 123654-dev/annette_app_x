import 'package:annette_app_x/consts/api_provider_settings.dart';
import 'package:http/http.dart' as http;

///Enthält alle Methoden, die mit dem Backend kommunizieren
class ApiProvider {
  ///Sammelt alle Wahlpflichtoptionen für Klasse bzw. Stufe [id] aus der API und gibt sie als JSON-String zurück.
  ///Dabei werden sowohl Diff-Fächer als auch Oberstufenkurse berücksichtigt
  //TODO: das Backend ist noch nicht zuverlässig.
  static Future<String> fetchChoiceOptions(String id) async {
    //Workaround für einen Bug/eine Fehlkonfiguration auf der Seite von WebUntis,
    //durch den nur die Pläne für a-Klassen alle Diff-Optionen enthalten
    if (id.startsWith("9") || id.startsWith("10")) {
      id = "${id.substring(0)}A";
    }

    //HTTP-Request
    var res = await http.get(Uri.http(ApiProviderSettings.baseURL,
        'api/annette_app/dateien/stundenplan/optionen/$id'));

    //Erfolgreich?
    if (res.statusCode != 200) {
      throw Exception('http.get error: statusCode= ${res.statusCode}');
    } else {}

    return res.body;
  }

  /// Alle Klassen, die ausgewählt werden können, aus der API laden und als JSON-String zurückgeben
  /// z.B. "7A", "Q1", "Q2"
  static Future<String> preloadClasses() async {
    var res = await http.get(Uri.http(ApiProviderSettings.baseURL,
        'api/annette_app/dateien/stundenplan/optionen/klassen'));
    if (res.statusCode != 200) {
      throw Exception('http.get error: statusCode= ${res.statusCode}');
    } else {}
    return res.body;
  }
}
