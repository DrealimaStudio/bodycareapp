import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'smart_reminder_service.dart';

class BackgroundService {

  static Future<void> init() async {
    await AndroidAlarmManager.initialize();

    // SABAH 08:00
    await AndroidAlarmManager.periodic(
      const Duration(hours: 24),
      1,
      morningTask,
      startAt: _nextTime(8),
      exact: true,
      wakeup: true,
    );

    // AKŞAM 18:00
    await AndroidAlarmManager.periodic(
      const Duration(hours: 24),
      2,
      eveningTask,
      startAt: _nextTime(18),
      exact: true,
      wakeup: true,
    );
  }

  // 🔥 SABAH TASK
  @pragma('vm:entry-point')
  static void morningTask() async {
    await SmartReminderService.morningMotivation();
  }

  // 🔥 AKŞAM TASK
  @pragma('vm:entry-point')
  static void eveningTask() async {
    await SmartReminderService.checkEveningReminder(
      week: 1, // şimdilik sabit, sonra dinamik yapacağız
      day: 1,
      exercises: ["Squat", "Plank", "Lunge"],
    );
  }

  static DateTime _nextTime(int hour) {
    final now = DateTime.now();
    final target = DateTime(now.year, now.month, now.day, hour);

    return target.isBefore(now)
        ? target.add(const Duration(days: 1))
        : target;
  }
}