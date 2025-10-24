//chart showing weekly calorie processing. milestone 2 will addd real data from sqlite. will also add workouts possibly

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  // Static data for Milestone 1
  List<BarChartGroupData> _weeklyCalories() {
    // Mon..Sun calories (static example)
    final values = [1800, 1950, 2100, 2000, 2200, 1900, 2050];
    return List.generate(values.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [BarChartRodData(toY: values[i].toDouble())],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Weekly Calories (static)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 220,
                      child: BarChart(
                        BarChartData(
                          barGroups: _weeklyCalories(),
                          borderData: FlBorderData(show: false),
                          gridData: const FlGridData(show: false),
                          titlesData: FlTitlesData(
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 38,
                                interval: 500,
                                getTitlesWidget: (v, meta) =>
                                    Text(v.toInt().toString()),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (v, meta) {
                                  final i = v.toInt();
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      i >= 0 && i < days.length ? days[i] : '',
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tip: This chart is static for Milestone 1. In M2 we’ll load real history from SQLite.',
            ),
          ],
        ),
      ),
    );
  }
}
