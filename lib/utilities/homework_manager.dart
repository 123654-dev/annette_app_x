import 'package:annette_app_x/models/homework_entry.dart';
import 'package:annette_app_x/providers/notifications.dart';
import 'package:annette_app_x/screens/homework/homework_dialog.dart';
import 'package:annette_app_x/screens/homework/homework_info.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

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

  static generateRemainingTimeToast(DateTime dueDate) {
    return "Fällig am ${DateFormat.EEEE('de_DE').format(dueDate)}, ${DateFormat.yMd('de_DE').format(dueDate)} um ${DateFormat.Hm().format(dueDate)}";
  }

  static Future<void> addHomeworkEntry(HomeworkEntry entry) async {
    entry.scheduledNotificationId = await NotificationProvider()
        .scheduleNotification(
            date: entry.reminderDateTime!,
            title: "Hausaufgaben in ${entry.subject}!",
            body: generateRemainingTimeToast(entry.dueDate),
            payload: entry.toJson().toString());
    Hive.box('homework').add(entry);
  }

  static Future<void> editHomeworkEntry(
      HomeworkEntry oldEntry, HomeworkEntry newEntry) async {
    NotificationProvider()
        .cancelNotification(oldEntry.scheduledNotificationId!);
    newEntry.scheduledNotificationId = oldEntry.scheduledNotificationId;
    if (newEntry.reminderDateTime!.isAfter(DateTime.now())) {
      NotificationProvider().scheduleNotification(
          id: newEntry.scheduledNotificationId!,
          date: newEntry.reminderDateTime!,
          title: "Hausaufgaben in ${newEntry.subject}!",
          body: generateRemainingTimeToast(newEntry.dueDate),
          payload: newEntry.toJson().toString());
    }
    Hive.box('homework').putAt(entries().indexOf(oldEntry), newEntry);
  }

  static void _dialogCallback(
      {required String subject,
      required String annotations,
      required bool autoRemind,
      required DateTime remindDT}) async {
    var entry = HomeworkEntry(
        subject: subject,
        notes: annotations,
        dueDate: remindDT,
        lastUpdated: DateTime.now());

    if (autoRemind) {
      //TODO: Auto-set due date
    }

    await addHomeworkEntry(entry);
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
    NotificationProvider().cancelNotification(entry.scheduledNotificationId!);
    entries().elementAt(entries().indexOf(entry)).done = true;
    Hive.box('homework').putAt(entries().indexOf(entry), entry);
  }

  static void restoreFromBin(HomeworkEntry entry) {
    entries().elementAt(entries().indexOf(entry)).done = false;
    Hive.box('homework').putAt(entries().indexOf(entry), entry);
    //Erneutes Setzen der Notification
    if (entry.reminderDateTime!.isAfter(DateTime.now())) {
      NotificationProvider().scheduleNotification(
          id: entry.scheduledNotificationId!,
          date: entry.reminderDateTime!,
          title: "Hausaufgaben in ${entry.subject}!",
          body: generateRemainingTimeToast(entry.dueDate),
          payload: entry.toJson().toString());
    }
  }

  static void deleteFromBin(HomeworkEntry entry) {
    NotificationProvider().cancelNotification(entry.scheduledNotificationId!);
    Hive.box('homework').deleteAt(entries().indexOf(entry));
  }
}
