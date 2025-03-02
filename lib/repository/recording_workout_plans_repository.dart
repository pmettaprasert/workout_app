import '../models/workout_plan.dart';

class RecordingWorkoutPlansRepository {
  final WorkoutPlansDataSource;
  final ApiCallToRetrieveWorkoutFromWebsite;

  RecordingWorkoutPlansRepository(this.WorkoutPlansDataSource, this.ApiCallToRetrieveWorkoutFromWebsite);

  Future<WorkoutPlan> getWorkout(String url) async {
    return await ApiCallToRetrieveWorkoutFromWebsite.getWorkout(url);
  }

  Future<void> addPlan(WorkoutPlan plan) async {
    await WorkoutPlansDataSource.addPlan(plan);
  }
}

