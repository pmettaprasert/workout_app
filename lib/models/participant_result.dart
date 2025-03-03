enum WorkoutType { collaborative, competitive }

/// Each participant's recorded outputs for the workout.
class ParticipantResult {
  final String uid; // The user's unique ID (from Firebase Auth)
  final List<ExerciseOutput> outputs;

  ParticipantResult({
    required this.uid,
    required this.outputs,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'outputs': outputs.map((o) => o.toJson()).toList(),
    };
  }

  factory ParticipantResult.fromJson(Map<String, dynamic> json) {
    return ParticipantResult(
      uid: json['uid'] as String,
      outputs: (json['outputs'] as List<dynamic>)
          .map((o) => ExerciseOutput.fromJson(o as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// A simple struct for an exercise name + the user's actual output.
class ExerciseOutput {
  final String exerciseName;
  final int output;

  ExerciseOutput({
    required this.exerciseName,
    required this.output,
  });

  Map<String, dynamic> toJson() {
    return {
      'exerciseName': exerciseName,
      'output': output,
    };
  }

  factory ExerciseOutput.fromJson(Map<String, dynamic> json) {
    return ExerciseOutput(
      exerciseName: json['exerciseName'] as String,
      output: json['output'] as int,
    );
  }
}
