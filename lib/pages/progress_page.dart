import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  String _selectedType = 'Food';
  final List<String> _types = ['Food', 'Workouts'];
  int _foodLogs = 0;
  int _weightLogs = 0;
  int _runLogs = 0;
  int _swimLogs = 0;

  @override
  void initState() {
    super.initState();
    _loadProgressData();
  }

  Future<void> _loadProgressData() async {
    final calories = await DatabaseHelper.instance.fetchAll('calories');
    final workouts = await DatabaseHelper.instance.fetchAll('workouts');
    int weight = 0, runs = 0, swims = 0;
    for (final entry in workouts) {
      final type = (entry['workoutType'] ?? '').toString().toLowerCase();
      if (type.contains('weight')) {
        weight++;
      } else if (type.contains('run')) {
        runs++;
      } else if (type.contains('swim')) {
        swims++;
      }
    }
    setState(() {
      _foodLogs = calories.length;
      _weightLogs = weight;
      _runLogs = runs;
      _swimLogs = swims;
    });
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
            items: _types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
            onChanged: (v) => setState(() => _selectedType = v!),
          ),
          const SizedBox(height: 25),
          if (_selectedType == 'Food') ...[
            _buildStatCard('Food Logs', _foodLogs.toString(), navy),
          ] else ...[
            _buildStatCard('Weightlifting Logs', _weightLogs.toString(), navy),
            _buildStatCard('Running Logs', _runLogs.toString(), navy),
            _buildStatCard('Swimming Logs', _swimLogs.toString(), navy),
          ],
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: _loadProgressData,
              style: ElevatedButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Refresh', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: color)),
          Text(value, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
