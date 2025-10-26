import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  String _selectedType = 'Custom';
  String _selectedWorkout = 'Weightlifting';
  final List<String> _typeOptions = ['Custom', 'Preset'];
  final List<String> _workoutTypes = ['Weightlifting', 'Running', 'Swimming'];

  final List<Map<String, String>> _completedExercises = [];
  final _exerciseNameController = TextEditingController();
  final _weightController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _distanceController = TextEditingController();
  final _paceController = TextEditingController();

  List<String> _presetWorkouts = [];
  String _difficulty = '';

  @override
  void dispose() {
    _exerciseNameController.dispose();
    _weightController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _distanceController.dispose();
    _paceController.dispose();
    super.dispose();
  }

  void _addExercise() {
    final name = _exerciseNameController.text.trim();
    final weight = _weightController.text.trim();
    final sets = _setsController.text.trim();
    final reps = _repsController.text.trim();
    if (name.isNotEmpty && sets.isNotEmpty && reps.isNotEmpty) {
      setState(() {
        _completedExercises.add({'name': name, 'weight': weight, 'sets': sets, 'reps': reps});
        _exerciseNameController.clear();
        _weightController.clear();
        _setsController.clear();
        _repsController.clear();
      });
    }
  }

  void _generatePresetWorkout(String level) {
    _difficulty = level;
    List<String> workout = [];
    if (_selectedWorkout == 'Weightlifting') {
      workout = (level == 'Easy')
          ? ['Push-Ups', 'Squats']
          : (level == 'Intermediate')
              ? ['Bench Press', 'Deadlifts']
              : ['Squats', 'Overhead Press', 'Deadlifts'];
    } else if (_selectedWorkout == 'Running') {
      workout = (level == 'Easy')
          ? ['1 mile jog']
          : (level == 'Intermediate')
              ? ['3 mile run']
              : ['5 mile tempo run'];
    } else {
      workout = (level == 'Easy')
          ? ['200m freestyle']
          : (level == 'Intermediate')
              ? ['400m medley']
              : ['800m freestyle'];
    }

    setState(() {
      _presetWorkouts = workout;
    });
  }

  Future<void> _saveWorkout() async {
    final db = DatabaseHelper.instance;

    if (_selectedType == 'Custom') {
      for (var ex in _completedExercises) {
        await db.insert('workouts', {
          'workoutType': _selectedWorkout,
          'name': ex['name'],
          'weight': ex['weight'],
          'sets': ex['sets'],
          'reps': ex['reps'],
          'difficulty': '',
          'createdAt': DateTime.now().toIso8601String(),
        });
      }
    } else if (_selectedType == 'Preset') {
      await db.insert('workouts', {
        'workoutType': _selectedWorkout,
        'name': 'Preset $_difficulty',
        'weight': '',
        'sets': '',
        'reps': '',
        'difficulty': _difficulty,
        'createdAt': DateTime.now().toIso8601String(),
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workout saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF001F3F);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: _selectedType,
            decoration: const InputDecoration(labelText: 'Type'),
            items: _typeOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (value) => setState(() => _selectedType = value!),
          ),
          const SizedBox(height: 15),
          DropdownButtonFormField<String>(
            value: _selectedWorkout,
            decoration: const InputDecoration(labelText: 'Workout Category'),
            items: _workoutTypes.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (value) => setState(() => _selectedWorkout = value!),
          ),
          const SizedBox(height: 20),
          if (_selectedType == 'Custom')
            Column(
              children: [
                for (var ex in _completedExercises)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      '${ex['name']}, Weight: ${ex['weight']} | Sets: ${ex['sets']}, Reps: ${ex['reps']}',
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                TextField(controller: _exerciseNameController, decoration: const InputDecoration(labelText: 'Exercise Name')),
                const SizedBox(height: 10),
                TextField(controller: _weightController, decoration: const InputDecoration(labelText: 'Weight')),
                const SizedBox(height: 10),
                TextField(controller: _setsController, decoration: const InputDecoration(labelText: 'Sets')),
                const SizedBox(height: 10),
                TextField(controller: _repsController, decoration: const InputDecoration(labelText: 'Reps')),
                const SizedBox(height: 15),
                IconButton(onPressed: _addExercise, icon: const Icon(Icons.add_circle_outline, color: navy), iconSize: 36),
              ],
            )
          else
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(onPressed: () => _generatePresetWorkout('Easy'), style: ElevatedButton.styleFrom(backgroundColor: navy), child: const Text('Easy')),
                    ElevatedButton(onPressed: () => _generatePresetWorkout('Intermediate'), style: ElevatedButton.styleFrom(backgroundColor: navy), child: const Text('Intermediate')),
                    ElevatedButton(onPressed: () => _generatePresetWorkout('Hard'), style: ElevatedButton.styleFrom(backgroundColor: navy), child: const Text('Hard')),
                  ],
                ),
                const SizedBox(height: 15),
                for (var ex in _presetWorkouts)
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(ex, style: const TextStyle(fontSize: 16)),
                  ),
              ],
            ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _saveWorkout,
            style: ElevatedButton.styleFrom(backgroundColor: navy, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14)),
            child: const Text('Save Workout', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
