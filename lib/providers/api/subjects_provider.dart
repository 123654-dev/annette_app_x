import 'dart:convert';
import 'dart:io';
import 'package:annette_app_x/providers/api/files_provider.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/class_ids.dart';
import '../../models/file_format.dart';
import 'api_provider.dart';

class SubjectsProvider {
  static Future<List<dynamic>> getSubjects(ClassId classId) async {
    List<dynamic> subjects =
        jsonDecode(await loadSubjectsFromFile(classId)) as List<dynamic>;
    return subjects;
  }

  static Future<String> loadSubjectsFromFile(ClassId classId) async {
    final box = await Hive.openBox('update_timings');
    final dir = await getApplicationDocumentsDirectory();
    File file = File('${dir.path}/subjects-${classId.fmtName}.json');
    print("Loading subjects from file");
    bool isExpired = DateTime.now()
            .difference(box.get('subjects-${classId.fmtName}',
                defaultValue: DateTime(1420)))
            .inHours >=
        24 * 7;
    if (!(await file.exists()) || isExpired) {
      print("File does not exist or is expired. Saving subjects to file");
      await saveSubjectsToFile(classId);
      file = File('${dir.path}/subjects-${classId.fmtName}.json');
      box.put('subjects-${classId.fmtName}', DateTime.now());
    }
    return await file.readAsString();
  }

  static Future<void> saveSubjectsToFile(ClassId classId) async {
    print("Accessing the API");
    //Get the subjects from the api
    String subjects = await ApiProvider.fetchChoiceOptions(classId.fmtName);
    //Save the subjects
    File file = await FilesProvider.storeFile(
        "subjects-${classId.fmtName}", utf8.encode(subjects), FileFormat.JSON);
    print("Saved the subjects");
    print(file.path);
  }
}
