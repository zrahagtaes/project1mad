//chart showing weekly calorie processing. milestone 2 will addd real data from sqlite. will also add workouts possibly

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/calorie_entry.dart';
import '../models/workout_entry.dart';
import '../services/storage_service.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  bool _loading = true;

  List<CalorieEntry> _calories = [];
  List<WorkoutEntry> _workouts = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final store = StorageService();
    final cals = await store.loadCalories();
    final workouts = await store.loadWorkouts();

    setState(() {
      _calories = cals;
      _workouts = workouts;
      _loading = false;
    });
  }

  // calories by day for last 7 days
  Map<String, int> _dailyCalories() {
    final now = DateTime.now();
    final Map<String, int> sums = {};
    for (final e in _calories) {
      final diff = now.difference(e.date).inDays;
      if (diff < 7) {
        final key = '${e.date.year}-${e.date.month}-${e.date.day}';
        sums[key] = (sums[key] ?? 0) + e.calories;
      }
    }
    return sums;
  }

  // workouts by week for last 8 weeks
  DateTime _startOfWeekSunday(DateTime d) {
    final offset = d.weekday % 7; // Sunday = 0
    final base = DateTime(
      d.year,
      d.month,
      d.day,
    ).subtract(Duration(days: offset));
    return DateTime(base.year, base.month, base.day);
  }

  List<DateTime> _lastNWeekStarts(int n) {
    final now = DateTime.now();
    final currentWeek = _startOfWeekSunday(now);
    return List.generate(
      n,
      (i) => currentWeek.subtract(Duration(days: 7 * (n - 1 - i))),
    );
  }

  Map<DateTime, int> _weeklyWorkoutCounts() {
    final Map<DateTime, int> counts = {};
    final now = DateTime.now();
    for (final e in _workouts) {
      final diff = now.difference(e.date).inDays;
      if (diff < 56) {
        // last 8 weeks
        final wk = _startOfWeekSunday(e.date);
        counts[wk] = (counts[wk] ?? 0) + 1;
      }
    }
    for (final wk in _lastNWeekStarts(8)) {
      counts[wk] = counts[wk] ?? 0;
    }
    return counts;
  }

  // chart builders
  List<BarChartGroupData> _barsFromDailyCalories(Map<String, int> data) {
    final now = DateTime.now();
    final List<BarChartGroupData> groups = [];
    for (int i = 6; i >= 0; i--) {
      final d = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: i));
      final key = '${d.year}-${d.month}-${d.day}';
      final val = (data[key] ?? 0).toDouble();
      final x = 6 - i;
      groups.add(
        BarChartGroupData(
          x: x,
          barRods: [BarChartRodData(toY: val)],
        ),
      );
    }
    return groups;
  }

  List<BarChartGroupData> _barsFromWeeklyCounts(Map<DateTime, int> data) {
    final weeks = _lastNWeekStarts(8);
    return List.generate(weeks.length, (i) {
      final wk = weeks[i];
      final val = (data[wk] ?? 0).toDouble();
      return BarChartGroupData(
        x: i,
        barRods: [BarChartRodData(toY: val)],
      );
    });
  }

  String _weekLabel(DateTime wkStart) {
    return '${wkStart.month}/${wkStart.day}';
    // shows like "10/14" for date
  }

  Widget _chartCard({required String title, required Widget chart}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(height: 220, child: chart),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dailyCals = _dailyCalories();
    final weeklyWorkouts = _weeklyWorkoutCounts();
    final weekStarts = _lastNWeekStarts(8);

    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _StatCard(
                    title: 'Total Workouts',
                    value: _workouts.length.toString(),
                  ),
                  const SizedBox(height: 12),
                  _StatCard(
                    title: 'Total Calories Logs',
                    value: _calories.length.toString(),
                  ),
                  const SizedBox(height: 12),

                  // daily calorie chart
                  _chartCard(
                    title: 'Calories (last 7 days)',
                    chart: BarChart(
                      BarChartData(
                        barGroups: _barsFromDailyCalories(dailyCals),
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
                              reservedSize: 40,
                              interval: 500,
                              getTitlesWidget: (v, _) =>
                                  Text(v.toInt().toString()),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (v, _) {
                                const days = [
                                  'M',
                                  'T',
                                  'W',
                                  'T',
                                  'F',
                                  'S',
                                  'S',
                                ];
                                final i = v.toInt();
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(days[i % 7]),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // weekly workouts chart
                  _chartCard(
                    title: 'Workouts Logged (per week)',
                    chart: BarChart(
                      BarChartData(
                        barGroups: _barsFromWeeklyCounts(weeklyWorkouts),
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
                              reservedSize: 36,
                              interval: 1,
                              getTitlesWidget: (v, _) =>
                                  Text(v.toInt().toString()),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (v, _) {
                                final i = v.toInt();
                                if (i < 0 || i >= weekStarts.length) {
                                  return const SizedBox.shrink();
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(_weekLabel(weekStarts[i])),
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
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
