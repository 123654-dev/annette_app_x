import 'package:annette_app_x/models/homework_entry.dart';
import 'package:annette_app_x/utilities/homework_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomeworkTrayWidget extends StatefulWidget {
  final Function onChecked;
  final HomeworkEntry entry;

  const HomeworkTrayWidget(
      {super.key, required this.entry, required this.onChecked});

  @override
  State<HomeworkTrayWidget> createState() => _HomeworkWidgetState();
}

class _HomeworkWidgetState extends State<HomeworkTrayWidget> {
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting("de_DE", null);

    return Card(
      shadowColor: Colors.transparent,
      child: ListTile(
        isThreeLine: true,
        visualDensity: const VisualDensity(horizontal: 0, vertical: 4),
        title: Text(widget.entry.subject, style: const TextStyle(fontSize: 20)),
        subtitle: Text(
            "${widget.entry.notes}\n${DateFormat("'Bis': EEEE, dd.MM. (kk:mm)", "de_DE").format(widget.entry.dueDate)}"),
        trailing: SizedBox(
          height: 50,
          width: 100,
          child: Row(
            children: [
              IconButton(
                onPressed: () => HomeworkManager.deleteFromBin(widget.entry),
                icon: PhosphorIcon(
                  PhosphorIcons.duotone.trashSimple,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              IconButton(
                onPressed: () => HomeworkManager.restoreFromBin(widget.entry),
                icon: PhosphorIcon(
                  PhosphorIcons.duotone.arrowArcLeft,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
