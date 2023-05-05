import 'dart:math';

import 'package:annette_app_x/models/homework_entry.dart';
import 'package:annette_app_x/screens/homework/homework_dialog.dart';
import 'package:annette_app_x/screens/homework/homework_info.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomeworkManager {
  //Zwischenspeicher, der verhindert, dass mehr als ein Dialog gleichzeitig geöffnet werden kann
  static List<HomeworkEntry> entries() =>
      List<HomeworkEntry>.from(Hive.box('homework').values.toList());

  static List<HomeworkEntry> pendingHomework() {
    return entries().where((element) => !element.done).toList();
  }

  static List<HomeworkEntry> doneHomework() {
    return entries().where((element) => element.done).toList();
  }

  static void addHomeworkEntry(HomeworkEntry entry) {
    Hive.box('homework').add(entry);
  }

  static void editHomeworkEntry(
      HomeworkEntry oldEntry, HomeworkEntry newEntry) {
    Hive.box('homework').putAt(entries().indexOf(oldEntry), newEntry);
  }

  static void _dialogCallback(
      {required String subject,
      required String annotations,
      required bool autoRemind,
      required DateTime remindDT}) {
    var entry = HomeworkEntry(
        subject: subject,
        notes: annotations,
        dueDate: remindDT,
        lastUpdated: DateTime.now());

    if (autoRemind) {
      //TODO: Auto-set due date
    }

    addHomeworkEntry(entry);
  }

  static void showHomeworkDialog(Function() refresh, BuildContext context) {
    HomeworkDialog.show(context, onClose: _dialogCallback);
  }

  static void showHomeworkEditDialog(BuildContext context, HomeworkEntry entry,
      Function(HomeworkEntry, HomeworkEntry) onClose) {
    HomeworkInfo.show(context, entry);
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
