import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../data/week_plans.dart';
import '../services/streak_service.dart';
import '../services/cloud_service.dart';
import '../widgets/glass_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final CloudService cloudService = CloudService();

  
int dayIndex = 0;

  late TabController _tabController;

  int totalDone = 0;
  int totalExercises = 0;
  int streak = 0;
  int restartCount = 0;

  List<FlSpot> chartData = [];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    load();
  }

  Future<void> load() async {
    int done = 0;
    int total = 0;

    List<FlSpot> temp = [];

    for (int i = 0; i < weekPlans.length; i++) {
      int weeklyDone = 0;

      for (var day in weekPlans[i].days) {
        for (var ex in day.exercises) {
          total++;

          if (ex.isDone) {
            done++;
            weeklyDone++;
          }
        }
      }

      temp.add(FlSpot(i.toDouble(), weeklyDone.toDouble()));
    }

    streak = await StreakService.getStreak();

    final userData = await cloudService.getUserData();



if (userData?["startDate"] != null) {
  final start = DateTime.parse(userData!["startDate"]);
  final now = DateTime.now();

  dayIndex = now.difference(start).inDays + 1;
}
    restartCount = userData?["restartCount"] ?? 0;

    if (!mounted) return;

    setState(() {
      totalDone = done;
      totalExercises = total;
      chartData = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress =
        totalExercises == 0 ? 0 : totalDone / totalExercises;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),

        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Özet"),
            Tab(text: "Grafik"),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          /// 📊 SUMMARY TAB
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                GlassCard(
                  child: Column(
                    children: [
                      const Text(
                        "Genel İlerleme",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white12,
                        valueColor:
                            const AlwaysStoppedAnimation(
                                Colors.green),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "$totalDone / $totalExercises",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                GlassCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.local_fire_department,
                          color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        "$streak gün streak",
                        style: const TextStyle(color: Colors.white),
                      ),
                    
                    ],
                  ),
                ),
  const SizedBox(height: 10),
                 GlassCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     
                      const SizedBox(width: 8),
                      
                      Text("📅 $dayIndex. gün",  style: const TextStyle(color: Colors.white),),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                /// 🔁 RESET COUNT
                GlassCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.refresh,
                          color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        "$restartCount kez program yeniden başlatıldı",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// 📈 GRAPH TAB
          Padding(
            padding: const EdgeInsets.all(16),
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: (chartData.length - 1)
                    .clamp(0, 999)
                    .toDouble(),
                minY: 0,
                maxY: (chartData.isEmpty)
                    ? 1
                    : chartData
                            .map((e) => e.y)
                            .reduce((a, b) =>
                                a > b ? a : b) +
                        2,

                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: Colors.white10,
                      strokeWidth: 1,
                    );
                  },
                ),

                titlesData: FlTitlesData(
                  show: true,

                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          "H${value.toInt() + 1}",
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),

                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),

                  rightTitles: const AxisTitles(
                    sideTitles:
                        SideTitles(showTitles: false),
                  ),

                  topTitles: const AxisTitles(
                    sideTitles:
                        SideTitles(showTitles: false),
                  ),
                ),

                borderData: FlBorderData(
                  show: true,
                  border:
                      Border.all(color: Colors.white10),
                ),

                lineBarsData: [
                  LineChartBarData(
                    spots: chartData,
                    isCurved: true,
                    color: Colors.greenAccent,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.green.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}