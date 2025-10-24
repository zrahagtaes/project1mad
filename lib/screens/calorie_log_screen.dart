//calorie logging screen, has the ability to add, view, and delete calories
// as stated in the proposal

import 'package:flutter/material.dart';
import '../models/calorie_entry.dart';
import '../widgets/number_field.dart';

class CalorieLogScreen extends StatefulWidget {
  const CalorieLogScreen({super.key});
  @override
  State<CalorieLogScreen> createState() => _CalorieLogScreenState();
}

class _CalorieLogScreenState extends State<CalorieLogScreen> {
  final _cal = TextEditingController();
  final _p = TextEditingController();
  final _c = TextEditingController();
  final _f = TextEditingController();

  // Temporary in-memory list for Milestone 1
  final List<CalorieEntry> _items = [];

  void _add() {
    final cal = int.tryParse(_cal.text);
    final p = int.tryParse(_p.text);
    final c = int.tryParse(_c.text);
    final f = int.tryParse(_f.text);
    if (cal == null || p == null || c == null || f == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter numbers only.')));
      return;
    }
    setState(() {
      _items.add(
        CalorieEntry(
          date: DateTime.now(),
          calories: cal,
          protein: p,
          carbs: c,
          fat: f,
        ),
      );
      _cal.clear();
      _p.clear();
      _c.clear();
      _f.clear();
    });
  }

  void _removeAt(int index) {
    setState(() => _items.removeAt(index));
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
                  title: Text('${e.calories} kcal'),
                  subtitle: Text(
                    'P ${e.protein}g • C ${e.carbs}g • F ${e.fat}g',
                  ),
                  trailing: Text('${e.date.month}/${e.date.day}'),
                ),
              );
            }),
            if (_items.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('No entries yet.'),
              ),
          ],
        ),
      ),
    );
  }
}
