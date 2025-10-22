//we will be using SharedPreferences to store data locally on the device

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calorie_entry.dart';
import '../models/workout_entry.dart';

class StorageService {
  static const _calKey = 'calorie_entries';
  static const _woKey = 'workout_entries';

  Future<List<CalorieEntry>> loadCalories() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_calKey);
    if (raw == null) return [];
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    return list.map(CalorieEntry.fromJson).toList();
  }

  Future<void> saveCalories(List<CalorieEntry> items) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_calKey, raw);
  }

  Future<List<WorkoutEntry>> loadWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_woKey);
    if (raw == null) return [];
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    return list.map(WorkoutEntry.fromJson).toList();
  }

  Future<void> saveWorkouts(List<WorkoutEntry> items) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_woKey, raw);
  }
}
