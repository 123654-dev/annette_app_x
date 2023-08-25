import 'dart:async';

import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:annette_app_x/models/homework_entry.dart';
import 'package:annette_app_x/models/sorting_types.dart';
import 'package:annette_app_x/screens/homework/homework_bin.dart';
import 'package:annette_app_x/utilities/homework_manager.dart';
import 'package:annette_app_x/widgets/homework/homework_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomeworkScreen extends StatefulWidget {
  final Function refresh;
  const HomeworkScreen({super.key, required this.refresh});

  @override
  HomeworkScreenState createState() => HomeworkScreenState();
}

class HomeworkScreenState extends State<HomeworkScreen> {
  StreamSubscription<BoxEvent>? subscription;

  @override
  void initState() {
    subscription = Hive.box('homework').watch().listen((event) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  List<HomeworkEntry> pendingHomework = [];
  SortingType sortingType = SortingType.dueDate_asc;

  @override
  Widget build(BuildContext context) {
    pendingHomework = HomeworkManager.pendingHomework();
    sortPendingHomework(sortingType);
    int pendingHomeworkCount = pendingHomework.length;

    return Column(children: [
      SizedBox(
        height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  HomeworkTray.show(widget.refresh);
                },
                icon: PhosphorIcon(PhosphorIcons.duotone.tray,
                    color: Theme.of(context).colorScheme.primary),
              ),
              PopupMenuButton<SortingType>(
                onSelected: (Object? value) {
                  setState(() {
                    sortingType = value as SortingType;
                    print("New sorting type: $sortingType");
                  });
                },
                icon: PhosphorIcon(PhosphorIcons.duotone.funnel,
                    color: Theme.of(context).colorScheme.primary),
                itemBuilder: (context) => const [
                  PopupMenuItem<SortingType>(
                    value: SortingType.dueDate_asc,
                    child: Text("Als nächstes"),
                  ),
                  PopupMenuItem<SortingType>(
                    value: SortingType.dueDate_desc,
                    child: Text("Als letztes"),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem<SortingType>(
                    value: SortingType.lastUpdated_asc,
                    child: Text("Bearbeitet: Älteste zuerst"),
                  ),
                  PopupMenuItem<SortingType>(
                    value: SortingType.lastUpdated_desc,
                    child: Text("Bearbeitet: Neueste zuerst"),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem<SortingType>(
                    value: SortingType.subject_asc,
                    child: Text("Fach: A-Z"),
                  ),
                  PopupMenuItem<SortingType>(
                    value: SortingType.subject_desc,
                    child: Text("Fach: Z-A"),
                  ),
                ],
              ),
            ],
          ),
      ),
      Expanded(
        child: pendingHomeworkCount != 0
            ? ImplicitlyAnimatedList(
                items: pendingHomework,
                itemBuilder: _buildItem,
                areItemsTheSame: (oldItem, newItem) => oldItem == newItem,
                updateDuration: const Duration(milliseconds: 200),
                insertDuration: const Duration(milliseconds: 200),
                removeDuration: const Duration(milliseconds: 200),
              )
            : const Center(child: Text("Keine Hausaufgaben!")),
      ),
    ]);
  }

  Widget _buildItem(BuildContext context, Animation<double> animation,
      HomeworkEntry entry, int index) {
    return FadeTransition(
      opacity: animation,
      child: HomeworkWidget(
          entry: entry,
          onChecked: () {
            HomeworkManager.moveToBin(entry);
            setState(() {
              pendingHomework.removeAt(index);
            });
            widget.refresh();
          }),
    );
  }

  void sortPendingHomework(SortingType sortingType) {
    switch (sortingType) {
      case SortingType.dueDate_asc:
        print("Sorting homework");
        pendingHomework.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        break;
      case SortingType.dueDate_desc:
        pendingHomework.sort((a, b) => b.dueDate.compareTo(a.dueDate));
        break;

      case SortingType.lastUpdated_asc:
        pendingHomework.sort((a, b) => a.lastUpdated.compareTo(b.lastUpdated));
        break;
      case SortingType.lastUpdated_desc:
        pendingHomework.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
        break;

      case SortingType.subject_asc:
        pendingHomework.sort((a, b) => a.subject.compareTo(b.subject));
        break;
      case SortingType.subject_desc:
        pendingHomework.sort((a, b) => b.subject.compareTo(a.subject));
        break;

      default:
        pendingHomework.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        break;
    }
  }
}
