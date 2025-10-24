// lib/screens/calorie_log_screen.dart
import 'package:flutter/material.dart';
import '../models/calorie_entry.dart';
import '../services/storage_service.dart';
import '../widgets/number_field.dart';

class CalorieLogScreen extends StatefulWidget {
  const CalorieLogScreen({super.key});

  @override
  State<CalorieLogScreen> createState() => _CalorieLogScreenState();
}

class _CalorieLogScreenState extends State<CalorieLogScreen> {
  final _service = StorageService();
  final _cal = TextEditingController();
  final _p = TextEditingController();
  final _c = TextEditingController();
  final _f = TextEditingController();

  List<CalorieEntry> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await _service.loadCalories();
    setState(() => _items = data);
  }

  Future<void> _add() async {
    final cal = int.tryParse(_cal.text);
    final p = int.tryParse(_p.text);
    final c = int.tryParse(_c.text);
    final f = int.tryParse(_f.text);

    if (cal == null || p == null || c == null || f == null) {
      _showError('Please enter numbers only.');
      return;
    }

    final entry = CalorieEntry(
      date: DateTime.now(),
      calories: cal,
      protein: p,
      carbs: c,
      fat: f,
    );
    final next = [..._items, entry];
    await _service.saveCalories(next);
    setState(() {
      _items = next;
      _cal.clear(); _p.clear(); _c.clear(); _f.clear();
    });
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Calorie Log')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            NumberField(controller: _cal, label: 'Calories'),
            const SizedBox(height: 8),
            NumberField(controller: _p, label: 'Protein', suffix: 'g'),
            const SizedBox(height: 8),
            NumberField(controller: _c, label: 'Carbs', suffix: 'g'),
            const SizedBox(height: 8),
            NumberField(controller: _f, label: 'Fat', suffix: 'g'),
            const SizedBox(height: 12),
            FilledButton(onPressed: _add, child: const Text('Add Entry')),
            const SizedBox(height: 16),
            const Divider(),
            const Text('Entries', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._items.reversed.map((e) => ListTile(
                  title: Text('${e.calories} kcal'),
                  subtitle: Text('P ${e.protein}g • C ${e.carbs}g • F ${e.fat}g'),
                  trailing: Text('${e.date.month}/${e.date.day}'),
                )),
          ],
        ),
      ),
    );
  }
}
