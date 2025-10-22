// Calorie entry class, this is how we will interpret calorie info
// essentially, we are defining properties of nutritional info for the logging aspect of a[[]]

class CalorieEntry {
  final DateTime date;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  CalorieEntry({
    required this.date,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  //method to convert CalorieEntry to JSON data for storage
  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'calories': calories,
    'protein': protein,
    'carbs': carbs,
    'fat': fat,
  };

  //method to create CalorieENtry from JSON data
  static CalorieEntry fromJson(Map<String, dynamic> json) => CalorieEntry(
    date: DateTime.parse(json['date'] as String),
    calories: json['calories'] as int,
    protein: json['protein'] as int,
    carbs: json['carbs'] as int,
    fat: json['fat'] as int,
  );
}
