import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class CaloriesPage extends StatefulWidget {
  const CaloriesPage({super.key});

  @override
  State<CaloriesPage> createState() => _CaloriesPageState();
}

class _CaloriesPageState extends State<CaloriesPage> {
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _fatsController = TextEditingController();
  final _carbsController = TextEditingController();
  final _proteinController = TextEditingController();
  String _selectedMeal = 'Breakfast';
  final List<String> _mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _fatsController.dispose();
    _carbsController.dispose();
    _proteinController.dispose();
    super.dispose();
  }

  Future<void> _saveToDatabase() async {
    await DatabaseHelper.instance.insert('calories', {
      'name': _nameController.text.trim(),
      'calories': int.tryParse(_caloriesController.text) ?? 0,
      'fats': int.tryParse(_fatsController.text) ?? 0,
      'carbs': int.tryParse(_carbsController.text) ?? 0,
      'protein': int.tryParse(_proteinController.text) ?? 0,
      'mealType': _selectedMeal,
      'createdAt': DateTime.now().toIso8601String(),
    });

    _nameController.clear();
    _caloriesController.clear();
    _fatsController.clear();
    _carbsController.clear();
    _proteinController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Calories entry saved!')),
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
          TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
          const SizedBox(height: 15),
          TextField(controller: _caloriesController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Calories')),
          const SizedBox(height: 15),
          TextField(controller: _fatsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Fats')),
          const SizedBox(height: 15),
          TextField(controller: _carbsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Carbs')),
          const SizedBox(height: 15),
          TextField(controller: _proteinController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Protein')),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _selectedMeal,
            decoration: const InputDecoration(labelText: 'Meal Type'),
            items: _mealTypes.map((meal) => DropdownMenuItem(value: meal, child: Text(meal))).toList(),
            onChanged: (value) => setState(() => _selectedMeal = value!),
          ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: _saveToDatabase,
              style: ElevatedButton.styleFrom(
                backgroundColor: navy,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save Entry', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
