import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StreakService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static String? get _uid => _auth.currentUser?.uid;

  /// 🔥 gün tamamlanınca çağrılır
  static Future<void> updateStreak() async {
    if (_uid == null) return;

    final ref = _db.collection("users").doc(_uid);
    final doc = await ref.get();

    final data = doc.data();

    final lastDateStr = data?["lastCompletedDate"];
    int streak = data?["streak"] ?? 0;

    final today = DateTime.now();
    final todayKey = _format(today);

    if (lastDateStr == null) {
      streak = 1;
    } else {
      final lastDate = DateTime.parse(lastDateStr);
      final diff = today.difference(lastDate).inDays;

      if (diff == 1) {
        streak += 1;
      } else if (diff == 0) {
        return; // aynı gün tekrar
      } else {
        streak = 1;
      }
    }

    await ref.set({
      "streak": streak,
      "lastCompletedDate": todayKey,
    }, SetOptions(merge: true));
  }

  static String _format(DateTime d) {
    return "${d.year}-${d.month}-${d.day}";
  }

  /// 🔥 streak getir (firebase)
  static Future<int> getStreak() async {
    if (_uid == null) return 0;

    final doc =
        await _db.collection("users").doc(_uid).get();

    return doc.data()?["streak"] ?? 0;
  }
}