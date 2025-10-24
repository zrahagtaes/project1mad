//workout logging screen for users to add workouts they have completed
import 'package:flutter/material.dart';
import '../models/workout_entry.dart';
import '../widgets/number_field.dart';

class WorkoutLogScreen extends StatefulWidget {
  const WorkoutLogScreen({
    super.key,
    this.presetName,
    this.presetReps,
    this.presetWeight,
    this.presetDurationMin,
  });

  final String? presetName;
  final int? presetReps;
  final double? presetWeight;
  final int? presetDurationMin;

  @override
  State<WorkoutLogScreen> createState() => _WorkoutLogScreenState();
}

class _WorkoutLogScreenState extends State<WorkoutLogScreen> {
  final _name = TextEditingController();
  final _reps = TextEditingController();
  final _weight = TextEditingController();
  final _duration = TextEditingController();

  // Temporary in-memory list for Milestone 1
  final List<WorkoutEntry> _items = [];

  @override
  void initState() {
    super.initState();
    // Prefill from preset if provided
    if (widget.presetName != null) _name.text = widget.presetName!;
    if (widget.presetReps != null) _reps.text = widget.presetReps!.toString();
    if (widget.presetWeight != null)
      _weight.text = widget.presetWeight!.toString();
    if (widget.presetDurationMin != null)
      _duration.text = widget.presetDurationMin!.toString();
  }

  void _add() {
    final name = _name.text.trim();
    final reps = int.tryParse(_reps.text);
    final weight = double.tryParse(_weight.text);
    final duration = int.tryParse(
      _duration.text.isEmpty ? '0' : _duration.text,
    );

    if (name.isEmpty || reps == null || weight == null || duration == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill all fields with valid numbers.')),
      );
      return;
    }

    setState(() {
      _items.add(
        WorkoutEntry(
          date: DateTime.now(),
          name: name,
          reps: reps,
          weight: weight,
          durationMin: duration,
        ),
      );
      _name.clear();
      _reps.clear();
      _weight.clear();
      _duration.clear();
    });
  }

  void _removeAt(int index) {
    setState(() => _items.removeAt(index));
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
            NumberField(
              controller: _weight,
              label: 'Weight',
              suffix: 'units',
              allowDecimal: true,
            ),
            const SizedBox(height: 8),
            NumberField(
              controller: _duration,
              label: 'Duration',
              suffix: 'min',
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: _add, child: const Text('Add Workout')),
            const SizedBox(height: 16),
            const Divider(),
            const Text(
              'Entries',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...List.generate(_items.length, (i) {
              final e = _items[i];
              return Dismissible(
                key: ValueKey('${e.date.toIso8601String()}_$i'),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => _removeAt(i),
                background: Container(
                  alignment: Alignment.centerRight,
                  color: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: ListTile(
                  title: Text('${e.name} • ${e.reps} reps @ ${e.weight}'),
                  subtitle: Text('Duration ${e.durationMin} min'),
                  trailing: Text(
                    '${e.date.month}/${e.date.day}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }),
            if (_items.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('No workouts yet.'),
              ),
          ],
        ),
      ),
    );
  }
}
