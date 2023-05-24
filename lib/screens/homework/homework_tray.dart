import 'dart:async';

import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:annette_app_x/models/homework_entry.dart';
import 'package:annette_app_x/utilities/homework_manager.dart';
import 'package:annette_app_x/widgets/homework/homework_tray_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomeworkTray extends StatefulWidget {
  final Function refresh;
  const HomeworkTray({super.key, required this.refresh});

  static void show(BuildContext context, Function refresh) {
    showModalBottomSheet(
        context: context,
        builder: (context) => HomeworkTray(
              refresh: refresh,
            ));
  }

  @override
  _HomeworkTrayState createState() => _HomeworkTrayState();
}

class _HomeworkTrayState extends State<HomeworkTray> {
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

  List<HomeworkEntry> contents = [];

  @override
  Widget build(BuildContext context) {
    contents = HomeworkManager.doneHomework();
    int pendingHomeworkCount = contents.length;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: pendingHomeworkCount != 0
          ? Column(children: [
              const SizedBox(height: 5),
              const Text("Papierkorb",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Expanded(
                child: ImplicitlyAnimatedList(
                  items: contents,
                  itemBuilder: _buildItem,
                  areItemsTheSame: (oldItem, newItem) => oldItem == newItem,
                  insertDuration: const Duration(milliseconds: 100),
                  removeDuration: const Duration(milliseconds: 100),
                  updateDuration: const Duration(milliseconds: 100),
                ),
              ),
            ])
          : SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: const Center(
                child: Text(
                  "Keine Hausaufgaben im Papierkorb!",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
    );
  }

  Widget _buildItem(BuildContext context, Animation<double> animation,
      HomeworkEntry entry, int index) {
    return FadeTransition(
      opacity: animation,
      child: HomeworkTrayWidget(
          entry: entry,
          onChecked: () {
            HomeworkManager.moveToBin(entry);
            setState(() {
              contents.removeAt(index);
            });
            widget.refresh();
          }),
    );
  }
}
