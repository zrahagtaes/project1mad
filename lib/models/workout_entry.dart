//Workout entry model class, this is where we will define the properties of
// a workout entry for logging purposes

class WorkoutEntry {
  final DateTime date;
  final String name;
  final int reps;
  final double weight;
  final int durationMin;

  WorkoutEntry({
    required this.date,
    required this.name,
    required this.reps,
    required this.weight,
    required this.durationMin,
  });

  //convert WorkoutEntry to JSON for storage
  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'name': name,
    'reps': reps,
    'weight': weight,
    'durationMin': durationMin,
  };

  //create WorkoutEntry from JSON data
  static WorkoutEntry fromJson(Map<String, dynamic> json) => WorkoutEntry(
    date: DateTime.parse(json['date'] as String),
    name: json['name'] as String,
    reps: json['reps'] as int,
    weight: (json['weight'] as num).toDouble(),
    durationMin: json['durationMin'] as int,
  );
}
