import 'package:annette_app_x/providers/api/files_provider.dart';
import 'package:annette_app_x/providers/timetable_provider.dart';
import 'package:annette_app_x/screens/onboarding/app_config.dart';
import 'package:annette_app_x/widgets/no_signal_error.dart';
import 'package:annette_app_x/widgets/request_error.dart';
import 'package:annette_app_x/widgets/timetable/timetable.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

final List<String> weekdays = [
  "Sonntag",
  "Montag",
  "Dienstag",
  "Mittwoch",
  "Donnerstag",
  "Freitag",
  "Samstag"
];

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  int _weekday = TimetableProvider.nextSchoolday();
  bool showWebView = false;

  @override
  Widget build(BuildContext context) {
    return showWebView
        ? FutureBuilder(
            future: FilesProvider.fetchTimetable(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return NoSignalError(
                  onPressed: () => setState(() {}),
                );
              }
              if (snapshot.hasData) {
                return WebViewWidget(
                  controller: WebViewController()
                    ..setJavaScriptMode(JavaScriptMode.disabled)
                    ..setNavigationDelegate(NavigationDelegate(
                      onUrlChange: (change) => NavigationDecision.prevent,
                    ))
                    ..loadFile(snapshot.data!),
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return widgetWhileLoading(context, "Lade Stundenplan");
              } else {
                return widgetWhileLoading(context, "Lade Stundenplan");
              }
            },
          )
        : FutureBuilder(
            future: TimetableProvider.getTimetable(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return widgetWhileLoading(context, "Lade Stundenplan");
              } else if (snapshot.hasError) {
                return const BadRequestError();
              }

              return Center(
                child: Container(
                  margin: const EdgeInsets.only(left: 25, right: 25, top: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                              child: OutlinedButton(
                                  onPressed: () => {},
                                  child: const Text("Heute"))),
                          const SizedBox(width: 10),
                          Expanded(
                              child: OutlinedButton(
                                  onPressed: () => {
                                        setState(() {
                                          showWebView = true;
                                        })
                                      },
                                  child: const Text("Gesamt")))
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.05),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.all(7),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () => setState(() {
                                        _weekday--;
                                        if (_weekday < 1) _weekday = 5;
                                      }),
                                  icon: PhosphorIcon(
                                      PhosphorIcons.duotone.caretLeft,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    weekdays[_weekday],
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () => setState(() {
                                        _weekday++;
                                        if (_weekday > 5) _weekday = 1;
                                      }),
                                  icon: PhosphorIcon(
                                      PhosphorIcons.duotone.caretRight,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                            ],
                          )),
                      const SizedBox(height: 10),
                      Timetable(weekday: _weekday),
                    ],
                  ),
                ),
              );
            });
  }
}
