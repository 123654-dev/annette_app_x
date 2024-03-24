import 'package:annette_app_x/providers/api/files_provider.dart';
import 'package:annette_app_x/providers/timetable_provider.dart';
import 'package:annette_app_x/screens/onboarding/app_config.dart';
import 'package:annette_app_x/widgets/no_signal_error.dart';
import 'package:annette_app_x/widgets/request_error.dart';
import 'package:annette_app_x/widgets/timetable/timetable.dart';
import 'package:annette_app_x/widgets/timetable/weekday_selector.dart';
import 'package:flutter/material.dart';
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

class TimetableDay extends StatefulWidget {
  const TimetableDay({super.key});
  @override
  State<StatefulWidget> createState() => _TimetableDayState();
}

class _TimetableDayState extends State<TimetableDay> {
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
                      const SizedBox(height: 10),
                      WeekdaySelector(
                        onChange: (value) {
                          setState(
                            () {
                              _weekday = value;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.62,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Timetable(weekday: _weekday),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
