import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

import '../data/week_plans.dart';
import '../services/cloud_service.dart';
import '../services/streak_service.dart';
import '../services/auth_service.dart';
import '../screens/auth/login_screen.dart';
import '../widgets/glass_card.dart';

import 'dashboard_screen.dart';
import '../screens/coach_chat_screen.dart';

import '../models/exercise.dart';
import '../models/day_plan.dart';
import '../models/week_plan.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CloudService cloudService = CloudService();

  int currentWeek = 1;
  int currentDayIndex = 0;
  int streakDays = 0;
  int restartCount = 0;

  DateTime? startDate;

  bool isLoading = true;

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));

    loadData();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> startProgram() async {
    await cloudService.startProgram();
    await loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);

    streakDays = await StreakService.getStreak();

    final userData = await cloudService.getUserData();

    if (userData != null) {
      final rawStart = userData["startDate"];

      startDate = (rawStart != null && rawStart.toString().isNotEmpty)
          ? DateTime.tryParse(rawStart)
          : null;

      currentWeek = userData["currentWeek"] ?? 1;
      restartCount = userData["restartCount"] ?? 0;

      if (startDate != null) {
        final today = DateTime.now();

        final start = DateTime(
          startDate!.year,
          startDate!.month,
          startDate!.day,
        );

        final now = DateTime(
          today.year,
          today.month,
          today.day,
        );

        currentDayIndex = now.difference(start).inDays;
      }
    }

    final data = await cloudService.getExercises();

    for (var week in weekPlans) {
      for (var day in week.days) {
        for (var ex in day.exercises) {
          ex.isDone = data[ex.id]?["done"] ?? false;
        }
      }
    }

    if (!mounted) return;

    setState(() => isLoading = false);
  }

  Future<void> markDone(
    Exercise ex,
    int week,
    DayPlan day,
  ) async {
    setState(() {
      ex.isDone = true;
    });

    await cloudService.updateExercise(
      key: ex.id,
      isDone: true,
    );

    /// 🔥 GÜN TAMAMLANDI MI?
    final allDone = day.exercises.every((e) => e.isDone);

       // 🔥 STREAK GÜNCELLE
    await StreakService.updateStreak();

if (allDone) {
  _confettiController.play();

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("🎉 Gün tamamlandı!"),
      backgroundColor: Colors.green,
    ),
  );
}
    

    setState(() {});
  }



  

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F172A),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    /// 🚀 START SCREEN
    if (startDate == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: startProgram,
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF22C55E),
                        Color(0xFF16A34A),
                      ],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.greenAccent,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_arrow, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "Programa Başla",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Bugün yeni yolculuğunun başlangıcı",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final WeekPlan week = weekPlans.firstWhere(
      (w) => w.weekNumber == currentWeek,
      orElse: () => weekPlans.first,
    );

    final safeIndex =
        currentDayIndex.clamp(0, week.days.length - 1);

    final DayPlan day = week.days[safeIndex];

    double progress = day.exercises.isEmpty
        ? 0
        : day.exercises.where((e) => e.isDone).length /
            day.exercises.length;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Fitness Journey"),

        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await cloudService.resetAndStartProgram();
              await loadData();

              setState(() {
                startDate = null;
                currentDayIndex = 0;
                currentWeek = 1;
              });
            },
          ),

          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CoachChatScreen(),
                ),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.dashboard),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DashboardScreen(),
                ),
              );
            },
          ),
          IconButton(
  icon: const Icon(Icons.logout, color: Colors.white),
  onPressed: () async {
    await AuthService().logout();

    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  },
),
        ],
      ),

      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF1E293B),
                      Color(0xFF0F172A),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hafta $currentWeek - Gün ${currentDayIndex + 1}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "$streakDays gün streak 🔥",
                      style: const TextStyle(color: Colors.orange),
                    ),
                    Text(
                      "$restartCount kez yeniden başlatıldı 🔁",
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Colors.white12,
                  valueColor:
                      const AlwaysStoppedAnimation(Colors.green),
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: ListView.builder(
                  itemCount: day.exercises.length,
                  itemBuilder: (context, index) {
                    final ex = day.exercises[index];

                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Dismissible(
                        key: ValueKey(ex.id),
                        direction: DismissDirection.endToStart,

                        confirmDismiss: (_) async {
                          if (ex.isDone) return false; // 🔒 tekrar yapılmasın

                          await markDone(ex, week.weekNumber, day);
                          return false;
},

                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.green,
                          child: const Icon(Icons.check,
                              color: Colors.white),
                        ),

                        child: GlassCard(
                          child: ListTile(
                            title: Text(
                              ex.name,
                              style: TextStyle(
                                color: Colors.white,
                                decoration: ex.isDone
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            subtitle: Text(
                              ex.reps == 0
                                  ? "${ex.sets} set • ${ex.durationSeconds}s"
                                  : "${ex.sets} set • ${ex.reps} tekrar",
                              style: const TextStyle(
                                  color: Colors.white70),
                            ),
                            trailing: ex.isDone
                                ? const Icon(Icons.check,
                                    color: Colors.green)
                                : const Icon(Icons.swipe_left,
                                    color: Colors.white24),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          /// 🎉 CONFETTI
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
              ],
            ),
          ),
        ],
      ),
    );
  }
}