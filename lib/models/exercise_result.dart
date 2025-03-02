import 'exercise.dart';

class ExerciseResult {
  final Exercise exercise;
  final int actualOutput;
  final bool isSuccessful;

  ExerciseResult({
    required this.exercise,
    required this.actualOutput,
  }) : isSuccessful = exercise.targetOutput <= actualOutput;
}