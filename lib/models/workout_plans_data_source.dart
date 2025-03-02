import '../models/workout_plan.dart';

abstract class WorkoutPlansDataSource {
  // Returns all available workout plans.
  Future<List<WorkoutPlan>> getAllPlans();
  Future<WorkoutPlan> getPlanByIndex(int index);
  Future<void> addPlan(WorkoutPlan plan);
}