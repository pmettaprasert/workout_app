import 'participant_contribution.dart';
import 'workout_plan.dart';



import 'package:hwk3/models/workout_plan.dart';
import 'package:hwk3/models/participant_contribution.dart';

class GroupWorkoutSession {
  final String workoutId;
  final String inviteCode;
  final String workoutType; // "solo", "collaborative", or "competitive"
  final String createdBy;
  final DateTime createdAt;
  final WorkoutPlan workoutPlan;
  final List<ParticipantContribution> participants;

  // New: store user IDs in an array for easy Firestore queries.
  final List<String> participantsIds;

  GroupWorkoutSession({
    required this.workoutId,
    required this.inviteCode,
    required this.workoutType,
    required this.createdBy,
    required this.createdAt,
    required this.workoutPlan,
    required this.participants,
    required this.participantsIds, // <--
  });

  factory GroupWorkoutSession.fromJson(Map<String, dynamic> json) {
    return GroupWorkoutSession(
      workoutId: json['workoutId'] as String,
      inviteCode: json['inviteCode'] as String,
      workoutType: json['workoutType'] as String,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      workoutPlan: WorkoutPlan.fromJson(json['workoutPlan']),
      participants: (json['participants'] as List<dynamic>)
          .map((p) => ParticipantContribution.fromJson(p))
          .toList(),
      participantsIds: (json['participantsIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workoutId': workoutId,
      'inviteCode': inviteCode,
      'workoutType': workoutType,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'workoutPlan': workoutPlan.toJson(),
      'participants': participants.map((p) => p.toJson()).toList(),
      'participantsIds': participantsIds, // <--
    };
  }

  GroupWorkoutSession copyWith({
    String? workoutId,
    String? inviteCode,
    String? workoutType,
    String? createdBy,
    DateTime? createdAt,
    WorkoutPlan? workoutPlan,
    List<ParticipantContribution>? participants,
    List<String>? participantsIds,
  }) {
    return GroupWorkoutSession(
      workoutId: workoutId ?? this.workoutId,
      inviteCode: inviteCode ?? this.inviteCode,
      workoutType: workoutType ?? this.workoutType,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      workoutPlan: workoutPlan ?? this.workoutPlan,
      participants: participants ?? this.participants,
      participantsIds: participantsIds ?? this.participantsIds,
    );
  }
}
