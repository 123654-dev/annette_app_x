import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:annette_app_x/models/homework_entry.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:cross_file/cross_file.dart';

class HomeworkSharer {
  static void shareHomework(HomeworkEntry entry) async {
    //Share the homework as a file with the extension .homework
    List<int> bytes = convertHomeworkToBytes(entry);
    final dir = await getApplicationDocumentsDirectory();
    //Share the file
    await Share.shareXFiles([
      XFile.fromData(
        Uint8List.fromList(bytes),
        name: 'entry.subject + ".homework"',
        path: dir.path + "/" + entry.subject + ".homework"
      )
    ], text: 'test');
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
