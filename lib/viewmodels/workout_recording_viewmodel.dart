import 'package:flutter/foundation.dart';
import '../models/workout_plan.dart';
import '../models/exercise.dart';
import '../repository/recording_workout_repository.dart';

class WorkoutRecordingViewModel extends ChangeNotifier {
  final RecordingWorkoutRepository _repository;
  WorkoutPlan? _selectedPlan;
  WorkoutPlan? get selectedPlan => _selectedPlan;

  final Map<Exercise, int> _actualOutputs = {};
  Map<Exercise, int> get actualOutputs => _actualOutputs;


  WorkoutRecordingViewModel(this._repository);

  Future<List<WorkoutPlan>> getAllPlans() async {
    final repoPlans = await _repository.getAllPlans();
    return repoPlans;
  }

  Future<void> selectPlanByIndex(int index) async {
    final plans = await getAllPlans();
    if (index < 0 || index >= plans.length) return;

    _selectedPlan = plans[index];
    _initializeOutputs(_selectedPlan!);
    notifyListeners();
  }


  void _initializeOutputs(WorkoutPlan plan) {
    _actualOutputs.clear();
    for (final exercise in plan.exercises) {
      _actualOutputs[exercise] = 0;
    }
  }


  void updateActualOutput(Exercise exercise, int newValue) {
    if (_selectedPlan == null) return;
    _actualOutputs[exercise] = newValue;
    notifyListeners();
  }

  void recordWorkout() {
    final plan = _selectedPlan;
    if (plan == null) return;

    _repository.recordWorkout(
      plan: plan,
      actualOutputs: _actualOutputs,
    );
  }

  Future<void> reloadPlans() async {
    await getAllPlans();
    notifyListeners();
  }


}