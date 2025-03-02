import 'package:floor/floor.dart';
import 'dart:async';
import 'entity/workout_plan_entity.dart';
import 'entity/exercise_entity.dart';
import 'entity/workout_entity.dart';
import 'entity/exercise_result_entity.dart';
import 'dao/workout_dao.dart';
import 'dao/workout_plan_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@Database(
  version: 1, // Bump the version if you already have v1 in production
  entities: [
    WorkoutPlanEntity,
    ExerciseEntity,
    WorkoutEntity,
    ExerciseResultEntity,
  ],
)
abstract class AppDatabase extends FloorDatabase {
  WorkoutPlanDao get workoutPlanDao;
  WorkoutDao get workoutDao;
}