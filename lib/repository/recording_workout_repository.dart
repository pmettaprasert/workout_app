import '../models/workout_plans_data_source.dart';
import '../models/workouts_data_source.dart';
import '../models/workout.dart';
import '../models/workout_plan.dart';
import '../models/exercise.dart';
import '../models/exercise_result.dart';


class RecordingWorkoutRepository {
  final WorkoutPlansDataSource plansDataSource;
  final WorkoutsDataSource workoutsDataSource;

  RecordingWorkoutRepository(this.plansDataSource, this.workoutsDataSource);


  Future<List<WorkoutPlan>> getAllPlans() {
    return plansDataSource.getAllPlans();
  }

  Future<WorkoutPlan> getPlanByIndex(int index) {
    return plansDataSource.getPlanByIndex(index);
  }


  Future<Workout> recordWorkout({
    required WorkoutPlan plan,
    required Map<Exercise, int> actualOutputs,
  }) async {
    final newWorkout = Workout(
      date: DateTime.now(),
      results: plan.exercises.map((exercise) {
        final actual = actualOutputs[exercise] ?? 0;
        return ExerciseResult(exercise: exercise, actualOutput: actual);
      }).toList(),
    );


    workoutsDataSource.addWorkout(newWorkout);

    return newWorkout;
  }
}