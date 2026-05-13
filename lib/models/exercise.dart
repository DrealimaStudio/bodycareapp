class Exercise {
  final String id;
  final String name;
  final int sets;
  final int reps;
  final int durationSeconds;
  bool isDone;

  Exercise({
    required this.id,
    required this.name,
    required this.sets,
    required this.reps,
    required this.durationSeconds,
    this.isDone = false,
  });
}

