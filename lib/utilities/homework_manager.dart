import 'dart:convert';
import 'dart:math';

import 'package:annette_app_x/models/homework_entry.dart';
import 'package:annette_app_x/providers/notifications.dart';
import 'package:annette_app_x/screens/homework/homework_dialog.dart';
import 'package:annette_app_x/screens/homework/homework_import.dart';
import 'package:annette_app_x/screens/homework/homework_info.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/date_symbol_data_local.dart';
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

  static bool doesHomeworkEntryExist(HomeworkEntry entry) {
    return entries().any((element) => element.id == entry.id);
  }

  static Future<HomeworkEntry> addEmptyHomeworkEntry() async{
    initializeDateFormatting("de_DE", null);
    var entry = HomeworkEntry(
        id: Random().nextInt(1000000),
        subject: "Sonstiges",
        notes: "Wenn du das in der App siehst, ist etwas schief gelaufen. Bitte melde das!",
        dueDate: DateTime.now().add(Duration(days: 1)),
        lastUpdated: DateTime.now());
    await Hive.box('homework').add(entry);
    return entry;
  }

  static Future<void> addHomeworkEntry(HomeworkEntry entry) async {
    initializeDateFormatting("de_DE", null);
    entry.lastUpdated = DateTime.now();
    print(entry.toJson().toString());
    if (entry.reminderDateTime == null ||
        entry.reminderDateTime!.isBefore(DateTime.now())) {
      return;
    }
    entry.scheduledNotificationId = await NotificationProvider()
        .scheduleNotification(
            date: entry.reminderDateTime!,
            title: "Hausaufgaben in ${entry.subject}!",
            body: generateRemainingTimeToast(entry.dueDate),
            payload: entry.toJson().toString());
    Hive.box('homework').add(entry);
    print((entries().first.toJson().toString()));
  }

  static Future<void> editHomeworkEntry(
      HomeworkEntry oldEntry, HomeworkEntry newEntry) async {
    if(oldEntry.scheduledNotificationId != null){
      NotificationProvider()
        .cancelNotification(oldEntry.scheduledNotificationId!);
    }
    newEntry.scheduledNotificationId = oldEntry.scheduledNotificationId;
    if (newEntry.reminderDateTime!.isAfter(DateTime.now())) {
      NotificationProvider().scheduleNotification(
          id: newEntry.scheduledNotificationId == null ? await NotificationProvider() : newEntry.scheduledNotificationId!,
          date: newEntry.reminderDateTime!,
          title: "Hausaufgaben in ${newEntry.subject}!",
          body: generateRemainingTimeToast(newEntry.dueDate),
          payload: newEntry.toJson().toString());
    }
    print(oldEntry.toJson().toString());
    Hive.box('homework').putAt(entries().indexOf(oldEntry), newEntry);
  }

  static void showImportDialog(HomeworkEntry entry) {
    HomeworkImport.show(entry);
  }

  static void _dialogCallback(
      {required int id,required String subject,
      required String annotations,
      required bool autoRemind,
      required DateTime remindDT}) async {
    var entry = HomeworkEntry(
        id: id,
        subject: subject,
        notes: annotations,
        dueDate: remindDT,
        lastUpdated: DateTime.now());

    if (autoRemind) {
      //TODO: Auto-set due date
    }

    await addHomeworkEntry(entry);
  }

  static void showHomeworkDialog(Function() refresh) {
    HomeworkDialog.show(onClose: _dialogCallback);
  }

  static void showHomeworkEditDialog(HomeworkEntry entry,
      Function(HomeworkEntry, HomeworkEntry) onClose) {
    HomeworkInfo.show(entry);
  }

  static bool hasHomework() {
    return pendingHomework().isNotEmpty;
  }

  static int howManyPendingEntries() => pendingHomework().length;
  static int howManyDoneEntries() => doneHomework().length;
  static int howManyEntries() => entries().length;

  static void moveToBin(HomeworkEntry entry) {
    if (entry.scheduledNotificationId != null){
      NotificationProvider().cancelNotification(entry.scheduledNotificationId!);
    }
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
    if(entry.scheduledNotificationId != null){
      NotificationProvider().cancelNotification(entry.scheduledNotificationId!);
    }
    Hive.box('homework').deleteAt(entries().indexOf(entry));
  }
}
