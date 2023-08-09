import 'package:annette_app_x/models/class_ids.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

//? könnten wir nicht hier noch etwas für die Hausaufgaben tun?
//? oder doch lieber umbenennen zu exam_provider?

class StorageProvider {
  static void saveExamPlanDate(ClassId id) async {
    //Save the current date to Hive
    var cache = await Hive.openBox("cache");
    cache.put('examPlanDate${id.fmtName}', DateTime.now());
  }

  //TODO: Replace with FCM
  static Future<bool> isExamPlanUpToDate(ClassId id) async {
    //Check if the exam plan is up to date
    var cache = await Hive.openBox("cache");
    var examPlanDate = (cache.get('examPlanDate${id.fmtName}'));
    print(examPlanDate);
    if (examPlanDate == null ||
        DateTime.now().difference(examPlanDate).inDays > 7) {
      return false;
    }
    return true;
  }
}
