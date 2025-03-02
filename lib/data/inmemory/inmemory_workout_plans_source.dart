import '../../models/workout_plans_data_source.dart';
import '../../models/workout_plan.dart';
import '../../models/exercise.dart';

class InMemoryWorkoutPlansDataSource implements WorkoutPlansDataSource {
  final List<WorkoutPlan> _plans = [
    WorkoutPlan(
      name: "Beginner Mixed Plan",
      exercises: [
        Exercise(name: "Push Ups", targetOutput: 20, unit: "reps"),
        Exercise(name: "Squats", targetOutput: 15, unit: "reps"),
        Exercise(name: "Plank", targetOutput: 60, unit: "seconds"),
        Exercise(name: "Jog", targetOutput: 300, unit: "meters"),
      ],
    ),

  ];

  @override
  Future<List<WorkoutPlan>> getAllPlans() async{
    return _plans;
  }

  @override
  Future<WorkoutPlan> getPlanByIndex(int index) async{
    return _plans[index];
  }

  @override
  Future<void> addPlan(WorkoutPlan plan) async{
    _plans.add(plan);
  }
}