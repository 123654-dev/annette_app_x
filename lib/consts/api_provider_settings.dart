import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

///Enthält mehrere Konstanten, die für die Kommunikation mit der API benötigt werden
class ApiProviderSettings {
  ///Allgemeiner URL-Präfix der API
  ///Standardmäßig annette-api-x.vercel.app.
  ///Kann zum Testen von nicht-prod-Branches der API geändert werden.
  static String get baseURL {
    var envUrl = dotenv.env['API_URL'];

    if (envUrl != null && Uri.http(envUrl).isAbsolute) {
      return envUrl;
    } else {
      debugPrint(
          "\x1B[31mKeine gültige API-URL in .env gefunden. Verwende Standard-URL.\x1B[0m");
      return "annette-api-x.vercel.app";
    }
  }
}
