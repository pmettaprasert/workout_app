import 'package:floor/floor.dart';
import '../entity/workout_plan_entity.dart';
import '../entity/exercise_entity.dart';

@dao
abstract class WorkoutPlanDao {

  @insert
  Future<int> insertWorkoutPlan(WorkoutPlanEntity workoutPlan);


  @insert
  Future<List<int>> insertExercises(List<ExerciseEntity> exercises);


  @Query('SELECT * FROM workout_plan')
  Future<List<WorkoutPlanEntity>> findAllWorkoutPlans();


  @Query('SELECT * FROM workout_plan WHERE name = :name')
  Future<WorkoutPlanEntity?> findWorkoutPlanByName(String name);


  @Query('SELECT * FROM exercise WHERE workoutPlanId = :workoutPlanId')
  Future<List<ExerciseEntity>> findExercisesByWorkoutPlanId(int workoutPlanId);


  @transaction
  Future<int> insertFullWorkoutPlan(
      WorkoutPlanEntity workoutPlan,
      List<ExerciseEntity> exercises,
      ) async {
    final int workoutPlanId = await insertWorkoutPlan(workoutPlan);
    final updatedExercises = exercises.map((exercise) {
      return ExerciseEntity(
        id: null,
        workoutPlanId: workoutPlanId,
        name: exercise.name,
        targetOutput: exercise.targetOutput,
        unit: exercise.unit,
      );
    }).toList();

    await insertExercises(updatedExercises);
    return workoutPlanId;
  }

  @Query('DELETE FROM workout_plan')
  Future<void> deleteAllWorkoutPlans();

  @Query('DELETE FROM exercise')
  Future<void> deleteAllExercises();
}