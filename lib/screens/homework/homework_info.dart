import 'package:annette_app_x/models/homework_entry.dart';
import 'package:annette_app_x/utilities/homework_manager.dart';
import 'package:annette_app_x/utilities/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomeworkInfo {
  static void show(BuildContext context, HomeworkEntry entry) {
    initializeDateFormatting("de_DE", null);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => Wrap(children: [
              HomeworkInfoWidget(
                entry: entry,
              )
            ]));
  }
}

class HomeworkInfoWidget extends StatefulWidget {
  final HomeworkEntry entry;
  HomeworkInfoWidget({super.key, required this.entry});

  bool showDefault = true;

  @override
  State<HomeworkInfoWidget> createState() => _HomeworkInfoWidgetState();
}

class _HomeworkInfoWidgetState extends State<HomeworkInfoWidget> {
  final TextEditingController _controller = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 16, minute: 30);

  DateTime _selectedDateR = DateTime.now();
  TimeOfDay _selectedTimeR = const TimeOfDay(hour: 16, minute: 30);

  @override
  void initState() {
    super.initState();
    if (widget.showDefault) {
      _selectedDateR = widget.entry.reminderDateTime ?? DateTime.now();
      _selectedDate = widget.entry.dueDate;

      _selectedTimeR = TimeOfDay.fromDateTime(
          widget.entry.reminderDateTime ?? DateTime.now());

      _selectedTime = TimeOfDay.fromDateTime(widget.entry.dueDate);
      _controller.text = widget.entry.notes;
      widget.showDefault = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      //Listenansicht für alle Widgets
      child: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 5),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              "Hausaufgabe bearbeiten",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
              padding: const EdgeInsets.all(20.0),

              //Textfeld für neue Anmerkungen
              child: TextField(
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "${widget.entry.subject}-Hausaufgabe"),
                maxLines: 5,
                minLines: 1,
                controller: _controller,
                focusNode: FocusNode(),
                style: const TextStyle(
                  fontSize: 14,
                ),
                cursorColor: Theme.of(context).primaryColor,
              )),
          const Text(
            "Fällig:",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              SizedBox(
                height: 60,
                width: 190,
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
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 365))) ??
                          DateTime.now();
                      setState(() {
                        _selectedDate = DateTime(date.year, date.month,
                            date.day, _selectedTime.hour, _selectedTime.minute);
                      });
                    },
                    icon: PhosphorIcon(PhosphorIcons.duotone.calendarX)),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 60,
                width: 190,
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
          const SizedBox(height: 20),
          //Datum und Uhrzeit (2x)
          const Text(
            "Erinnerung:",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          Column(
            children: [
              SizedBox(
                height: 60,
                width: 190,
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
                        _selectedDateR = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            _selectedTimeR.hour,
                            _selectedTimeR.minute);
                      });
                    },
                    icon: PhosphorIcon(PhosphorIcons.duotone.bellRinging)),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 60,
                width: 190,
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
              ),
              const SizedBox(height: 20),
              FilledButton.tonalIcon(
                  onPressed: () {
                    setState(() {
                      _selectedDateR =
                          DateTime.now().add(const Duration(minutes: 60));
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
                        _selectedDateR =
                            _selectedDateR.add(const Duration(days: 1));
                      }
                    });
                  },
                  icon: PhosphorIcon(PhosphorIcons.duotone.alarm),
                  label: const Text("Am Nachmittag")),
              const SizedBox(height: 20),
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
                            HomeworkManager.doesHomeworkEntryExist(widget.entry)
                                ? widget.entry
                                : await HomeworkManager.addEmptyHomeworkEntry(),
                            HomeworkEntry(
                                id: widget.entry.id,
                                done: widget.entry.done,
                                lastUpdated: DateTime.now(),
                                dueDate: _selectedDate,
                                subject: widget.entry.subject,
                                notes: _controller.text,
                                reminderDateTime: _selectedDateR));
                        Navigator.of(context).pop();
                      },
                      child: const Text("Speichern"),
                    )),
              ]),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
