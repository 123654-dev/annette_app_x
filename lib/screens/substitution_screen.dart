import 'package:annette_app_x/models/class_ids.dart';
import 'package:annette_app_x/models/substitution.dart';
import 'package:annette_app_x/models/substitution_day.dart';
import 'package:annette_app_x/providers/api/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class SubstitutionScreen extends StatelessWidget {
  SubstitutionScreen({super.key}) {
    initializeDateFormatting("de_DE", null);
  }

  final SubstitutionDay substToday = SubstitutionDay(
      date: DateTime.now(),
      substitutions: ApiProvider.fetchSubstitutionDay(true, id),
      motd: "Heute ist ein schöner Tag!");

  final SubstitutionDay substTomorrow = SubstitutionDay(
      date: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day + 1),
      substitutions: [
        const Substitution(ClassId.c5A, "D", "Deutsch", 1, 2, "A101", ""),
        const Substitution(ClassId.c5A, "M", "Mathe", 3, 4, "A101", ""),
        const Substitution(ClassId.c5A, "E", "Englisch", 5, 6, "A101", "")
      ],
      motd: "Morgen ist auch ein schöner Tag!");

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("Vertretungsplan", style: TextStyle(fontSize: 20)),
      substToday.isEmpty && substTomorrow.isEmpty
          ? const Text("Keine Vertretungen")
          : Expanded(
              child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                  substToday.isEmpty
                      ? const SizedBox.shrink()
                      : SubstitutionDayEntry(substDay: substToday),
                  substTomorrow.isEmpty
                      ? const SizedBox.shrink()
                      : SubstitutionDayEntry(substDay: substTomorrow),
                ]))
    ]);
  }
}

class SubstitutionDayEntry extends StatelessWidget {
  final SubstitutionDay substDay;

  const SubstitutionDayEntry({super.key, required this.substDay});

  @override
  Widget build(BuildContext context) {
    final String weekday = DateFormat('EEEE', 'de_DE').format(substDay.date);

    return Column(children: [
      Text("$weekday --- ${substDay.date}",
          style: const TextStyle(fontSize: 20)),
      ListView.builder(
        shrinkWrap: true,
        itemCount: substDay.substCount,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(substDay.substitutions[index].subjectLong),
              subtitle: Text(
                  "${substDay.substitutions[index].startLesson}-${substDay.substitutions[index].endLesson}. Stunde"),
              trailing: Text(substDay.substitutions[index].room),
            ),
          );
        },
      ),
    ]);
  }
}
