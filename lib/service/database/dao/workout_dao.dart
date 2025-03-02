import 'package:floor/floor.dart';
import '../entity/workout_entity.dart';
import '../entity/exercise_result_entity.dart';

@dao
abstract class WorkoutDao {


  // Insert a single workout
  @insert
  Future<int> insertWorkout(WorkoutEntity workout);

  // Insert multiple exercise results at once.
  @insert
  Future<List<int>> insertExerciseResults(List<ExerciseResultEntity> results);

  // Get all stored workouts.
  @Query('SELECT * FROM workout')
  Future<List<WorkoutEntity>> findAllWorkouts();

  // Get all exercise results for a given workout by ID.
  @Query('SELECT * FROM exercise_result WHERE workoutId = :workoutId')
  Future<List<ExerciseResultEntity>> findExerciseResultsByWorkoutId(int workoutId);

  //insert a workout and its exercise results in one go.
  @transaction
  Future<int> insertFullWorkout(
      WorkoutEntity workout,
      List<ExerciseResultEntity> exerciseResults,
      ) async {
    //Insert the workout
    final workoutId = await insertWorkout(workout);

    //Update the workoutId in each ExerciseResultEntity before inserting
    final updatedResults = exerciseResults.map((result) {
      return ExerciseResultEntity(
        id: result.id,
        workoutId: workoutId,
        exerciseName: result.exerciseName,
        exerciseTargetOutput: result.exerciseTargetOutput,
        exerciseUnit: result.exerciseUnit,
        actualOutput: result.actualOutput,
        isSuccessful: result.isSuccessful,
      );
    }).toList();


    await insertExerciseResults(updatedResults);

    return workoutId;
  }


}


