import 'package:annette_app_x/utilities/homework_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nanoid/nanoid.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationProvider {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {
          print('📘 | Received notification with id $id [notifications.dart]');
        });

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) async {
      print(
          '📘 | Received notification action with payload: $payload [notifications.dart]');
    });
  }

  //? kurze Dokumentation hier
  makeNotificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('annette_app_x', 'Annette App',
            importance: Importance.max, priority: Priority.high),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) {
    return notificationsPlugin.show(id, title, body, makeNotificationDetails());
  }

  Future<void> cancelNotification(int id) async {
    print("🚫 | CANCELLING notification with id $id [notifications.dart]");
    await notificationsPlugin.cancel(id);
  }

  Future<int> scheduleNotification(
      {id = 0,
      required DateTime date,
      String? title,
      String? body,
      String? payload}) async {
    var id = int.parse(customAlphabet('1234567890', 9));
    print("📗 | Scheduling notification with id $id [notifications.dart]");
    await notificationsPlugin.zonedSchedule(id, title, body,
        tz.TZDateTime.from(date, tz.local), makeNotificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exact,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
    return id;
  }
}
