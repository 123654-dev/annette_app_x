import 'package:annette_app_x/models/homework_entry.dart';
import 'package:flutter/material.dart';

class HomeworkWidget extends StatefulWidget {
  final Function onChecked;
  final HomeworkEntry entry;

  const HomeworkWidget(
      {super.key, required this.entry, required this.onChecked});

  @override
  State<HomeworkWidget> createState() => _HomeworkWidgetState();
}

class _HomeworkWidgetState extends State<HomeworkWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          visualDensity: const VisualDensity(horizontal: 0, vertical: 4),
          title:
              Text(widget.entry.subject, style: const TextStyle(fontSize: 20)),
          subtitle: Text(widget.entry.notes),
          trailing: Transform.scale(
            scale: 1.3,
            child: Checkbox(
              visualDensity: const VisualDensity(horizontal: 0, vertical: 4),
              shape: const CircleBorder(),
              value: widget.entry.done,
              onChanged: (bool? value) {
                setState(() {
                  widget.entry.done = value!;
                });
                widget.onChecked();
              },
            ),
          ),
        ),
      ),
    );
  }
}
