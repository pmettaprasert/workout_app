import 'package:intl/intl.dart';
import 'workout_plan.dart';
import 'participant_result.dart';

enum WorkoutType { collaborative, competitive }

class GroupWorkout {
  final String id; // Firestore document ID
  final WorkoutType type;
  final String inviteCode;
  final WorkoutPlan workoutPlan; // Snapshot of the plan
  final List<ParticipantResult> results; // One entry per participant
  final DateTime createdAt;
  final String _formattedDate;

  GroupWorkout({
    required this.id,
    required this.type,
    required this.inviteCode,
    required this.workoutPlan,
    required this.results,
    required this.createdAt,
  }) : _formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAt);

  String get formattedDate => _formattedDate;

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last, // "collaborative" or "competitive"
      'inviteCode': inviteCode,
      'workoutPlan': workoutPlan.toJson(),
      'results': results.map((r) => r.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory GroupWorkout.fromJson(Map<String, dynamic> json, String docId) {
    return GroupWorkout(
      id: docId,
      type: _parseType(json['type'] as String),
      inviteCode: json['inviteCode'] as String,
      workoutPlan: WorkoutPlan.fromJson(json['workoutPlan'] as Map<String, dynamic>),
      results: (json['results'] as List<dynamic>)
          .map((r) => ParticipantResult.fromJson(r as Map<String, dynamic>))
          .toList(),
      // If the doc has a serverTimestamp or missing, handle carefully:
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  static WorkoutType _parseType(String typeString) {
    // If stored as "collaborative" or "competitive", parse accordingly:
    return typeString == 'collaborative'
        ? WorkoutType.collaborative
        : WorkoutType.competitive;
  }
}
