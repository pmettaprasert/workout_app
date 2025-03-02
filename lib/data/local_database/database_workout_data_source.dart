import '../../models/workouts_data_source.dart';
import '../../models/workout.dart';
import '../../models/exercise.dart';
import '../../models/exercise_result.dart';
import '../../service/database/dao/workout_dao.dart';
import '../../service/database/entity/workout_entity.dart';
import '../../service/database/entity/exercise_result_entity.dart';
import 'dart:async';

class DatabaseWorkoutDataSource implements WorkoutsDataSource {
  final WorkoutDao _dao;
  DatabaseWorkoutDataSource(this._dao);


  Future<List<Workout>> _getWorkoutsFromDb() async {
    final workoutEntities = await _dao.findAllWorkouts();
    List<Workout> workouts = [];
    for (final workoutEntity in workoutEntities) {

      final exerciseResultEntities =
      await _dao.findExerciseResultsByWorkoutId(workoutEntity.id!);


      final results = exerciseResultEntities.map((entity) {
        return ExerciseResult(
          exercise: Exercise(
            name: entity.exerciseName,
            targetOutput: entity.exerciseTargetOutput,
            unit: entity.exerciseUnit,
          ),
          actualOutput: entity.actualOutput,
        );
      }).toList();

      final workout = Workout(
        date: DateTime.parse(workoutEntity.date),
        results: results,
      );
      workouts.add(workout);
    }
    return workouts;
  }

  @override
  Future<List<Workout>> getWorkouts() async {
    return await _getWorkoutsFromDb();
  }

  @override
  Future<void> addWorkout(Workout workout) async {

    final workoutEntity = WorkoutEntity(
      id: null,
      date: workout.date.toIso8601String(),
    );


    final exerciseResultEntities = workout.results.map((result) {
      return ExerciseResultEntity(
        id: null,
        workoutId: 0,
        exerciseName: result.exercise.name,
        exerciseTargetOutput: result.exercise.targetOutput,
        exerciseUnit: result.exercise.unit,
        actualOutput: result.actualOutput,
        isSuccessful: result.isSuccessful,
      );
    }).toList();


    await _dao.insertFullWorkout(workoutEntity, exerciseResultEntities);
  }
}






