import 'package:flutter/foundation.dart';
import '../models/workout_plan.dart';
import '../repository/recording_workout_plans_repository.dart';

class WorkoutPlanRecordingViewmodel extends ChangeNotifier {
  final RecordingWorkoutPlansRepository repository;
  WorkoutPlan? _workoutPlan;

  WorkoutPlanRecordingViewmodel(this.repository);

  WorkoutPlan? get workoutPlan => _workoutPlan;


  Future<void> loadWorkoutPlanFromUrl(String url) async {
    _workoutPlan = await repository.getWorkout(url);
    notifyListeners();
  }


  Future<void> addPlan(WorkoutPlan plan) async {
    await repository.addPlan(plan);
    _workoutPlan = plan;
    notifyListeners();
  }


  void clearWorkoutPlan() {
    _workoutPlan = null;
    notifyListeners();
  }
}