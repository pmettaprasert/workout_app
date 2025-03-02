import '../models/workout.dart';
import '../models/workouts_data_source.dart';

class WorkoutHistoryRepository {
  final WorkoutsDataSource dataSource;

  WorkoutHistoryRepository(this.dataSource);

  Future<List<Workout>> getAllWorkouts() {
    return dataSource.getWorkouts();
  }
}
