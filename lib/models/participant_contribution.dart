class ParticipantContribution {
  final String userId;
  // Key: exerciseId (or exerciseName), Value: actualOutput
  final Map<String, int> contributions;

  ParticipantContribution({
    required this.userId,
    required this.contributions,
  });

  factory ParticipantContribution.fromJson(Map<String, dynamic> json) {
    return ParticipantContribution(
      userId: json['userId'] as String,
      contributions: Map<String, int>.from(json['contributions'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'contributions': contributions,
    };
  }
}
