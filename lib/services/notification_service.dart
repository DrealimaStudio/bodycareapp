import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: android);

    await _plugin.initialize(settings);

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    tz.initializeTimeZones();
  }

  /// 📌 SABAH 09:00
  static Future<void> scheduleMorningWorkout() async {
    final now = tz.TZDateTime.now(tz.local);

    final scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      9,
    );

    await _plugin.zonedSchedule(
      100,
      "Gün başladı 💪",
      "Sabah egzersizini yapmayı unutma!",
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'workout_channel',
          'Workout',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// 📌 AKŞAM 16:00 - 19:00 (random saat)
  static Future<void> scheduleEveningWorkout() async {
    final now = tz.TZDateTime.now(tz.local);

    final randomHour = 16 + (DateTime.now().millisecond % 4);
    // 16,17,18,19 arası değişir

    final scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      randomHour,
    );

    await _plugin.zonedSchedule(
      101,
      "Akşam hatırlatma 🔥",
      "Bugünkü egzersizini tamamladın mı?",
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'workout_channel',
          'Workout',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// 📌 MANUEL NOTIF
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'diet_channel',
      'Diet Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(id, title, body, details);
  }
}