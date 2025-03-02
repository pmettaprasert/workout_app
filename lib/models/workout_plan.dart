import 'exercise.dart';

class WorkoutPlan {
  final String name;
  final List<Exercise> exercises;

  WorkoutPlan({
    required this.name,
    required this.exercises,
  });

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    return WorkoutPlan(
      name: json['name'] as String,
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => Exercise.fromJson(e))
          .toList(),
    );
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkoutPlan && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}