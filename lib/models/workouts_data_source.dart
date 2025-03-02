import '../models/workout.dart';


abstract class WorkoutsDataSource {

  Future<List<Workout>> getWorkouts();

  Future<void> addWorkout(Workout workout);
}