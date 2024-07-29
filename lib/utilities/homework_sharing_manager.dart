import 'dart:async';
import 'dart:convert';

import 'package:annette_app_x/models/file_format.dart';
import 'package:annette_app_x/models/homework_entry.dart';
import 'package:annette_app_x/providers/api/files_provider.dart';
import 'package:annette_app_x/utilities/homework_manager.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';


class HomeworkSharer {
  static const platform =
      MethodChannel('com.example.annette_app_x/homework_sharing');

  static void handleSharedData() async {
    try {
      platform.setMethodCallHandler((call) {
        switch (call.method) {
          case "importHomework":
            //_controller.add("");
            importHomework(call.arguments);
            break;
        }
        return Future.value("");
      });
      return;
    } on PlatformException catch (e) {
      print("Error receiving shared homework: ${e.toString()}");
      return;
    }
  }

  static void importHomework(String? homework) {
    try {
      if (homework != null) {
        print("openedHomework: $homework");
        HomeworkEntry entry = HomeworkEntry.fromJson(jsonDecode(homework));
        HomeworkManager.showImportDialog(entry);
        //HomeworkManager.addHomeworkEntry(entry);
      }
    } on Exception catch (e) {
      print("Error importing shared homework: ${e.toString()}");
    }
  }

  static void shareHomework(HomeworkEntry entry) async {
    //Share the homework as a file with the extension .homework
    List<int> bytes = convertHomeworkToBytes(entry);

    final file = await FilesProvider.storeFile(
        entry.id.toString(), bytes, FileFormat.HOMEWORK);

    XFile xFile = XFile(file.path);
    //Share the file
    await Share.shareXFiles([xFile], text: 'Hausaufgabe teilen');

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
