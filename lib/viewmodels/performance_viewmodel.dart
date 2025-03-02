// lib/viewmodels/performance_viewmodel.dart

import 'package:flutter/foundation.dart';
import '../repository/workout_history_repository.dart';
import '../models/workout.dart';

class PerformanceViewModel extends ChangeNotifier {
  final WorkoutHistoryRepository _repository;

  List<Workout> _workouts = [];

  PerformanceViewModel(this._repository) {
    refreshPerformanceData();
  }

  Future<void> refreshPerformanceData() async {
    _workouts = await _repository.getAllWorkouts();
    notifyListeners();
  }


  List<Workout> get _workoutsLast7Days {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    return _workouts.where((w) => w.date.isAfter(sevenDaysAgo)).toList();
  }

  int calculatePerformanceScore() {
    final workouts7Days = _workoutsLast7Days;
    return workouts7Days.length;
  }

  List<int> calculateCompletedExercises() {
    final workouts7Days = _workoutsLast7Days;
    int totalExercises = 0;
    int successfulExercises = 0;

    for (final workout in workouts7Days) {
      totalExercises += workout.results.length;
      successfulExercises += workout.results.where((r) => r.isSuccessful).length;
    }
    return [successfulExercises, totalExercises];
  }
}
