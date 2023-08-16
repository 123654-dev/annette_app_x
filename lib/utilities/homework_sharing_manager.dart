import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:annette_app_x/models/file_format.dart';
import 'package:annette_app_x/models/homework_entry.dart';
import 'package:annette_app_x/providers/api/files_provider.dart';
import 'package:annette_app_x/screens/homework/homework_dialog.dart';
import 'package:annette_app_x/utilities/homework_manager.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:cross_file/cross_file.dart';

class HomeworkSharer {
  static const platform = MethodChannel('com.example.annette_app_x/homework_sharing');

  static void handleSharedData(BuildContext context) async {
    try {
      final sharedData = await platform.invokeMethod<String>('getSharedText');
      if (sharedData != null) {
        print("openedHomework: $sharedData");
        HomeworkEntry entry = HomeworkEntry.fromJson(jsonDecode(sharedData));
        if(HomeworkManager.doesHomeworkEntryExist(entry)) {
          print("Homework already exists ${entry.notes.toString()}}");
          return;
        }
        if(context.mounted)
        HomeworkManager.showHomeworkEditDialog(
            context, entry, (HomeworkEntry oldHo, HomeworkEntry newHo) => {});
        //HomeworkManager.addHomeworkEntry(entry);
      }
    } on Exception catch (e) {
      print("Error handling shared data: ${e.toString()}");
    }
  }

  static void shareHomework(HomeworkEntry entry) async {
    //Share the homework as a file with the extension .homework
    List<int> bytes = convertHomeworkToBytes(entry);
    final dir = await getApplicationDocumentsDirectory();

    final file = await FilesProvider.storeFile(entry.scheduledNotificationId.toString(), bytes, FileFormat.HOMEWORK);

    XFile xFile = XFile(file.path);
    //Share the file
    await Share.shareXFiles([
      xFile
    ], text: 'Hausaufgabe teilen');

    await file.delete();
  }

  static List<int> convertMapToBytes(Map<String, dynamic> map) {
    String json = jsonEncode(map);
    List<int> bytes = utf8.encode(json);
    return bytes;
  }

  static List<int> convertHomeworkToBytes(HomeworkEntry entry) {
    String json = jsonEncode(entry);
    List<int> bytes = utf8.encode(json);
    return bytes;
  }

  static Map<String, dynamic> convertBytesToMap(List<int> bytes) {
    String json = utf8.decode(bytes);
    Map<String, dynamic> map = jsonDecode(json);
    return map;
  }
}
