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
      if (level == 'Easy') {
        workout = ['Push-Ups', 'Squats', 'Curls'];
      } else if (level == 'Intermediate') {
        workout = ['Bench Press', 'Deadlifts', 'Shoulder Press'];
      } else {
        workout = ['Squats', 'Deadlifts', 'Overhead Press', 'Pull-Ups'];
      }
    } else if (_selectedWorkout == 'Running') {
      if (level == 'Easy') {
        workout = ['1 mile jog'];
      } else if (level == 'Intermediate') {
        workout = ['3 mile run'];
      } else {
        workout = ['5 mile tempo run', 'Hill sprints'];
      }
    } else if (_selectedWorkout == 'Swimming') {
      if (level == 'Easy') {
        workout = ['200m freestyle'];
      } else if (level == 'Intermediate') {
        workout = ['400m medley'];
      } else {
        workout = ['800m freestyle', '400m pull buoy'];
      }
    }
    setState(() => _presetWorkouts = workout);
  }

  Future<void> _saveWorkout() async {
    String combinedNames = '';
    if (_selectedType == 'Custom') {
      combinedNames = _completedExercises.map((ex) => ex['name'] ?? '').join(' ');
    } else {
      combinedNames = _difficulty;
    }
    await DatabaseHelper.instance.insert('workouts', {
      'workoutType': _selectedWorkout,
      'name': combinedNames,
      'weight': '',
      'sets': '',
      'reps': '',
      'difficulty': _selectedType == 'Preset' ? _difficulty : '',
    });
    setState(() {
      _completedExercises.clear();
      _presetWorkouts.clear();
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Workout saved')));
  }

  Widget _buildWeightliftingForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        const SizedBox(height: 10),
        TextField(controller: _exerciseNameController, decoration: const InputDecoration(labelText: 'Exercise Name')),
        const SizedBox(height: 10),
        TextField(controller: _weightController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Weight')),
        const SizedBox(height: 10),
        TextField(controller: _setsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Sets')),
        const SizedBox(height: 10),
        TextField(controller: _repsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Reps')),
        const SizedBox(height: 15),
        Center(
          child: IconButton(
            onPressed: _addExercise,
            icon: const Icon(Icons.add_circle_outline, color: Color(0xFF001F3F)),
            iconSize: 36,
          ),
        ),
      ],
    );
  }

  Widget _buildRunningSwimmingForm() {
    return Column(
      children: [
        TextField(controller: _distanceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Distance')),
        const SizedBox(height: 15),
        TextField(controller: _paceController, keyboardType: TextInputType.text, decoration: const InputDecoration(labelText: 'Pace')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF001F3F);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedType,
            decoration: const InputDecoration(labelText: 'Type'),
            items: _typeOptions.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
            onChanged: (v) => setState(() {
              _selectedType = v!;
              _presetWorkouts.clear();
              _completedExercises.clear();
            }),
          ),
          const SizedBox(height: 15),
          DropdownButtonFormField<String>(
            value: _selectedWorkout,
            decoration: const InputDecoration(labelText: 'Workout Category'),
            items: _workoutTypes.map((w) => DropdownMenuItem(value: w, child: Text(w))).toList(),
            onChanged: (v) => setState(() {
              _selectedWorkout = v!;
              _presetWorkouts.clear();
              _completedExercises.clear();
            }),
          ),
          const SizedBox(height: 20),
          if (_selectedType == 'Custom') ...[
            if (_selectedWorkout == 'Weightlifting') _buildWeightliftingForm(),
            if (_selectedWorkout == 'Running' || _selectedWorkout == 'Swimming') _buildRunningSwimmingForm(),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () => _generatePresetWorkout('Easy'), style: ElevatedButton.styleFrom(backgroundColor: navy), child: const Text('Easy')),
                ElevatedButton(onPressed: () => _generatePresetWorkout('Intermediate'), style: ElevatedButton.styleFrom(backgroundColor: navy), child: const Text('Intermediate')),
                ElevatedButton(onPressed: () => _generatePresetWorkout('Hard'), style: ElevatedButton.styleFrom(backgroundColor: navy), child: const Text('Hard')),
              ],
            ),
            const SizedBox(height: 25),
            for (var ex in _presetWorkouts)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(ex, style: const TextStyle(fontSize: 16, color: Colors.black87)),
              ),
          ],
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: _saveWorkout,
              style: ElevatedButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save Workout', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
