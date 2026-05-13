import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  bool get _isLoggedIn => _uid != null;

  /// 📥 USER DATA
  Future<Map<String, dynamic>?> getUserData() async {
    if (!_isLoggedIn) return null;

    final doc =
        await _db.collection("users").doc(_uid).get();

    if (!doc.exists) return null;
    return doc.data();
  }

  /// 🚀 START PROGRAM
  Future<void> startProgram() async {
  if (!_isLoggedIn) return;

  await _db.collection("users").doc(_uid).set({
    "startDate": DateTime.now().toIso8601String(),
    "currentWeek": 1,
  }, SetOptions(merge: true));
}

  /// 🔁 RESET + RESTART COUNT (DOĞRU VERSİYON)
  Future<void> resetAndStartProgram() async {
  if (!_isLoggedIn) return;

  final ref = _db.collection("users").doc(_uid);

  final doc = await ref.get();
  final currentRestart = (doc.data()?["restartCount"] ?? 0) as int;

  // 🧨 1. exercises tamamen temizle
  final exSnap = await ref.collection("exercises").get();
  for (var d in exSnap.docs) {
    await d.reference.delete();
  }

  // 🧨 2. user reset
  await ref.set({
    "startDate": DateTime.now().toIso8601String(),
    "currentWeek": 1,
    "restartCount": currentRestart + 1,
  }, SetOptions(merge: true));
}

  /// 📅 GÜN HESABI (SAFE)
  int getDayIndex(String startDateString) {
    final start =
        DateTime.parse(startDateString).toLocal();

    final now = DateTime.now();

    final startDay =
        DateTime(start.year, start.month, start.day);

    final nowDay =
        DateTime(now.year, now.month, now.day);

    final diff = nowDay.difference(startDay).inDays;

    return diff < 0 ? 0 : diff;
  }

  /// 🏋️ EXERCISE UPDATE
  Future<void> updateExercise({
    required String key,
    required bool isDone,
  }) async {
    if (!_isLoggedIn) return;

    await _db
        .collection("users")
        .doc(_uid)
        .collection("exercises")
        .doc(key)
        .set({
      "done": isDone,
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// 📥 EXERCISES
  Future<Map<String, dynamic>> getExercises() async {
    if (!_isLoggedIn) return {};

    final snap = await _db
        .collection("users")
        .doc(_uid)
        .collection("exercises")
        .get();

    Map<String, dynamic> data = {};

    for (var doc in snap.docs) {
      data[doc.id] = doc.data();
    }

    return data;
  }
}