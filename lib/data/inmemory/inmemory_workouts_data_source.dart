import '../../models/workouts_data_source.dart';
import '../../models/workout.dart';

class InMemoryWorkoutsDataSource implements WorkoutsDataSource {
  final List<Workout> _workouts = [];

  @override
  Future<List<Workout>> getWorkouts() async => _workouts;

  @override
  Future<void> addWorkout (Workout workout) async{
    _workouts.add(workout);
  }
}