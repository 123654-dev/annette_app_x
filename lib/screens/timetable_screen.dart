import 'package:annette_app_x/providers/timetable_provider.dart';
import 'package:flutter/material.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          FilledButton.tonal(
            onPressed: () {
              TimetableProvider.getTimetable();
            },
            child: const Text("Load Timetable"),
          ),
          FilledButton.tonal(
            onPressed: () {
              print(TimetableProvider.getCurrentSubjectAsString());
            },
            child: const Text("Get Current Subject"),
          ),
        ],
      ),
    );
  }
}
