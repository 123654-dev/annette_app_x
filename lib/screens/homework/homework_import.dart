import 'dart:math';

import 'package:annette_app_x/models/homework_entry.dart';
import 'package:annette_app_x/providers/timetable_provider.dart';
import 'package:annette_app_x/providers/user_settings.dart';
import 'package:annette_app_x/utilities/homework_manager.dart';
import 'package:annette_app_x/utilities/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomeworkImport {
  static void show(HomeworkEntry entry) {
    initializeDateFormatting("de_DE", null);
    showModalBottomSheet(
        context: NavigationService.navigatorKey.currentContext!,
        isScrollControlled: true,
        builder: (context) => Wrap(children: [
              HomeworkImportWidget(
                entry: entry,
              )
            ]));
  }
}

class HomeworkImportWidget extends StatefulWidget {
  final HomeworkEntry entry;
  HomeworkImportWidget({super.key, required this.entry});

  bool showDefault = true;

  @override
  State<HomeworkImportWidget> createState() => _HomeworkImportWidgetState();
}

class _HomeworkImportWidgetState extends State<HomeworkImportWidget> {
  TextEditingController _controller = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay(hour: 16, minute: 30);

  DateTime _selectedDateR = DateTime.now();
  TimeOfDay _selectedTimeR = TimeOfDay(hour: 16, minute: 30);

  String _selectedSubject = "Sonstiges";

  @override
  void initState() {
    super.initState();
    if (widget.showDefault) {
      _selectedDate = widget.entry.dueDate;
      _selectedTime = TimeOfDay.fromDateTime(widget.entry.dueDate);

      _selectedDateR = widget.entry.reminderDateTime ?? DateTime.now();
      _selectedTimeR = TimeOfDay.fromDateTime(
          widget.entry.reminderDateTime ?? DateTime.now());

      _controller.text = widget.entry.notes;
      widget.showDefault = false;
    }

    _selectedSubject = UserSettings.subjectFullNames.firstWhere(
      (element) => element == widget.entry.subject,
      orElse: () => "Sonstiges",
    );
  }

  @override
  Widget build(BuildContext context) {
    print(UserSettings.subjectFullNames);
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      //Listenansicht für alle Widgets
      child: ListView(shrinkWrap: true, children: widgets()),
    );
  }

  List<Widget> widgets() {
    return headerWidgets() +
        subjectWidgets() +
        infoInputWidgets() +
        [
          Column(
              children: faelligWidgets() +
                  reminderTimeWidget() +
                  reminderShortcutButtons())
        ] +
        [const SizedBox(height: 10)] +
        closeButtons() +
        [const SizedBox(height: 20)];
  }

  List<Widget> headerWidgets() {
    return [
      const SizedBox(height: 5),
      const Padding(
        padding: EdgeInsets.all(12.0),
        child: Text(
          "Hausaufgabe importieren",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox(height: 5)
    ];
  }

  List<Widget> subjectWidgets() {
    return [
      DropdownButtonFormField(
          padding: const EdgeInsets.all(10.0),
          validator: (value) {
            return value == null ? "Feld darf nicht leer sein" : null;
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Fach",
          ),
          items: List.generate(
              UserSettings.subjectFullNames.length,
              (index) => DropdownMenuItem(
                  value: UserSettings.subjectFullNames[index],
                  child: Text(UserSettings.subjectFullNames[index]))),
          onChanged: (value) {
            setState(() {
              _selectedSubject = value.toString();
            });
          },
          value: _selectedSubject),
    ];
  }

  List<Widget> infoInputWidgets() {
    return [
      Padding(
          padding: const EdgeInsets.all(20.0),
          //Textfeld für neue Anmerkungen
          child: TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "Anmerkungen"),
            maxLines: 5,
            minLines: 2,
            controller: _controller,
            focusNode: FocusNode(),
            style: const TextStyle(
              fontSize: 14,
            ),
            cursorColor: Theme.of(context).primaryColor,
          ))
    ];
  }

  List<Widget> faelligWidgets() {
    return [
      const Text(
        "Fällig:",
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 15),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 60,
            width: 150,
            child: FilledButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.tertiary),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  )),
                ),
                //Label: Date only
                label: Text(
                    "${DateFormat.EEEE('de_DE').format(_selectedDate)}, ${DateFormat.yMd('de_DE').format(_selectedDate)}"),
                onPressed: () async {
                  var date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365))) ??
                      DateTime.now();
                  setState(() {
                    _selectedDate = DateTime(date.year, date.month, date.day,
                        _selectedTime.hour, _selectedTime.minute);
                  });
                },
                icon: PhosphorIcon(PhosphorIcons.duotone.calendarX)),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 60,
            width: 150,
            child: FilledButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.tertiary),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  )),
                ),
                //Label: Date only
                label: Text(DateFormat.Hm().format(_selectedDate)),
                onPressed: () async {
                  var time = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 16, minute: 0));

                  setState(() {
                    _selectedTime = time!;
                    _selectedDate = DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                        _selectedDate.day,
                        _selectedTime.hour,
                        _selectedTime.minute);
                  });
                },
                icon: PhosphorIcon(PhosphorIcons.duotone.clockAfternoon)),
          ),
        ],
      ),
      const SizedBox(height: 20)
    ];
  }

  List<Widget> reminderTimeWidget() {
    return [
      const Text(
        "Erinnerung:",
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 15),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
          height: 60,
          width: 150,
          child: FilledButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).colorScheme.tertiary),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                )),
              ),
              //Label: Date only
              label: Text(
                  "${DateFormat.EEEE('de_DE').format(_selectedDateR)}, ${DateFormat.yMd('de_DE').format(_selectedDateR)}"),
              onPressed: () async {
                var date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: _selectedDate) ??
                    DateTime.now();
                setState(() {
                  _selectedDateR = DateTime(date.year, date.month, date.day,
                      _selectedTimeR.hour, _selectedTimeR.minute);
                });
              },
              icon: PhosphorIcon(PhosphorIcons.duotone.bellRinging)),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 60,
          width: 150,
          child: FilledButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).colorScheme.tertiary),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                )),
              ),
              //Label: Date only
              label: Text(DateFormat.Hm().format(_selectedDateR)),
              onPressed: () async {
                var time = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 16, minute: 0));

                setState(() {
                  _selectedTimeR = time!;
                  _selectedDateR = DateTime(
                      _selectedDateR.year,
                      _selectedDateR.month,
                      _selectedDateR.day,
                      _selectedTimeR.hour,
                      _selectedTimeR.minute);
                });
              },
              icon: PhosphorIcon(PhosphorIcons.duotone.clockAfternoon)),
        )
      ])
    ];
  }

  List<Widget> reminderShortcutButtons() {
    return [
      const SizedBox(height: 20),
      FilledButton.tonalIcon(
          onPressed: () {
            setState(() {
              _selectedDateR = DateTime.now().add(const Duration(minutes: 60));
            });
          },
          icon: PhosphorIcon(PhosphorIcons.duotone.alarm),
          label: const Text("In einer Stunde")),
      const SizedBox(height: 10),
      FilledButton.tonalIcon(
          onPressed: () {
            setState(() {
              _selectedDateR = DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day, 16, 0);
              //If it's after 16:00, set the reminder to tomorrow
              if (DateTime.now().hour >= 16) {
                _selectedDateR = _selectedDateR.add(const Duration(days: 1));
              }
            });
          },
          icon: PhosphorIcon(PhosphorIcons.duotone.alarm),
          label: const Text("Am Nachmittag"))
    ];
  }

  List<Widget> closeButtons() {
    return [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
            width: 150,
            height: 40,
            child: OutlinedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.surface)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Abbrechen"),
            )),
        const SizedBox(width: 20),
        SizedBox(
            width: 150,
            height: 40,
            child: FilledButton(
              onPressed: () async {
                await HomeworkManager.editHomeworkEntry(
                    await HomeworkManager.addEmptyHomeworkEntry(),
                    HomeworkEntry(
                        id: Random().nextInt(1000000),
                        lastUpdated: DateTime.now(),
                        dueDate: _selectedDate,
                        subject: _selectedSubject,
                        notes: _controller.text,
                        reminderDateTime: _selectedDateR));
                Navigator.of(context).pop();
              },
              child: const Text("Speichern"),
            )),
      ])
    ];
  }
}
