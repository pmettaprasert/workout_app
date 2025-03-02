import 'package:floor/floor.dart';
import 'workout_entity.dart';


@Entity(
  tableName: 'exercise_result',
  foreignKeys: [
    ForeignKey(
      childColumns: ['workoutId'],
      parentColumns: ['id'],
      entity: WorkoutEntity,
      onDelete: ForeignKeyAction.cascade, // optional
    )
  ],
)
class ExerciseResultEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final int workoutId;

  final String exerciseName;
  final int exerciseTargetOutput;
  final String exerciseUnit;

  final int actualOutput;
  final bool isSuccessful;

  ExerciseResultEntity({
    this.id,
    required this.workoutId,
    required this.exerciseName,
    required this.exerciseTargetOutput,
    required this.exerciseUnit,
    required this.actualOutput,
    required this.isSuccessful,
  });
}