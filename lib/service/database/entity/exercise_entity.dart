import 'package:floor/floor.dart';
import 'workout_plan_entity.dart';

@Entity(
  tableName: 'exercise',
  foreignKeys: [
    ForeignKey(
      childColumns: ['workoutPlanId'],
      parentColumns: ['id'],
      entity: WorkoutPlanEntity,
    )
  ],
)
class ExerciseEntity {
  @PrimaryKey(autoGenerate: true)
  final int ? id;
  final int workoutPlanId;
  final String name;
  final int targetOutput;
  final String unit;

  ExerciseEntity({this.id, required this.workoutPlanId, required this.name,
    required this.targetOutput, required this.unit});
}