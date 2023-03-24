import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:annette_app_x/models/homework_entry.dart';
import 'package:annette_app_x/utilities/homework_manager.dart';
import 'package:annette_app_x/widgets/homework/homework_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomeworkScreen extends StatefulWidget {
  final Function refresh;
  const HomeworkScreen({super.key, required this.refresh});

  @override
  HomeworkScreenState createState() => HomeworkScreenState();
}

class HomeworkScreenState extends State<HomeworkScreen> {
  @override
  void initState() {
    super.initState();
  }

  List<HomeworkEntry> pendingHomework = [];

  @override
  Widget build(BuildContext context) {
    pendingHomework = HomeworkManager.pendingHomework();
    int pendingHomeworkCount = pendingHomework.length;
    Hive.box('homework').watch().listen((event) {
      if (true) {
        setState(() {});
      }
    });
    return pendingHomeworkCount != 0
        ? ImplicitlyAnimatedList(
            items: pendingHomework,
            itemBuilder: _buildItem,
            areItemsTheSame: (oldItem, newItem) => oldItem == newItem,
          )
        : const Text("Keine Hausaufgaben!");
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
}
