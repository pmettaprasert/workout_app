import 'package:flutter/foundation.dart';
import '../repository/workout_history_repository.dart';
import '../models/workout.dart';

class WorkoutHistoryViewModel extends ChangeNotifier {
  final WorkoutHistoryRepository _repository;

  WorkoutHistoryViewModel(this._repository){
    fetchWorkouts();
  }

  List<Workout> _workouts = [];
  List<Workout> get workouts => _workouts;

  Future<void> fetchWorkouts() async  {
    _workouts = await _repository.getAllWorkouts();
    _workouts.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }
}