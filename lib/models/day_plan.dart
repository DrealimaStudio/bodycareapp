import 'exercise.dart';

class DayPlan {
  final int dayNumber;
  final String focus;
  final List<Exercise> exercises;

  bool isCompleted;

  DayPlan({
    required this.dayNumber,
    required this.focus,
    required this.exercises,
    this.isCompleted = false,
  });
}