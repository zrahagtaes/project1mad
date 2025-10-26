import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../db/database_helper.dart';

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Calories', 'Workouts'];
  List<Map<String, dynamic>> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final db = DatabaseHelper.instance;
    List<Map<String, dynamic>> all = [];
    if (_selectedFilter == 'All' || _selectedFilter == 'Calories') {
      final cal = await db.fetchAll('calories');
      all.addAll(cal.map((e) => {'type': 'calories', ...e}));
    }
    if (_selectedFilter == 'All' || _selectedFilter == 'Workouts') {
      final wo = await db.fetchAll('workouts');
      all.addAll(wo.map((e) => {'type': 'workout', ...e}));
    }
    setState(() => _entries = all);
  }

  Future<void> _deleteLog(Map<String, dynamic> entry) async {
    final table = entry['type'] == 'workout' ? 'workouts' : 'calories';
    final id = entry['id'] as int;
    await DatabaseHelper.instance.deleteById(table, id);
    setState(
      () => _entries.removeWhere(
        (e) => e['id'] == id && e['type'] == entry['type'],
      ),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Log deleted'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF001F3F);
    const gray = Colors.black54;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedFilter,
            decoration: const InputDecoration(labelText: 'Logs'),
            items: _filters
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) {
              setState(() => _selectedFilter = v!);
              _loadLogs();
            },
          ),
          const SizedBox(height: 25),
          if (_entries.isEmpty)
            const Center(
              child: Text(
                'Go log Something',
                style: TextStyle(fontSize: 16, color: gray),
              ),
            )
          else
            Column(
              children: _entries.map((entry) {
                final isCalorie = entry['type'] == 'calories';
                return Slidable(
                  key: ValueKey('${entry['type']}_${entry['id']}'),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    extentRatio: 0.25,
                    children: [
                      SlidableAction(
                        onPressed: (context) => _deleteLog(entry),
                        backgroundColor: Colors.white,
                        icon: Icons.delete,
                        foregroundColor: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ],
                  ),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: isCalorie
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    entry['name'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: navy,
                                    ),
                                  ),
                                  Text(
                                    entry['mealType'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: gray,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Cal: ${entry['calories']}  F: ${entry['fats']}  C: ${entry['carbs']}  P: ${entry['protein']}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: gray,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${entry['workoutType']}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: navy,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                entry['difficulty']?.toString().isNotEmpty ==
                                        true
                                    ? entry['difficulty']
                                    : (entry['name'] ?? ''),
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: gray,
                                ),
                              ),
                            ],
                          ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
