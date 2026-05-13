import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/body_record.dart';

class BodyService {

  static const _key = "body_records";

  static Future<void> addRecord(BodyRecord record) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> list = prefs.getStringList(_key) ?? [];

    list.add(jsonEncode({
      "date": record.date.toIso8601String(),
      "weight": record.weight,
      "waist": record.waist,
    }));

    await prefs.setStringList(_key, list);
  }

  static Future<List<BodyRecord>> getRecords() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> list = prefs.getStringList(_key) ?? [];

    return list.map((e) {
      final data = jsonDecode(e);
      return BodyRecord(
        date: DateTime.parse(data["date"]),
        weight: data["weight"],
        waist: data["waist"],
      );
    }).toList();
  }
}