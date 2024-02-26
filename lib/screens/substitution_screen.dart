import 'package:annette_app_x/models/class_ids.dart';
import 'package:annette_app_x/models/substitution.dart';
import 'package:annette_app_x/models/substitution_day.dart';
import 'package:annette_app_x/providers/api/api_provider.dart';
import 'package:annette_app_x/providers/api/substitution_provider.dart';
import 'package:annette_app_x/providers/timetable_provider.dart';
import 'package:annette_app_x/providers/user_settings.dart';
import 'package:annette_app_x/screens/onboarding/app_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class SubstitutionScreen extends StatefulWidget {
  const SubstitutionScreen({Key? key}) : super(key: key);

  @override
  State<SubstitutionScreen> createState() => _SubstitutionScreenState();
}

class _SubstitutionScreenState extends State<SubstitutionScreen> {
  Future<List<SubstitutionDay>> futureSubsts = Future.wait([
      SubstitutionProvider.getSubstitutionDayTodayOrTomorrow(true),
      SubstitutionProvider.getSubstitutionDayTodayOrTomorrow(false)
    ]);
  Future<void> _refreshSubst() async {
    setState(() {
      print("Substitution refreshed");
      futureSubsts = Future.wait([
        SubstitutionProvider.getSubstitutionDayTodayOrTomorrow(true, forceReload: true),
        SubstitutionProvider.getSubstitutionDayTodayOrTomorrow(false, forceReload: true)
      ]);
    });
  }
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting("de_DE", null);

    return FutureBuilder<List<SubstitutionDay>>(
        future: futureSubsts,
        builder: (context, snapshot) {
          final List<SubstitutionDay> substitutions = snapshot.data ?? [];
          List<Widget> substWidgets = [];
          if (substitutions.isEmpty) {
            var emptySubst = SubstitutionDay.empty(date: TimetableProvider.nextSchoolDayTime());
            substitutions.add(emptySubst);
            emptySubst = SubstitutionDay.empty(date: TimetableProvider.nthNextSchoolDayDateTime(1));
            substitutions.add(emptySubst);
          }
          for (var subst in substitutions) {
            bool isTodayOrTomorrow = subst.date.isBefore(
                TimetableProvider.nthNextSchoolDayDateTime(2));
            if ((subst.isEmpty && !isTodayOrTomorrow)) {
              substWidgets.add(const SizedBox.shrink());
              continue;
            }
            substWidgets.add(SubstitutionDayEntry(substDay: subst));
          }
          return RefreshIndicator(
            onRefresh: _refreshSubst,
            child: Column(children: [
              const Text("Vertretungsplan", style: TextStyle(fontSize: 20)),
              snapshot.connectionState == ConnectionState.waiting
                  ? widgetWhileLoading(context, "Lade Vertretungsplan")
                  : Expanded(
                      child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: substWidgets))
            ]),
          );   
        });
  }
}

class SubstitutionDayEntry extends StatelessWidget {
  final SubstitutionDay substDay;

  const SubstitutionDayEntry({super.key, required this.substDay});

  @override
  Widget build(BuildContext context) {
    final String weekday = DateFormat('EEEE', 'de_DE').format(substDay.date);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Text("$weekday --- ${substDay.date.day}.${substDay.date.month}",
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      ),
      if (substDay.motd.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(substDay.motd,
              style:
                  const TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
        ),
      substDay.substCount == 0
          ? const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text("Keine Vertretungen", style: TextStyle(fontSize: 20)),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: substDay.substCount,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(substDay.substitutions[index].subject),
                    subtitle: substDay.substitutions[index].lastsSeveralHours()
                        ? Text(
                            "${substDay.substitutions[index].startLesson}-${substDay.substitutions[index].endLesson}. Stunde")
                        : Text(
                            "${substDay.substitutions[index].startLesson}. Stunde"),
                    trailing: Text(substDay.substitutions[index].room),
                  ),
                );
              },
            ),
    ]);
  }
}
