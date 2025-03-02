import 'package:flutter_test/flutter_test.dart';
import 'package:hwk3/service/database/app_database.dart';
import 'package:hwk3/service/database/dao/workout_dao.dart';
import 'package:hwk3/service/database/entity/workout_entity.dart';
import 'package:hwk3/service/database/entity/exercise_result_entity.dart';

void main() {
  group('WorkoutDao Tests', () {
    late AppDatabase database;
    late WorkoutDao workoutDao;

    setUp(() async {
      database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
      workoutDao = database.workoutDao;
    });

    tearDown(() async {
      await database.close();
    });

    test('Insert full workout and retrieve all workouts', () async {
      final workoutEntity = WorkoutEntity(
        id: null,
        date: '2025-02-20T10:00:00.000',
      );


      final exerciseResults = [
        ExerciseResultEntity(
          id: null,
          workoutId: 0,
          exerciseName: 'Push Ups',
          exerciseTargetOutput: 20,
          exerciseUnit: 'reps',
          actualOutput: 22,
          isSuccessful: true,
        ),
        ExerciseResultEntity(
          id: null,
          workoutId: 0,
          exerciseName: 'Squats',
          exerciseTargetOutput: 15,
          exerciseUnit: 'reps',
          actualOutput: 15,
          isSuccessful: true,
        ),
      ];


      final workoutId = await workoutDao.insertFullWorkout(workoutEntity, exerciseResults);
      expect(workoutId, isNotNull);


      // Retrieve all workouts.
      final allWorkouts = await workoutDao.findAllWorkouts();
      expect(allWorkouts.length, 1);
      expect(allWorkouts.first.date, equals('2025-02-20T10:00:00.000'));

      // Retrieve the exercise results for this workout.
      final results = await workoutDao.findExerciseResultsByWorkoutId(workoutId);
      expect(results.length, equals(2));
      expect(results[0].exerciseName, equals('Push Ups'));
      expect(results[1].exerciseName, equals('Squats'));


      // Add another one
      final workoutEntity2 = WorkoutEntity(
        id: null,
        date: '2025-02-21T10:00:00.000',
      );

      //empty exercise results
      final exerciseResults2 = <ExerciseResultEntity>[];

      final workoutId2 = await workoutDao.insertFullWorkout(workoutEntity2, exerciseResults2);
      expect(workoutId2, isNotNull);


      final allWorkouts2 = await workoutDao.findAllWorkouts();
      expect(allWorkouts2.length, 2);
      expect(allWorkouts2[1].date, equals('2025-02-21T10:00:00.000'));


      final results2 = await workoutDao.findExerciseResultsByWorkoutId(workoutId2);
      expect(results2.length, equals(0));

    });

    test('Retrieve workout names (dates)', () async {
      // Insert two workouts.
      final workout1 = WorkoutEntity(id: null, date: '2025-02-20');
      final workout2 = WorkoutEntity(id: null, date: '2025-02-21');
      await workoutDao.insertWorkout(workout1);
      await workoutDao.insertWorkout(workout2);

      // Retrieve all workouts.
      final allWorkouts = await workoutDao.findAllWorkouts();
      expect(allWorkouts.length, equals(2));

      // For simplicity, we'll treat the 'date' as the "name" here.
      final workoutNames = allWorkouts.map((w) => w.date).toList();
      expect(workoutNames, containsAll(['2025-02-20', '2025-02-21']));
    });

    test('Add a workout and retrieve its exercise results', () async {
      // Create a workout with one exercise result.
      final workoutEntity = WorkoutEntity(id: null, date: '2025-02-22');
      final exerciseResults = [
        ExerciseResultEntity(
          id: null,
          workoutId: 0,
          exerciseName: 'Pull Ups',
          exerciseTargetOutput: 10,
          exerciseUnit: 'reps',
          actualOutput: 12,
          isSuccessful: true,
        ),
      ];

      final workoutId = await workoutDao.insertFullWorkout(workoutEntity, exerciseResults);

      // Retrieve the exercise results for this workout.
      final results = await workoutDao.findExerciseResultsByWorkoutId(workoutId);
      expect(results.length, equals(1));
      expect(results.first.exerciseName, equals('Pull Ups'));
    });
  });
}