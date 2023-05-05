import 'dart:async';

import 'package:annette_app_x/consts/default_color_schemes.dart';
import 'package:annette_app_x/models/theme_mode.dart';
import 'package:annette_app_x/providers/user_config.dart';
import 'package:annette_app_x/screens/exam_screen.dart';
import 'package:annette_app_x/screens/homework_screen.dart';
import 'package:annette_app_x/screens/misc_screen.dart';
import 'package:annette_app_x/screens/substitution_screen.dart';
import 'package:annette_app_x/screens/timetable_screen.dart';
import 'package:annette_app_x/utilities/homework_manager.dart';
import 'package:annette_app_x/utilities/on_init_app.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

Future<void> main() async {
  //Initialisierung der App in Gang setzen
  await AppInitializer.init();

  //ausführen
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //Der Anker der App
  @override
  Widget build(BuildContext context) {
    var home = const MyHomePage(title: 'Annette App X');

    /*

    Wenn der User den Material3-Modus aktiviert hat, erzeugt der DynamicColorBuilder
    ein auf der Systemfarbe basierendes Farbschema.

    Ansonsten wird die App mit den Standardschemata konstruiert (definiert in default_color_schemes.dart!)

    */

    return UserConfig.themeMode == AnnetteThemeMode.material3
        ? DynamicColorBuilder(
            builder: ((lightDynamic, darkDynamic) => MaterialApp(
                  title: 'Annette App X',
                  theme: ThemeData(
                      colorScheme:
                          lightDynamic ?? AnnetteColorSchemes.lightColorScheme,
                      useMaterial3: true),
                  darkTheme: ThemeData(
                      colorScheme:
                          darkDynamic ?? AnnetteColorSchemes.darkColorScheme,
                      useMaterial3: true),
                  home: home,
                  themeMode: ThemeMode.dark,
                )),
          )
        : MaterialApp(
            theme: ThemeData(
                colorScheme: AnnetteColorSchemes.lightColorScheme,
                useMaterial3: true),
            darkTheme: ThemeData(
                colorScheme: AnnetteColorSchemes.darkColorScheme,
                useMaterial3: true),
            home: home,
            themeMode: ThemeMode.dark,
          );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

///Enum für verschiedene Navigationsbuttons
///Wird verwendet, um die richtige Seite anzuzeigen
///!! Klausurplan nur für Oberstufe !!
enum _Destination {
  vertretung,
  stundenplan,
  has,
  sonstiges,
  klausurplan,
}

class _MyHomePageState extends State<MyHomePage> {
  _Destination _selectedDestination = _Destination.vertretung;

  //StreamSubscription für die Hausaufgaben, wird in initState() initialisiert
  late StreamSubscription<BoxEvent>? subscription;

  //Anzahl der Hausaufgaben
  int _homeworkCount = HomeworkManager.howManyPendingEntries();

  @override
  void initState() {
    subscription = Hive.box('homework').watch().listen((event) {
      setState(() {
        _homeworkCount = HomeworkManager.howManyPendingEntries();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Annette App X"),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) => setState(() {
          //sehr komischer Code, um den Klausurplan nur für Oberstufe anzuzeigen
          //NICHT ANFASSEN
          //ES FUNKTIONIERT OK?
          if (UserConfig.isOberstufe) {
            switch (value) {
              case 0:
                _selectedDestination = _Destination.vertretung;
                break;
              case 1:
                _selectedDestination = _Destination.stundenplan;
                break;
              case 2:
                _selectedDestination = _Destination.has;
                break;
              case 3:
                _selectedDestination = _Destination.sonstiges;
                break;
              case 4:
                _selectedDestination = _Destination.klausurplan;
                break;
            }
          } else {
            switch (value) {
              case 0:
                _selectedDestination = _Destination.vertretung;
                break;
              case 1:
                _selectedDestination = _Destination.stundenplan;
                break;
              case 2:
                _selectedDestination = _Destination.has;
                break;
              case 3:
                _selectedDestination = _Destination.sonstiges;
                break;
            }
          }
        }),
        selectedIndex: _selectedDestination.index,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: [
          NavigationDestination(
            icon: Badge(
              label: const Text("4"),
              child: PhosphorIcon(PhosphorIcons.duotone.rows,
                  color: Theme.of(context).colorScheme.onBackground),
            ),
            label: 'Vertretung',
          ),
          NavigationDestination(
            icon: PhosphorIcon(PhosphorIcons.duotone.calendar,
                color: Theme.of(context).colorScheme.onBackground),
            label: 'Stundenplan',
          ),
          NavigationDestination(
            icon: HomeworkManager.hasHomework()
                ? Badge(
                    label: Text((_homeworkCount).toString()),
                    child: PhosphorIcon(PhosphorIcons.duotone.checkFat,
                        color: Theme.of(context).colorScheme.onBackground))
                : PhosphorIcon(PhosphorIcons.duotone.smileyWink,
                    color: Theme.of(context).colorScheme.onBackground),
            label: 'HAs',
          ),

          /* Klausurplan nur für Oberstufe anzeigen */

          if (UserConfig.isOberstufe)
            NavigationDestination(
              icon: PhosphorIcon(PhosphorIcons.duotone.exam,
                  color: Theme.of(context).colorScheme.onBackground),
              label: 'Klausurplan',
            ),
          NavigationDestination(
            icon: PhosphorIcon(PhosphorIcons.duotone.dotsThreeOutline,
                color: Theme.of(context).colorScheme.onBackground),
            label: 'Sonstiges',
          ),
        ],
      ),
      body: <Widget>[
        Container(
          alignment: Alignment.center,
          child: const SubstitutionScreen(),
        ),
        Container(
          alignment: Alignment.center,
          child: const TimetableScreen(),
        ),
        Container(
          alignment: Alignment.center,
          child: HomeworkScreen(refresh: refresh),
        ),
        if (UserConfig.isOberstufe)
          Container(
            alignment: Alignment.center,
            child: const ExamScreen(),
          ),
        Container(
          alignment: Alignment.center,
          child: const MiscScreen(),
        ),
      ][_selectedDestination.index],
      floatingActionButton: FloatingActionButton(
        onPressed: () => HomeworkManager.showHomeworkDialog(refresh, context),
        child: PhosphorIcon(PhosphorIcons.duotone.listPlus,
            color: Theme.of(context).colorScheme.onBackground),
      ),
    );
  }

  ///Callback-Funktion, die die Seite neulädt, etwa bei neuen Vertretungen oder Hausaufgaben, die hinzugefügt wurden (-> Badges)
  void refresh() {
    setState(() {});
  }
}
