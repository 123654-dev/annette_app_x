import 'dart:math';

import 'package:annette_app_x/models/homework_entry.dart';
import 'package:hive/hive.dart';

class HomeworkManager {
  //Zwischenspeicher, der verhindert, dass mehr als ein Dialog gleichzeitig geöffnet werden kann
  static bool _isHomeworkDialogOpen = false;
  static List<HomeworkEntry> entries() =>
      List<HomeworkEntry>.from(Hive.box('homework').values.toList());

  static List<HomeworkEntry> pendingHomework() {
    return entries().where((element) => !element.done).toList();
  }

  static List<HomeworkEntry> doneHomework() {
    return entries().where((element) => element.done).toList();
  }

  static void showHomeworkDialog(Function() refresh) {
    //Wenn der Dialog bereits offen ist, wird kein weiterer geöffnet.
    if (_isHomeworkDialogOpen) return;

    //Der Dialog ist jetzt offen
    _isHomeworkDialogOpen = true;
    HomeworkEntry e = HomeworkEntry(
        subject: "Mathe",
        //generate random string
        notes: Random().nextInt(1000000000).toString(),
        dueDate: DateTime.now(),
        lastUpdated: DateTime.now());
    Hive.box('homework').add(e);
    refresh();
    _isHomeworkDialogOpen = false;
  }

  static bool hasHomework() {
    return pendingHomework().isNotEmpty;
  }

  static int howManyPendingEntries() => pendingHomework().length;
  static int howManyDoneEntries() => doneHomework().length;
  static int howManyEntries() => entries().length;

  static void moveToBin(HomeworkEntry entry) {
    entries().elementAt(entries().indexOf(entry)).done = true;
    Hive.box('homework').putAt(entries().indexOf(entry), entry);
  }
}
