import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/body_record.dart';
import '../services/body_service.dart';

class BodyTrackingScreen extends StatefulWidget {
  const BodyTrackingScreen({super.key});

  @override
  State<BodyTrackingScreen> createState() => _BodyTrackingScreenState();
}

class _BodyTrackingScreenState extends State<BodyTrackingScreen> {

  List<BodyRecord> records = [];

  final weightController = TextEditingController();
  final waistController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadRecords();
  }

  Future<void> loadRecords() async {
    records = await BodyService.getRecords();
    setState(() {});
  }

  Future<void> addRecord() async {

    if (weightController.text.isEmpty || waistController.text.isEmpty) {
      return;
    }

    final record = BodyRecord(
      date: DateTime.now(),
      weight: double.parse(weightController.text),
      waist: double.parse(waistController.text),
    );

    await BodyService.addRecord(record);

    weightController.clear();
    waistController.clear();

    loadRecords();
  }

  List<FlSpot> getWeightSpots() {
    return records.asMap().entries.map((e) {
      return FlSpot(
        e.key.toDouble(),
        e.value.weight,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Body Tracking"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 📥 INPUTLAR
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Kilo (kg)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: waistController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Bel (cm)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: addRecord,
              child: const Text("Kaydet"),
            ),

            const SizedBox(height: 20),

            // 📊 GRAFİK
            if (records.isNotEmpty)
              SizedBox(
                height: 220,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: true),

                    titlesData: const FlTitlesData(show: false),

                    borderData: FlBorderData(show: true),

                    lineBarsData: [
                      LineChartBarData(
                        spots: getWeightSpots(),
                        isCurved: true,
                        barWidth: 3,
                        color: Colors.blue,
                        dotData: const FlDotData(show: true),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // 📋 LİSTE
            Expanded(
              child: records.isEmpty
                  ? const Center(
                      child: Text("Henüz kayıt yok"),
                    )
                  : ListView.builder(
                      itemCount: records.length,
                      itemBuilder: (context, index) {

                        final r = records[index];

                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.monitor_weight),
                            title: Text("${r.weight} kg"),
                            subtitle: Text("Bel: ${r.waist} cm"),
                            trailing: Text(
                              "${r.date.day}.${r.date.month}",
                            ),
                          ),
                        );
                      },
                    ),
            ),

          ],
        ),
      ),
    );
  }
}