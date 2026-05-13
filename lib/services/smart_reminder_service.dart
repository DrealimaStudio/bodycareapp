import 'notification_service.dart';
import 'storage_service.dart';
import 'key_generator.dart';

class SmartReminderService {

  /// Tek bir egzersizin yapılıp yapılmadığını kontrol eder
  static Future<bool> _isExerciseDone({
    required int week,
    required int day,
    required String exerciseName,
  }) async {

    final key = KeyGenerator.exerciseKey(
      week: week,
      day: day,
      exerciseName: exerciseName,
    );

    return await StorageService.getExerciseDone(key);
  }

  /// AKŞAM KONTROL SİSTEMİ
  static Future<void> checkEveningReminder({
    required int week,
    required int day,
    required List<String> exercises,
  }) async {

    bool allDone = true;

    for (final ex in exercises) {
      final done = await _isExerciseDone(
        week: week,
        day: day,
        exerciseName: ex,
      );

      if (!done) {
        allDone = false;
        break;
      }
    }

    // Eğer en az 1 egzersiz yapılmadıysa bildirim gönder
    if (!allDone) {
      await NotificationService.showNotification(
        id: 100,
        title: "Egzersiz Hatırlatma ⏰",
        body: "Bugünkü egzersizlerini tamamlamadın. Şimdi yapabilirsin 💪",
      );
    }
  }

  /// SABAH MOTİVASYON (opsiyonel)
  static Future<void> morningMotivation() async {
    await NotificationService.showNotification(
      id: 101,
      title: "Yeni Gün 💪",
      body: "Bugün hedeflerine bir adım daha yaklaş!",
    );
  }
}