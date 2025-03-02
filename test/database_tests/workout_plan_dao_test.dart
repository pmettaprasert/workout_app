import 'package:flutter_test/flutter_test.dart';
import 'package:floor/floor.dart';
import 'package:hwk3/service/database/app_database.dart';
import 'package:hwk3/service/database/dao/workout_plan_dao.dart';
import 'package:hwk3/service/database/entity/workout_plan_entity.dart';
import 'package:hwk3/service/database/entity/exercise_entity.dart';

void main() {
  group('WorkoutPlanDao Tests', () {
    late AppDatabase database;
    late WorkoutPlanDao dao;

    setUp(() async {
      database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
      dao = database.workoutPlanDao;
    });

    tearDown(() async {
      //close the database
      await database.close();
    });

    test('insertFullWorkoutPlan and retrieve data', () async {

      // Create new workout
      final workoutPlanEntity = WorkoutPlanEntity(id: null, name: 'Test Workout Plan');

      final exercises = [
        ExerciseEntity(
          id: null,
          workoutPlanId: 0,
          name: 'Push Ups',
          targetOutput: 20,
          unit: 'reps',
        ),
        ExerciseEntity(
          id: null,
          workoutPlanId: 0,
          name: 'Squats',
          targetOutput: 15,
          unit: 'reps',
        ),
      ];

      // one single fell swoop
      final insertedPlanId = await dao.insertFullWorkoutPlan(workoutPlanEntity, exercises);

      final allPlans = await dao.findAllWorkoutPlans();
      expect(allPlans.length, 1);
      expect(allPlans[0].id, insertedPlanId);
      expect(allPlans[0].name, 'Test Workout Plan');


      final planExercises = await dao.findExercisesByWorkoutPlanId(insertedPlanId);
      expect(planExercises.length, 2);

      // Check that the exercises match what we inserted
      expect(planExercises[0].name, 'Push Ups');
      expect(planExercises[0].targetOutput, 20);
      expect(planExercises[0].unit, 'reps');

      expect(planExercises[1].name, 'Squats');
      expect(planExercises[1].targetOutput, 15);
      expect(planExercises[1].unit, 'reps');
    });

    test('insert multiple plans and find by name', () async {
      // Insert two plans
      final planA = WorkoutPlanEntity(id: null, name: 'Plan A');
      final planB = WorkoutPlanEntity(id: null, name: 'Plan B');
      await dao.insertWorkoutPlan(planA);
      await dao.insertWorkoutPlan(planB);

      // Retrieve all
      final allPlans = await dao.findAllWorkoutPlans();
      expect(allPlans.length, 2);

      final foundPlanA = await dao.findWorkoutPlanByName('Plan A');
      expect(foundPlanA, isNotNull);
      expect(foundPlanA!.name, 'Plan A');

      final foundPlanB = await dao.findWorkoutPlanByName('Plan B');
      expect(foundPlanB, isNotNull);
      expect(foundPlanB!.name, 'Plan B');

    });
  });
}