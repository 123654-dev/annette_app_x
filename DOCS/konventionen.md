# Projektaufbau

## Ordnerstruktur

- `DOCS` - Dokumentation
- `DOCS\diagramm.md` - Klassendiagramm

- `lib/`

  - `api`: Externe Skripte, die die App mit anderen Providern verbinden, z.B. mit der WebUntis-API oder der Annette-Dateien-API.

  - `consts`: Konstanten und Konfigurationsdateien.

  - `models`: Datenmodelle, etwa global verwendete Enums, die in mehr als einer Klasse genutzt werden.

  - `providers`: Datenprovider, die die App mit anderen Diensten auf dem Handy verknüpfen, etwa Speicher, Kalender, Benachrichtigungen, Config usw.

  - `screens`: Alle Seiten und Ansichten der App, etwa die Startseite, die Einstellungen, die Stundenplanansicht, die Vertretungsansicht usw.

  - `utilities`: Hilfsfunktionen, die in extra Dateien ausgelagert werden, um bessere Übersicht zu gewährleisten, etwa on_init.dart

  - `widgets`: Wiederverwendbare Widgets, die in mehreren Screens genutzt werden sollen oder komplexer sind als ein Container, z.B. Vertretungs- oder Stundenplan-Widgets.

  - `main.dart`: Hauptdatei der App, die die App startet und die App-Struktur aufbaut.
