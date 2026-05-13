class KeyGenerator {

  static String exerciseKey({
    required int week,
    required int day,
    required String exerciseName,
  }) {
    return "w${week}_d${day}_$exerciseName";
  }
}