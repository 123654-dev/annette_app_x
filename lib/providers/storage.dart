import 'package:annette_app_x/models/class_ids.dart';
import 'package:hive/hive.dart';

class StorageProvider {
  static void saveExamPlanDate(ClassId id) async {
    //Save the current date to Hive
    var cache = await Hive.openBox("cache");
    cache.put('examPlanDate${id.name}', DateTime.now());
    print("Saved exam plan date for ${id.name}");
  }

  //TODO: Replace with FCM
  static Future<bool> isExamPlanUpToDate(ClassId id) async {
    //Check if the exam plan is up to date
    var cache = await Hive.openBox("cache");
    print('examPlanDate${id.name}');
    var examPlanDate = (cache.get('examPlanDate${id.name}'));
    if (examPlanDate == null ||
        DateTime.now().difference(examPlanDate).inDays > 7) {
      return false;
    }
    return true;
  }
}
