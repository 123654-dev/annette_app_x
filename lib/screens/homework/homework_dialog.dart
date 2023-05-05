import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomeworkDialog {
  static void show(BuildContext context,
      {bool? editOnly = false,
      required Function(
              {required String subject,
              required String annotations,
              required bool autoRemind,
              required DateTime remindDT})
          onClose}) {
    var subjects = ["Test", "Test2", "Test3"];
    var selectedSubject = subjects[0];

    //Der Dialog wird mit showDialog() erzeugt
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) =>
          _dialogSheet(editOnly: false, subjects: subjects, onClose: onClose),
    );
  }
}

class _dialogSheet extends StatefulWidget {
  bool editOnly;
  List<String> subjects;
  Function(
      {required String subject,
      required String annotations,
      required bool autoRemind,
      required DateTime remindDT}) onClose;

  _dialogSheet(
      {Key? key,
      required this.editOnly,
      required this.subjects,
      required this.onClose})
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
  TimeOfDay _selectedTime = TimeOfDay(hour: 16, minute: 30);

  ScrollController _scrollController = ScrollController();

  void _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.decelerate,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_autoRemind) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
    }
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: 500,
        width: 300,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              controller: _scrollController,
              children: [
                (widget.editOnly
                    ? const Text(
                        "Hausaufgabe bearbeiten",
                        style: TextStyle(fontSize: 20),
                      )
                    : const Text(
                        "Neue Hausaufgabe",
                        style: TextStyle(fontSize: 20),
                      )),
                const SizedBox(height: 20),
                DropdownButtonFormField(
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
                ),
                const SizedBox(height: 20),
                TextFormField(
                  onChanged: (value) => _annotations = value,
                  maxLines: 5,
                  validator: (value) => value == null || value.isEmpty
                      ? "Feld darf nicht leer sein"
                      : null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Anmerkungen",
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                    child: Row(
                  children: [
                    const Text(
                      "Automatisch erinnern",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 10),
                    Checkbox(
                        value: _autoRemind,
                        onChanged: (value) {
                          setState(() {
                            _autoRemind = value!;
                          });
                        })
                  ],
                )),
                const SizedBox(height: 10),
                if (!_autoRemind)
                  Column(
                    children: [
                      SizedBox(
                        height: 60,
                        width: 190,
                        child: FilledButton.icon(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).colorScheme.tertiary),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                            ),
                            //Label: Date only
                            label: Text(
                                "${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}"),
                            onPressed: () async {
                              var date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now()
                                          .add(const Duration(days: 365))) ??
                                  DateTime.now();
                              setState(() {
                                _selectedDate = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    _selectedTime.hour,
                                    _selectedTime.minute);
                              });
                            },
                            icon:
                                PhosphorIcon(PhosphorIcons.duotone.calendarX)),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 60,
                        width: 190,
                        child: FilledButton.icon(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).colorScheme.tertiary),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                            ),
                            //Label: Date only
                            label: Text(
                                "${_selectedTime.hour}:${_selectedTime.minute}"),
                            onPressed: () async {
                              var time = await showTimePicker(
                                  context: context,
                                  initialTime:
                                      const TimeOfDay(hour: 16, minute: 0));

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
                            icon: PhosphorIcon(
                                PhosphorIcons.duotone.clockAfternoon)),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                SizedBox(
                    width: 200,
                    height: 80,
                    child: FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.onClose(
                            subject: _selectedSubject,
                            annotations: _annotations,
                            autoRemind: _autoRemind,
                            remindDT: _selectedDate,
                          );
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text("Speichern"),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
