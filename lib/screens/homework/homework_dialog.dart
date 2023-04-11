import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeworkDialog {
  static void show(BuildContext context,
      {bool? editOnly = false, required Function() onClose}) {
    var errors = {
      "subject": false,
      "notes": false,
      "dueDate": false,
    };

    var subjects = ["Test", "Test2", "Test3"];
    var selectedSubject = subjects[0];

    //Der Dialog wird mit showDialog() erzeugt
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            height: 500,
            width: 300,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  (editOnly ?? false
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
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Fach",
                      errorText: errors["subject"]!
                          ? "Feld darf nicht leer sein"
                          : null,
                    ),
                    items: List.generate(
                        subjects.length,
                        (index) => DropdownMenuItem(
                            value: subjects[index],
                            child: Text(subjects[index]))),
                    onChanged: (value) {
                      selectedSubject = value.toString();
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Anmerkungen",
                      errorText:
                          errors["notes"]! ? "Feld darf nicht leer sein" : null,
                    ),
                  ),
                  Row(
                    children: [
                      const Text("Fällig: "),
                      const SizedBox(width: 20),
                      SegmentedButton(
                        segments: const [
                          ButtonSegment(
                              value: <String>{"Automatisch"},
                              label: Text("Automatisch")),
                          ButtonSegment(
                              value: <String>{"Manuell"},
                              label: Text("Manuell")),
                        ],
                        selected: const <String>{"Automatisch"},
                      )
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      onClose();
                      Navigator.of(context).pop();
                    },
                    child: const Text("Speichern"),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
