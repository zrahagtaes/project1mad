import 'package:flutter/material.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  String _selectedType = 'Workout';
  String _selectedMetric = 'Weights';

  final List<String> _types = ['Workout', 'Calories'];

  final Map<String, List<String>> _metrics = {
    'Workout': ['Weights', 'Runs', 'Swims'],
    'Calories': ['Calories', 'Protein', 'Fat', 'Carbs'],
  };

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
            items: _types
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedType = value!;
                _selectedMetric = _metrics[_selectedType]!.first;
              });
            },
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _selectedMetric,
            decoration: const InputDecoration(labelText: 'Metric'),
            items: _metrics[_selectedType]!
                .map((metric) => DropdownMenuItem(
                      value: metric,
                      child: Text(metric),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedMetric = value!;
              });
            },
          ),
          const SizedBox(height: 30),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Center(
              child: Text(
                'Progress data for $_selectedMetric ($_selectedType)',
                style: const TextStyle(fontSize: 18, color: navy),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
