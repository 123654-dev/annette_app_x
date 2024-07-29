import 'package:annette_app_x/providers/timetable_provider.dart';
import 'package:annette_app_x/screens/onboarding/app_config.dart';
import 'package:annette_app_x/widgets/request_error.dart';
import 'package:annette_app_x/widgets/timetable/holiday_indicator.dart';
import 'package:annette_app_x/widgets/timetable/timetable.dart';
import 'package:annette_app_x/widgets/timetable/weekday_selector.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: TimetableProvider.getCurrentHoliday(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Expanded(child: widgetWhileLoading(context, "Lade..."));
          } else if (snapshot.hasError) {
            return const BadRequestError();
          }
          if (snapshot.data == "###") {
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
          } else {
            return Expanded(
                child: HolidayIndicator(holiday: snapshot.data.toString()));
          }
        });
  }
}
