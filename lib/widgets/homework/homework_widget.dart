import 'package:annette_app_x/models/homework_entry.dart';
import 'package:annette_app_x/utilities/homework_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

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
    initializeDateFormatting("de_DE", null);

    return GestureDetector(
      onTap: () => {
        HomeworkManager.showHomeworkEditDialog(
            context, widget.entry, HomeworkManager.editHomeworkEntry)
      },
      child: Card(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            isThreeLine: true,
            visualDensity: const VisualDensity(horizontal: 0, vertical: 4),
            title: Text(widget.entry.subject,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondaryContainer)),
            subtitle: Text(
                "${widget.entry.notes}\n${DateFormat("'Bis': EEEE, dd.MM. (kk:mm)", "de_DE").format(widget.entry.dueDate)}",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.onSecondaryContainer)),
            trailing: Container(
              constraints: const BoxConstraints(maxWidth: 35, minWidth: 35),
              height: double.infinity,
              child: Align(
                alignment: Alignment.centerRight,
                child: Ink(
                  decoration: ShapeDecoration(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    shape: const CircleBorder(),
                  ),
                  child: IconButton(
                    //shape: const CircleBorder(),
                    iconSize: 15,
                    icon: PhosphorIcon(
                      PhosphorIcons.bold.check,
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.entry.done = true;
                      });
                      widget.onChecked();
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
