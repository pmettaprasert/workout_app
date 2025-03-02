import '../../models/workout_plans_data_source.dart';
import '../../models/workout_plan.dart';
import '../../models/exercise.dart';
import '../../service/database/dao/workout_plan_dao.dart';
import '../../service/database/entity/workout_plan_entity.dart';
import '../../service/database/entity/exercise_entity.dart';
import 'dart:async';

class DatabaseWorkoutPlansDataSource implements WorkoutPlansDataSource {

  late final WorkoutPlanDao _dao;
  DatabaseWorkoutPlansDataSource(this._dao);

  Future<List<WorkoutPlan>> _getPlansFromDb() async {
    final planEntities = await _dao.findAllWorkoutPlans();
    List<WorkoutPlan> plans = [];
    for (final plan in planEntities) {
      final exerciseEntities = await _dao.findExercisesByWorkoutPlanId(plan.id!);
      final exercises = exerciseEntities
          .map((e) => Exercise(
        name: e.name,
        targetOutput: e.targetOutput,
        unit: e.unit,
      ))
          .toList();
      plans.add(WorkoutPlan(name: plan.name, exercises: exercises));
    }
    return plans;
  }

  @override
  Future<List<WorkoutPlan>> getAllPlans() async {
    return await _getPlansFromDb();
  }

  @override
  Future<WorkoutPlan> getPlanByIndex(int index) async {
    final plans = await _getPlansFromDb();
    return plans[index];
  }

  @override
  Future<void> addPlan(WorkoutPlan plan) async {

    final uniqueName = await _getUniqueName(plan.name);

    final workoutPlanEntity = WorkoutPlanEntity(id: null, name: uniqueName);

    final exerciseEntities = plan.exercises.map((exercise) {
      return ExerciseEntity(
        id: null,
        workoutPlanId: 0,
        name: exercise.name,
        targetOutput: exercise.targetOutput,
        unit: exercise.unit,
      );
    }).toList();


    await _dao.insertFullWorkoutPlan(workoutPlanEntity, exerciseEntities);
  }


  Future<String> _getUniqueName(String baseName) async {
    var attempt = baseName;
    var counter = 1;

    while (true) {

      final existingPlan = await _dao.findWorkoutPlanByName(attempt);
      if (existingPlan == null) {

        return attempt;
      } else {

        attempt = '$baseName ($counter)';
        counter++;
      }
    }
  }


}

