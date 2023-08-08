import 'dart:convert';

import 'package:annette_app_x/models/class_ids.dart';
import 'package:annette_app_x/providers/api/api_provider.dart';
import 'package:annette_app_x/providers/connection.dart';
import 'package:annette_app_x/providers/user_config.dart';
import 'package:annette_app_x/widgets/no_signal_error.dart';
import 'package:annette_app_x/widgets/request_error.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

//TODO für morgen: FutureBuilder verschieben, zweiten Builder für die Optionen implementieren!

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
                            child: BadRequestError(onPressed: () {
                              setState(() {
                                _hasError = false;
                                _secondStep ? loadOptions() : reloadClasses();
                              });
                            }),
                          );
                        } else {
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
                            _options =
                                jsonDecode(snapshot.data.toString()) as List;
                            if (_selectedClass == "EF" ||
                                _selectedClass == "Q1" ||
                                _selectedClass == "Q2") {
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
                              return Center(
                                child: Text("Opfer lol"),
                              );
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
                        submitSelectedClass();
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

  void submitSelectedClass() {
    UserConfig.classId = ClassId.values.firstWhere(
      (element) => element.name.toUpperCase() == _selectedClass.toUpperCase(),
    );
    print(UserConfig.classId);
  }

  void submitSelectedOptions() {
    setState(() {});
  }

  void reloadClasses() {
    setState(() {
      _hasClassesResponseYet = false;
      _currentFuture = ApiProvider.fetchClasses();
    });
  }

  void loadOptions() {
    setState(() {
      _secondStep = true;
      _hasOptionsResponseYet = false;
      _currentFuture = ApiProvider.fetchChoiceOptions(_selectedClass);
    });
  }
}
