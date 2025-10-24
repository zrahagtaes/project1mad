// lib/screens/workout_log_screen.dart
import 'package:flutter/material.dart';
import '../models/workout_entry.dart';
import '../services/storage_service.dart';
import '../widgets/number_field.dart';

class WorkoutLogScreen extends StatefulWidget {
  const WorkoutLogScreen({super.key});

  @override
  State<WorkoutLogScreen> createState() => _WorkoutLogScreenState();
}

class _WorkoutLogScreenState extends State<WorkoutLogScreen> {
  final _service = StorageService();

  final _name = TextEditingController();
  final _reps = TextEditingController();
  final _weight = TextEditingController();
  final _duration = TextEditingController();

  List<WorkoutEntry> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await _service.loadWorkouts();
    setState(() => _items = data);
  }

  Future<void> _add() async {
    final name = _name.text.trim();
    final reps = int.tryParse(_reps.text);
    final weight = double.tryParse(_weight.text);
    final duration = int.tryParse(_duration.text.isEmpty ? '0' : _duration.text);

    if (name.isEmpty) {
      _error('Please enter a workout name.');
      return;
    }
    if (reps == null) {
      _error('Reps must be a number.');
      return;
    }
    if (weight == null) {
      _error('Weight must be a number.');
      return;
    }
    if (duration == null) {
      _error('Duration must be a number.');
      return;
    }

    final entry = WorkoutEntry(
      date: DateTime.now(),
      name: name,
      reps: reps,
      weight: weight,
      durationMin: duration,
    );

    final next = [..._items, entry];
    await _service.saveWorkouts(next);
    setState(() {
      _items = next;
      _name.clear(); _reps.clear(); _weight.clear(); _duration.clear();
    });
  }

  void _error(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Log')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Workout Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            NumberField(controller: _reps, label: 'Reps'),
            const SizedBox(height: 8),
            NumberField(controller: _weight, label: 'Weight', suffix: 'units', allowDecimal: true),
            const SizedBox(height: 8),
            NumberField(controller: _duration, label: 'Duration', suffix: 'min'),
            const SizedBox(height: 12),
            FilledButton(onPressed: _add, child: const Text('Add Workout')),
            const SizedBox(height: 16),
            const Divider(),
            const Text('Entries', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._items.reversed.map((e) => ListTile(
                  title: Text('${e.name} • ${e.reps} reps @ ${e.weight}'),
                  subtitle: Text('Duration ${e.durationMin} min'),
                  trailing: Text('${e.date.month}/${e.date.day}'),
                )),
          ],
        ),
      ),
    );
  }
}
