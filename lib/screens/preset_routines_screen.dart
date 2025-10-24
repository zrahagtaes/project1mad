//offers preset workout routines for users to choose from
//and log directly to their workout log

import 'package:flutter/material.dart';
import 'workout_log_screen.dart';

class PresetRoutinesScreen extends StatelessWidget {
  const PresetRoutinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simple preset data: level -> list of exercises
    final easy = <_ExercisePreset>[
      _ExercisePreset(
        name: 'Bodyweight Squats',
        reps: 12,
        weight: 0,
        durationMin: 0,
      ),
      _ExercisePreset(
        name: 'Knee Push-ups',
        reps: 10,
        weight: 0,
        durationMin: 0,
      ),
      _ExercisePreset(
        name: 'Glute Bridges',
        reps: 12,
        weight: 0,
        durationMin: 0,
      ),
      _ExercisePreset(name: 'Plank', reps: 1, weight: 0, durationMin: 1),
    ];
    final intermediate = <_ExercisePreset>[
      _ExercisePreset(
        name: 'Goblet Squats',
        reps: 10,
        weight: 20,
        durationMin: 0,
      ),
      _ExercisePreset(name: 'Push-ups', reps: 12, weight: 0, durationMin: 0),
      _ExercisePreset(
        name: 'Bent-over Rows (DB)',
        reps: 10,
        weight: 15,
        durationMin: 0,
      ),
      _ExercisePreset(
        name: 'Side Plank (each)',
        reps: 1,
        weight: 0,
        durationMin: 1,
      ),
    ];
    final advanced = <_ExercisePreset>[
      _ExercisePreset(
        name: 'Barbell Back Squat',
        reps: 5,
        weight: 95,
        durationMin: 0,
      ),
      _ExercisePreset(name: 'Bench Press', reps: 5, weight: 75, durationMin: 0),
      _ExercisePreset(name: 'Deadlift', reps: 5, weight: 115, durationMin: 0),
      _ExercisePreset(
        name: 'Row Intervals',
        reps: 1,
        weight: 0,
        durationMin: 10,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Preset Routines')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _LevelSection(title: 'Easy', items: easy),
          const SizedBox(height: 16),
          _LevelSection(title: 'Intermediate', items: intermediate),
          const SizedBox(height: 16),
          _LevelSection(title: 'Advanced', items: advanced),
        ],
      ),
    );
  }
}

class _LevelSection extends StatelessWidget {
  final String title;
  final List<_ExercisePreset> items;
  const _LevelSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        children: items.map((e) => _ExerciseTile(preset: e)).toList(),
      ),
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  final _ExercisePreset preset;
  const _ExerciseTile({required this.preset});

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      if (preset.reps > 0) 'Reps: ${preset.reps}',
      if (preset.weight > 0) 'Weight: ${preset.weight}',
      if (preset.durationMin > 0) 'Duration: ${preset.durationMin} min',
    ].join(' • ');

    return ListTile(
      title: Text(preset.name),
      subtitle: Text(subtitle.isEmpty ? 'Bodyweight / time-based' : subtitle),
      trailing: FilledButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WorkoutLogScreen(
                presetName: preset.name,
                presetReps: preset.reps,
                presetWeight: preset.weight,
                presetDurationMin: preset.durationMin,
              ),
            ),
          );
        },
        child: const Text('Log this'),
      ),
    );
  }
}

class _ExercisePreset {
  final String name;
  final int reps;
  final double weight;
  final int durationMin;
  const _ExercisePreset({
    required this.name,
    required this.reps,
    required this.weight,
    required this.durationMin,
  });
}
