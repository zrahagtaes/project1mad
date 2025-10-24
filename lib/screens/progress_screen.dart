// lib/screens/progress_screen.dart
import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/calorie_entry.dart';
import '../models/workout_entry.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final _service = StorageService();
  List<CalorieEntry> _cals = [];
  List<WorkoutEntry> _wos = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final c = await _service.loadCalories();
    final w = await _service.loadWorkouts();
    setState(() {
      _cals = c;
      _wos = w;
    });
  }

  int get totalCalories => _cals.fold(0, (a, b) => a + b.calories);
  int get totalWorkouts => _wos.length;
  int get totalReps => _wos.fold(0, (a, b) => a + b.reps);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _StatCard(
              title: 'Total Calories Logged',
              value: '$totalCalories kcal',
            ),
            const SizedBox(height: 12),
            _StatCard(title: 'Total Workouts', value: '$totalWorkouts'),
            const SizedBox(height: 12),
            _StatCard(title: 'Total Reps', value: '$totalReps'),
            const SizedBox(height: 24),
            const Text(
              'Tip: Add entries in the other tabs to see these numbers grow.',
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
