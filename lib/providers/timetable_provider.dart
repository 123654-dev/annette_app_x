import 'package:annette_app_x/providers/user_settings.dart';

import 'api/api_provider.dart';

class TimetableProvider {
  static String getCurrentSubjectAsString() {
    return "Bubatz";
  }

  static Future<void> getTimetable() async {
    var timetable =
        await ApiProvider.fetchTimetable(UserSettings.classIdString);

    print(timetable);
  }
}
