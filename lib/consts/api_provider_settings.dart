///Enthält mehrere Konstanten, die für die Kommunikation mit der API benötigt werden
class ApiProviderSettings {
  ///Allgemeiner URL-Präfix der API
  ///Standardmäßig https://annette-swe-api.vercel.app/.
  ///Kann zum Testen von nicht-prod-Branches der API geändert werden.
  static const String baseURL = "https://annette-swe-api.vercel.app/";
}
