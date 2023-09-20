# Erklärungen

## Hier werden die einzelnen Vorgänge innerhalb der Annette-App genauer erklärt

### Hausaufgaben-Import:
- `android/app/src/main/AndroidManifest.xml`: 
  - Hier wird als App-Intention das angucken/öffnen von .homework-Dateien definiert
- `android/app/src/main/kotlin/MainActivity.kt`: 
  - Hier wird die Intention aufgefangen. Anschließend wird die Methode handleSharedData über einen MethodChannel aufgerufen und der Dateiinhalt als Parameter übergeben
- `lib/utilities/homework_sharing_manager.dart`:
  - handleSharedData(): Hier wird der MethodCallHandler gesetzt und bei dem Call "importHomework" die zugehörige Methode aufgerufen
  - importHomework(): Hier wird der Inhalt in einen HomeWorkEntry extrahiert und ein ImportDialog damit geöffnet
    