import 'dart:convert';

import 'package:annette_app_x/models/class_ids.dart';
import 'package:annette_app_x/providers/api/api_provider.dart';
import 'package:annette_app_x/providers/connection.dart';
import 'package:annette_app_x/providers/user_settings.dart';
import 'package:annette_app_x/widgets/no_signal_error.dart';
import 'package:annette_app_x/widgets/request_error.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

const Map<int, String> weekdayName = {
  1: "Mo",
  2: "Di",
  3: "Mi",
  4: "Do",
  5: "Fr",
  6: "Sa",
  7: "So"
};

//SetClass V3 ;)
class AppConfigScreen extends StatefulWidget {
  const AppConfigScreen({super.key});

  @override
  State<AppConfigScreen> createState() => _AppConfigScreenState();
}

class _AppConfigScreenState extends State<AppConfigScreen> {
  bool _hasClassesResponseYet = false;
  bool _hasOptionsResponseYet = false;
  bool _hasError = false;

  late var _classes = [];
  late var _options;

  late Future<String> _currentFuture;

  late var _selectedClass = _classes[0];

  bool _secondStep = false;

//TODO: Type erstellen
  Map<String, dynamic> _selectedOptions = new Map();

  @override
  void initState() {
    _currentFuture = ApiProvider.fetchClasses();

    super.initState();
  }

  /*
  1. Internetverbindung checken
    a. falls keine Internetverbindung: Fehler anzeigen
    b. falls Internetverbindung: weiter zu 2.
  2. Request schicken
    a. falls Request fehlschlägt: Fehler anzeigen
    b. falls Request erfolgreich: weiter zu 3.
  3. Daten anzeigen
  */

  var widgetWhileLoading = (context, String? toast) =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(toast ?? "Lade..."),
        const SizedBox(height: 10),
        SizedBox(
          width: 100,
          height: 2,
          child: LinearProgressIndicator(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 10),
      ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Konfiguration"),
      ),
      body: !ConnectionProvider.hasConnection()
          ? NoSignalError(onPressed: () {
              setState(() {});
            })
          : Column(
              children: [
                Expanded(
                  child: FutureBuilder(
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Center(
                            child: ConnectionProvider.hasConnection()
                                ? BadRequestError(onPressed: () {
                                    setState(() {
                                      _hasError = false;
                                      _secondStep
                                          ? loadOptions()
                                          : reloadClasses();
                                    });
                                  })
                                : NoSignalError(onPressed: () {
                                    setState(() {
                                      _hasError = false;
                                      _secondStep
                                          ? loadOptions()
                                          : reloadClasses();
                                    });
                                  }),
                          );
                        } else {
                          //Für Schritt 1 (Auswahl der Klasse)
                          if (!_secondStep) {
                            _classes = jsonDecode(snapshot.data.toString());
                            return Center(
                              child: ListWheelScrollView(
                                useMagnifier: true,
                                magnification: 2,
                                perspective: 0.01,
                                squeeze: 0.7,
                                physics: const FixedExtentScrollPhysics(),
                                itemExtent: 50,
                                onSelectedItemChanged: (value) => setState(() {
                                  _selectedClass = _classes[value];
                                  print(_selectedClass);
                                }),
                                children: _classes.map((e) => Text(e)).toList(),
                              ),
                            );
                          } else {
                            //Wir sind bei Schritt 2 (Auswahl der Kurse)

                            //Da wir für die Unterstufe ein leicht abgeändertes
                            //Format benutzen, um bei parallelen Diff- oder Relikursen
                            //die Kurse zu unterscheiden, müssen wir hier zwei unterschiedliche UIs anzeigen.
                            //Dieses ist für die Oberstufe.
                            if (_selectedClass == "EF" ||
                                _selectedClass == "Q1" ||
                                _selectedClass == "Q2") {
                              _options =
                                  jsonDecode(snapshot.data.toString()) as List;
                              print(_options);
                              return Center(
                                  child: ListView(
                                children: [
                                  for (var block in _options)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(block["block_title"] as String),
                                        DropdownButton(
                                            //Inhalt der Map unter dem Wert von block["block_title"] (z.B. GK-Schiene 1)
                                            value: _selectedOptions[
                                                block["block_title"] as String],
                                            hint: const Text("Kurs auswählen"),
                                            items: (block["lessons"]
                                                    as List<dynamic>)
                                                .map((e) {
                                              return DropdownMenuItem(
                                                value: e["name"],
                                                child: Text(e["name"]),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedOptions[
                                                        block["block_title"]] =
                                                    value;
                                                print(value);
                                                print(_selectedOptions);
                                              });
                                            }),
                                      ],
                                    )
                                ],
                              ));
                            } else {
                              /* ------
                              Für die UNTERSTUFE.
                              ------ */

                              _options =
                                  jsonDecode(snapshot.data.toString()) as List;

                              Map<String, String> roomInfo = {};

                              for (var block in _options) {
                                var lessons = block["lessons"] as List<dynamic>;
                                var lessonNames = lessons
                                    .map((e) => e["name"] as String)
                                    .toList();
                                var uniqueLessonNames = lessonNames.toSet();

                                if (uniqueLessonNames.length !=
                                    lessonNames.length) {
                                  for (var lessonName in uniqueLessonNames) {
                                    var lessonsWithSameName = lessons
                                        .where((element) =>
                                            element["name"] == lessonName)
                                        .toList();

                                    if (lessonsWithSameName.length > 1) {
                                      var index = 1;
                                      for (var lesson in lessonsWithSameName) {
                                        lesson["name"] =
                                            "${lesson["name"]} $index";
                                        roomInfo[
                                            block["block_title"]] = (roomInfo[
                                                    block["block_title"]] ??
                                                "Mehrere Kurse erkannt.\nInformationen zur Unterscheidung:\n") +
                                            "${lesson["name"]}: ${weekdayName[lesson["day"]]} in ${lesson["room"]}\n";
                                        index++;
                                      }
                                    }
                                  }
                                }
                              }

                              return Center(
                                  child: ListView(
                                children: [
                                  for (var block in _options)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(block["block_title"] as String),
                                        DropdownButton(
                                            //Inhalt der Map unter dem Wert von block["block_title"] (z.B. GK-Schiene 1)
                                            value: _selectedOptions[
                                                block["block_title"] as String],
                                            hint: const Text("Kurs auswählen"),
                                            items: (block["lessons"]
                                                    as List<dynamic>)
                                                .map((e) {
                                              return DropdownMenuItem(
                                                value: e["name"],
                                                child: Text(e["name"]),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedOptions[
                                                        block["block_title"]] =
                                                    value;
                                                print(value);
                                                print(_selectedOptions);
                                              });
                                            }),
                                        if (roomInfo.containsKey(
                                            block["block_title"] as String))
                                          Tooltip(
                                            triggerMode: TooltipTriggerMode.tap,
                                            showDuration:
                                                const Duration(seconds: 20),
                                            message:
                                                roomInfo[block["block_title"]]!,
                                            child: PhosphorIcon(
                                              PhosphorIcons
                                                  .duotone.sealQuestion,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                      ],
                                    )
                                ],
                              ));
                            }
                          }
                        }
                      } else {
                        return Center(
                          child: widgetWhileLoading(
                              context,
                              _secondStep
                                  ? "Wir ermitteln deine Kurse..."
                                  : "Lade Klassen..."),
                        );
                      }
                    },
                    future: _currentFuture,
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: FilledButton(
                    child: Text("Weiter"),
                    onPressed: () {
                      if (!_secondStep) {
                        loadOptions();
                      } else {
                        submitSelectedOptions();
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: TextButton(
                      child: const Text("Zurück"),
                      onPressed: () {
                        if (!_secondStep) {
                          Navigator.pop(context);
                        } else {
                          setState(() {
                            _secondStep = false;
                          });
                          reloadClasses();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void submitSelectedOptions() {
    if (_selectedOptions.containsValue(null)) {
      //show snack bar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Bitte wähle für jeden Block eine Option aus!"),
        ),
      );
      return;
    }

    List opt = [];

    _selectedOptions.forEach((key, value) {
      var option =
          _options.firstWhere((element) => element["block_title"] == key);
      var sel =
          option["lessons"].firstWhere((element) => element["name"] == value);
      var obj = {
        "block_title": key,
        "selection": [
          {"name": sel["name"], "id": sel["internal_id"]}
        ]
      };

      opt.add(obj);
    });

    UserSettings.classId = ClassId.values.firstWhere(
      (element) =>
          element.fmtName.toUpperCase() == _selectedClass.toUpperCase(),
    );
    print(UserSettings.classId);

    UserSettings.selectedSubjects = opt;
    UserSettings.subjectLastClassId = _selectedClass;
    UserSettings.shouldPerformOnboarding = false;
    print("Great! Options saved.");

    Navigator.of(context).pushNamedAndRemoveUntil("/home", (r) => false);

    setState(() {});
  }

  void reloadClasses() {
    setState(() {
      _hasClassesResponseYet = false;
      _currentFuture = ApiProvider.fetchClasses();
    });
  }

  void loadOptions() {
    if (UserSettings.subjectLastClassId == _selectedClass) {
      print("Preparing previous selection...");
      var previousSelection = UserSettings.selectedSubjects;
      if (previousSelection.isNotEmpty) {
        previousSelection.forEach((element) {
          _selectedOptions[element["block_title"]] =
              element["selection"][0]["name"];
          print(element["selection"][0]["name"]);
        });
      }
    } else {
      _selectedOptions = {};
    }

    setState(() {
      _secondStep = true;
      _hasOptionsResponseYet = false;
      _currentFuture = ApiProvider.fetchChoiceOptions(_selectedClass);
    });
  }
}
