import 'dart:math';

import 'package:annette_app_x/providers/timetable_provider.dart';
import 'package:annette_app_x/utilities/navigation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../providers/user_settings.dart';

class HomeworkDialog {
  static void show(
      {BuildContext? context,
      bool? editOnly = false,
      required Function({
        required int id,
        required String subject,
        required String annotations,
        required bool autoRemind,
        required DateTime remindDT,
      }) onClose}) {
    var subjects = UserSettings.subjectNames;

    context ??= NavigationService.navigatorKey.currentContext!;

    //Der Dialog wird mit showDialog() erzeugt
    showModalBottomSheet(
      constraints: BoxConstraints.expand(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 1.5),
      isScrollControlled: true,
      context: context,
      builder: (context) => _dialogSheet(subjects: subjects, onClose: onClose),
    );
  }
}

class _dialogSheet extends StatefulWidget {
  List<String> subjects;
  Function(
      {required int id,
      required String subject,
      required String annotations,
      required bool autoRemind,
      required DateTime remindDT}) onClose;

  _dialogSheet({Key? key, required this.subjects, required this.onClose})
      : super(key: key);

  @override
  _dialogSheetState createState() => _dialogSheetState();
}

class _dialogSheetState extends State<_dialogSheet> {
  String _selectedSubject = "";
  String _annotations = "";
  final _formKey = GlobalKey<FormState>();

  //Soll der Erinnerungszeitpunkt automatisch gewählt werden?
  bool _autoRemind = true;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 16, minute: 30);

  final ScrollController _scrollController = ScrollController();

  void _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.decelerate,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void initState() {
    _selectedSubject = widget.subjects.firstWhere(
      (element) => element == TimetableProvider.getCurrentSubjectAsString(),
      orElse: () => widget.subjects.first,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting("de_DE", null);

    if (!_autoRemind) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
    }
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: 500,
        width: 300,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              controller: _scrollController,
              children: [
                const Text(
                  "Neue Hausaufgabe",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                subjectDropDownMenu(),
                const SizedBox(height: 20),
                notesTextField(),
                const SizedBox(height: 30),
                Center(
                    child: Wrap(
                  children: [
                    autoDueCheckbox(),
                  ],
                )),
                const SizedBox(height: 10),
                if (!_autoRemind)
                  Column(
                    children: [
                      SizedBox(
                        height: 60,
                        width: 150,
                        child: dueDayPickerButton(),
                      ),
                      const SizedBox(height: 10, width: 10),
                      SizedBox(
                        height: 60,
                        width: 150,
                        child: dueTimePickerButton(),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                SizedBox(width: 200, height: 50, child: saveButton())
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget subjectDropDownMenu() {
    return DropdownButtonFormField(
        validator: (value) {
          return value == null ? "Feld darf nicht leer sein" : null;
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Fach",
        ),
        items: List.generate(
            widget.subjects.length,
            (index) => DropdownMenuItem(
                value: widget.subjects[index],
                child: Text(widget.subjects[index]))),
        onChanged: (value) {
          _selectedSubject = value.toString();
        },
        value: _selectedSubject);
  }

  Widget notesTextField() {
    return TextFormField(
      onChanged: (value) => _annotations = value,
      maxLines: 5,
      validator: (value) =>
          value == null || value.isEmpty ? "Feld darf nicht leer sein" : null,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Anmerkungen",
      ),
    );
  }

  Widget autoDueCheckbox() {
    return CheckboxListTile(
      title: GestureDetector(
        onTap: () => setState(() {
          _autoRemind = !_autoRemind;
        }),
        child: const Text(
          "Automatisches Fälligkeitsdatum",
          textAlign: TextAlign.start,
        ),
      ),
      value: _autoRemind,
      onChanged: (value) {
        setState(() {
          _autoRemind = value!;
        });
      },
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }

  Widget dueDayPickerButton() {
    return FilledButton.icon(
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
                  lastDate: DateTime.now().add(const Duration(days: 365))) ??
              DateTime.now();
          setState(() {
            _selectedDate = DateTime(date.year, date.month, date.day,
                _selectedTime.hour, _selectedTime.minute);
          });
        },
        icon: PhosphorIcon(PhosphorIcons.duotone.calendarX));
  }

  Widget dueTimePickerButton() {
    return FilledButton.icon(
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
            initialTime: const TimeOfDay(hour: 16, minute: 0),
          );

          setState(() {
            _selectedTime = time!;
            _selectedDate = DateTime(_selectedDate.year, _selectedDate.month,
                _selectedDate.day, _selectedTime.hour, _selectedTime.minute);
          });
        },
        icon: PhosphorIcon(PhosphorIcons.duotone.clockAfternoon));
  }

  Widget saveButton() {
    return FilledButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          widget.onClose(
            id: Random().nextInt(1000000),
            subject: _selectedSubject,
            annotations: _annotations,
            autoRemind: _autoRemind,
            remindDT: _selectedDate,
          );
          Navigator.of(context).pop();
        }
      },
      child: const Text("Speichern"),
    );
  }
}
