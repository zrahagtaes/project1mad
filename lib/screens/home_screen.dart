// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'calorie_log_screen.dart';
import 'workout_log_screen.dart';
import 'progress_screen.dart';
import 'preset_routines_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fitness Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _NavButton(
              text: 'Calorie Tracker',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CalorieLogScreen()),
              ),
            ),
            const SizedBox(height: 12),
            _NavButton(
              text: 'Workout Tracker',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WorkoutLogScreen()),
              ),
            ),
            const SizedBox(height: 12),
            _NavButton(
              text: 'Progress',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProgressScreen()),
              ),
            ),
            const SizedBox(height: 12),
            _NavButton(
              text: 'Preset Routines',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PresetRoutinesScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _NavButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(text, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
