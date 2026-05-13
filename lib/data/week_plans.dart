import '../models/week_plan.dart';
import '../models/day_plan.dart';
import '../models/exercise.dart';

List<WeekPlan> weekPlans = [

  /// 🟢 WEEK 1
  WeekPlan(
    weekNumber: 1,
    days: [
      DayPlan(
        dayNumber: 1,
        focus: "Alt vücut + karın",
        exercises: [
          Exercise(id: "w1d1_squat", name: "Squat", sets: 2, reps: 12, durationSeconds: 0),
          Exercise(id: "w1d1_glute_bridge", name: "Glute bridge", sets: 2, reps: 15, durationSeconds: 0),
          Exercise(id: "w1d1_lunge", name: "Lunge", sets: 2, reps: 10, durationSeconds: 0),
          Exercise(id: "w1d1_plank", name: "Plank", sets: 2, reps: 0, durationSeconds: 20),
        ],
      ),
      DayPlan(
        dayNumber: 2,
        focus: "Üst vücut",
        exercises: [
          Exercise(id: "w1d2_pushup", name: "Push-up", sets: 2, reps: 8, durationSeconds: 0),
          Exercise(id: "w1d2_shoulder", name: "Shoulder press", sets: 2, reps: 12, durationSeconds: 0),
          Exercise(id: "w1d2_biceps", name: "Biceps curl", sets: 2, reps: 12, durationSeconds: 0),
        ],
      ),
      DayPlan(
        dayNumber: 3,
        focus: "Core",
        exercises: [
          Exercise(id: "w1d3_plank", name: "Plank", sets: 2, reps: 0, durationSeconds: 30),
          Exercise(id: "w1d3_sideplank", name: "Side plank", sets: 2, reps: 20, durationSeconds: 0),
        ],
      ),
      DayPlan(
        dayNumber: 4,
        focus: "Alt vücut",
        exercises: [
          Exercise(id: "w1d4_squat", name: "Squat", sets: 2, reps: 15, durationSeconds: 0),
          Exercise(id: "w1d4_lunge", name: "Lunge", sets: 2, reps: 12, durationSeconds: 0),
        ],
      ),
      DayPlan(
        dayNumber: 5,
        focus: "Üst vücut",
        exercises: [
          Exercise(id: "w1d5_pushup", name: "Push-up", sets: 2, reps: 10, durationSeconds: 0),
          Exercise(id: "w1d5_shoulder", name: "Shoulder press", sets: 2, reps: 12, durationSeconds: 0),
        ],
      ),
      DayPlan(dayNumber: 6, focus: "Yürüyüş", exercises: []),
      DayPlan(dayNumber: 7, focus: "Dinlenme", exercises: []),
    ],
  ),

  /// 🟡 WEEK 2 (aynı ama biraz artış)
  WeekPlan(
    weekNumber: 2,
    days: [
      DayPlan(dayNumber: 1, focus: "Alt vücut + karın", exercises: [
        Exercise(id: "w2d1_squat", name: "Squat", sets: 3, reps: 12, durationSeconds: 0),
        Exercise(id: "w2d1_glute_bridge", name: "Glute bridge", sets: 3, reps: 15, durationSeconds: 0),
      ]),
      DayPlan(dayNumber: 2, focus: "Üst vücut", exercises: [
        Exercise(id: "w2d2_pushup", name: "Push-up", sets: 3, reps: 10, durationSeconds: 0),
      ]),
      DayPlan(dayNumber: 3, focus: "Core", exercises: [
        Exercise(id: "w2d3_plank", name: "Plank", sets: 3, reps: 0, durationSeconds: 30),
      ]),
      DayPlan(dayNumber: 4, focus: "Alt vücut", exercises: []),
      DayPlan(dayNumber: 5, focus: "Üst vücut", exercises: []),
      DayPlan(dayNumber: 6, focus: "Yürüyüş", exercises: []),
      DayPlan(dayNumber: 7, focus: "Dinlenme", exercises: []),
    ],
  ),

  /// 🔵 WEEK 3
  WeekPlan(weekNumber: 3, days: [
    DayPlan(dayNumber: 1, focus: "Alt vücut", exercises: [
      Exercise(id: "w3d1_squat", name: "Squat", sets: 3, reps: 15, durationSeconds: 0),
      Exercise(id: "w3d1_glute", name: "Glute bridge", sets: 3, reps: 20, durationSeconds: 0),
    ]),
    DayPlan(dayNumber: 2, focus: "Üst vücut", exercises: [
      Exercise(id: "w3d2_pushup", name: "Push-up", sets: 3, reps: 12, durationSeconds: 0),
    ]),
    DayPlan(dayNumber: 3, focus: "Core", exercises: [
      Exercise(id: "w3d3_plank", name: "Plank", sets: 3, reps: 0, durationSeconds: 35),
    ]),
    DayPlan(dayNumber: 4, focus: "Alt vücut", exercises: []),
    DayPlan(dayNumber: 5, focus: "Üst vücut", exercises: []),
    DayPlan(dayNumber: 6, focus: "Yürüyüş", exercises: []),
    DayPlan(dayNumber: 7, focus: "Dinlenme", exercises: []),
  ]),

  /// 🟠 WEEK 4
  WeekPlan(weekNumber: 4, days: [
    DayPlan(dayNumber: 1, focus: "Alt vücut", exercises: [
      Exercise(id: "w4d1_squat", name: "Squat", sets: 3, reps: 15, durationSeconds: 0),
    ]),
    DayPlan(dayNumber: 2, focus: "Üst vücut", exercises: []),
    DayPlan(dayNumber: 3, focus: "Core", exercises: [
      Exercise(id: "w4d3_sideplank", name: "Side plank", sets: 2, reps: 20, durationSeconds: 0),
    ]),
    DayPlan(dayNumber: 4, focus: "Alt vücut", exercises: []),
    DayPlan(dayNumber: 5, focus: "Üst vücut", exercises: []),
    DayPlan(dayNumber: 6, focus: "Yürüyüş", exercises: []),
    DayPlan(dayNumber: 7, focus: "Dinlenme", exercises: []),
  ]),

  /// 🔴 WEEK 5
  WeekPlan(weekNumber: 5, days: [
    DayPlan(dayNumber: 1, focus: "Güç", exercises: [
      Exercise(id: "w5d1_squat", name: "Squat", sets: 4, reps: 15, durationSeconds: 0),
    ]),
    DayPlan(dayNumber: 2, focus: "Üst vücut", exercises: []),
    DayPlan(dayNumber: 3, focus: "Core", exercises: []),
    DayPlan(dayNumber: 4, focus: "Alt vücut", exercises: []),
    DayPlan(dayNumber: 5, focus: "Üst vücut", exercises: []),
    DayPlan(dayNumber: 6, focus: "Yürüyüş", exercises: []),
    DayPlan(dayNumber: 7, focus: "Dinlenme", exercises: []),
  ]),

  /// 🟣 WEEK 6
  WeekPlan(weekNumber: 6, days: [
    DayPlan(dayNumber: 1, focus: "Zirve", exercises: [
      Exercise(id: "w6d1_squat", name: "Squat", sets: 4, reps: 20, durationSeconds: 0),
    ]),
    DayPlan(dayNumber: 2, focus: "Üst vücut", exercises: []),
    DayPlan(dayNumber: 3, focus: "Core", exercises: []),
    DayPlan(dayNumber: 4, focus: "Alt vücut", exercises: []),
    DayPlan(dayNumber: 5, focus: "Üst vücut", exercises: []),
    DayPlan(dayNumber: 6, focus: "Yürüyüş", exercises: []),
    DayPlan(dayNumber: 7, focus: "Dinlenme", exercises: []),
  ]),
];