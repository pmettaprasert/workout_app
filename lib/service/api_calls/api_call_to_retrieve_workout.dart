import '../../models/workout_plan.dart';


abstract class ApiCallToRetrieveWorkout {
  Future<WorkoutPlan> getWorkout(String url);

}