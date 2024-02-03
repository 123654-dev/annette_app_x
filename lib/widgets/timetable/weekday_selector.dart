import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class WeekdaySelector extends StatefulWidget {
  WeekdaySelector({super.key, required this.onChange});

  Function(dynamic value) onChange;

  @override
  State<WeekdaySelector> createState() => _WeekdaySelectorState();
}

class _WeekdaySelectorState extends State<WeekdaySelector>
    with SingleTickerProviderStateMixin {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    if (_selectedDate.weekday == DateTime.saturday ||
        _selectedDate.weekday == DateTime.sunday) {
      _selectedDate = _getNextWeekday(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(5, (index) {
          final nextWeekday = _getNextWeekday(index);

          final isSelected = _selectedDate.weekday == nextWeekday.weekday;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = nextWeekday;
                widget.onChange(_selectedDate.weekday);
              });
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.onSurfaceVariant
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  Text(
                    _getWeekdayAbbreviation(nextWeekday.weekday),
                    style: TextStyle(
                      color: isSelected
                          ? Theme.of(context).colorScheme.surface
                          : Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${nextWeekday.day}.${nextWeekday.month}',
                    style: TextStyle(
                      color: isSelected
                          ? Theme.of(context).colorScheme.surface
                          : Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

DateTime _getNextWeekday(int index) {
  final currentDate = DateTime.now();

  switch (currentDate.weekday) {
    case DateTime.monday:
      return currentDate.add(Duration(days: index));
    case DateTime.tuesday:
      return currentDate.add(Duration(days: index + 6));
    case DateTime.wednesday:
      return currentDate.add(Duration(days: index + 5));
    case DateTime.thursday:
      return currentDate.add(Duration(days: index + 4));
    case DateTime.friday:
      return currentDate.add(Duration(days: index + 3));
    default:
      return currentDate;
  }
}

String _getWeekdayAbbreviation(int weekday) {
  switch (weekday) {
    case DateTime.monday:
      return 'Mo';
    case DateTime.tuesday:
      return 'Di';
    case DateTime.wednesday:
      return 'Mi';
    case DateTime.thursday:
      return 'Do';
    case DateTime.friday:
      return 'Fr';
    default:
      return '';
  }
}
