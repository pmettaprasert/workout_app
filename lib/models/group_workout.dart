import 'package:intl/intl.dart';
import 'workout_plan.dart';
import 'exercise.dart';

enum WorkoutType { collaborative, competitive }

class GroupExerciseResult {
  final String exerciseName; // Could be the exercise name or an identifier
  final Map<String, int> participantOutputs; // Key: participant UID, Value: actual output

  GroupExerciseResult({
    required this.exerciseName,
    required this.participantOutputs,
  });

  /// For collaborative workouts, returns the total combined output.
  int get totalOutput =>
      participantOutputs.values.fold(0, (sum, output) => sum + output);

  /// Determines if the combined output meets or exceeds the target.
  /// To do this, you might need access to the target value. One way is to look it up from the plan.
  // bool get isSuccessful => totalOutput >= targetOutput;

  Map<String, dynamic> toJson() {
    return {
      'exerciseName': exerciseName,
      'participantOutputs': participantOutputs,
    };
  }

  factory GroupExerciseResult.fromJson(Map<String, dynamic> json) {
    return GroupExerciseResult(
      exerciseName: json['exerciseName'] as String,
      participantOutputs:
      Map<String, int>.from(json['participantOutputs'] as Map),
    );
  }
}

class GroupWorkout {
  final String id; // Firestore document ID
  final DateTime createdAt;
  final String _formattedDate;
  final String inviteCode;
  final WorkoutType type;
  final WorkoutPlan workoutPlan; // Reference to the shared workout plan
  final List<GroupExerciseResult> results;

  GroupWorkout({
    required this.id,
    required this.createdAt,
    required this.inviteCode,
    required this.type,
    required this.workoutPlan,
    required this.results,
  }) : _formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAt);

  String get formattedDate => _formattedDate;

  Map<String, dynamic> toJson() {
    return {
      'inviteCode': inviteCode,
      'type': type.toString(),
      'createdAt': createdAt.toIso8601String(),
      // Embedding a snapshot of the workout plan.
      'workoutPlan': workoutPlan.toJson(),
      'results': results.map((r) => r.toJson()).toList(),
    };
  }

  factory GroupWorkout.fromJson(Map<String, dynamic> json, String docId) {
    return GroupWorkout(
      id: docId,
      createdAt: DateTime.parse(json['createdAt'] as String),
      inviteCode: json['inviteCode'] as String,
      type: WorkoutType.values.firstWhere(
              (e) => e.toString() == json['type'],
          orElse: () => WorkoutType.collaborative),
      workoutPlan: WorkoutPlan.fromJson(
          json['workoutPlan'] as Map<String, dynamic>),
      results: (json['results'] as List)
          .map((e) => GroupExerciseResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
