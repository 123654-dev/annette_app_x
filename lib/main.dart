import 'package:annette_app_x/consts/default_color_schemes.dart';
import 'package:annette_app_x/models/theme_mode.dart';
import 'package:annette_app_x/providers/user_config.dart';
import 'package:annette_app_x/utilities/on_init_app.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  //Initiate pre-app initialization
  await AppInitializer.init();

  //Then run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //application root widget
  @override
  Widget build(BuildContext context) {
    //pre-initialize home page
    var home = const MyHomePage(title: 'Annette App X');

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
            title: 'Annette App X',
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

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
