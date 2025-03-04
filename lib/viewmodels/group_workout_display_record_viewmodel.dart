import 'dart:math';
import 'package:flutter/material.dart';
import '../models/group_workout_session.dart';
import '../models/participant_contribution.dart';
import '../models/workout_plan.dart';
import '../models/exercise.dart';
import '../repository/group_workout_session_repository.dart';
import '../repository/recording_workout_repository.dart';
import '../repository/auth_repository.dart';

class WorkoutViewModel extends ChangeNotifier {
  // Repositories
  final GroupWorkoutSessionRepository groupRepository;
  final RecordingWorkoutRepository recordingRepository;
  final AuthRepository authRepository;

  // Group Workout Session related state.
  List<GroupWorkoutSession> sessions = [];
  bool isLoadingSessions = false;

  // Workout Recording related state.
  WorkoutPlan? _selectedPlan;
  WorkoutPlan? get selectedPlan => _selectedPlan;

  // Map to hold actual outputs for each exercise.
  final Map<Exercise, int> _actualOutputs = {};
  Map<Exercise, int> get actualOutputs => _actualOutputs;

  // Holds a session loaded by its invite code.
  GroupWorkoutSession? _sessionByInvite;
  GroupWorkoutSession? get sessionByInvite => _sessionByInvite;

  WorkoutViewModel({
    required this.groupRepository,
    required this.recordingRepository,
    required this.authRepository,
  });

  // --------------------------
  // Group Workout Session Methods
  // --------------------------

  /// Fetches all group workout sessions for the given user.
  Future<void> fetchSessionsForUser(String userId) async {
    isLoadingSessions = true;
    notifyListeners();

    try {
      sessions = await groupRepository.getGroupWorkoutsForUser(userId);
    } catch (error) {
      print("Error fetching sessions: $error");
    } finally {
      isLoadingSessions = false;
      notifyListeners();
    }
  }

  /// Refreshes the session list (useful for pull-to-refresh in the UI).
  Future<void> refreshSessions(String userId) async {
    await fetchSessionsForUser(userId);
  }

  /// Updates a participant's contributions in a specific group session.
  Future<void> updateParticipantContributions({
    required String workoutId,
    required String userId,
    required Map<String, int> newContributions,
  }) async {
    try {
      await groupRepository.updateParticipantContributions(
        workoutId: workoutId,
        userId: userId,
        newContributions: newContributions,
      );
    } catch (error) {
      print("Error updating participant contributions: $error");
    }
  }

  /// Loads a group workout session by its invite code.
  Future<void> loadWorkoutSessionByInviteCode(String inviteCode) async {
    try {
      _sessionByInvite = await groupRepository.getGroupWorkoutSessionByInviteCode(inviteCode);
      notifyListeners();
    } catch (error) {
      print("Error loading session by invite code: $error");
    }
  }

  // --------------------------
  // Workout Recording Methods
  // --------------------------

  /// Returns all available workout plans.
  Future<List<WorkoutPlan>> getAllPlans() async {
    return await recordingRepository.getAllPlans();
  }

  /// Selects a workout plan based on its index and initializes exercise outputs.
  Future<void> selectPlanByIndex(int index) async {
    final plans = await getAllPlans();
    if (index < 0 || index >= plans.length) return;

    _selectedPlan = plans[index];
    _initializeOutputs(_selectedPlan!);
    notifyListeners();
  }

  /// Initializes actual outputs to zero for each exercise in the selected plan.
  void _initializeOutputs(WorkoutPlan plan) {
    _actualOutputs.clear();
    for (final exercise in plan.exercises) {
      _actualOutputs[exercise] = 0;
    }
  }

  /// Updates the actual output for a given exercise.
  void updateActualOutput(Exercise exercise, int newValue) {
    if (_selectedPlan == null) return;
    _actualOutputs[exercise] = newValue;
    notifyListeners();
  }

  /// Creates a new group workout session and records the workout.
  ///
  /// Generates a random invite code based on the first 3 characters of the userId
  /// and two random alphanumeric characters. The [workoutType] is provided by the view.
  /// It creates a new session in Firebase with the provided workout type and initial contributions.
  Future<String?> recordWorkout(String workoutType) async {
    final plan = _selectedPlan;
    if (plan == null) return null;

    try {
      // Get the current user.
      final user = authRepository.currentUser;
      if (user == null) {
        print("No authenticated user found.");
        return null;
      }

      // Generate a random invite code.
      final inviteCode = _generateInviteCode(user.uid);

      // Build the contributions map from the actual outputs.
      final Map<String, int> contributions = {};
      for (final entry in _actualOutputs.entries) {
        contributions[entry.key.name] = entry.value;
      }

      // Create initial ParticipantContribution for the creator.
      final participant = ParticipantContribution(
        userId: user.uid,
        contributions: contributions,
      );

      // Create a new GroupWorkoutSession object.
      final newSession = GroupWorkoutSession(
        workoutId: '', // will be set by the repository
        inviteCode: inviteCode,
        workoutType: workoutType,
        createdBy: user.uid,
        createdAt: DateTime.now(),
        workoutPlan: plan,
        participants: [participant],
        participantsIds: [user.uid], // <--- add the creator's ID here
      );

      // Call the repository to create the session in Firestore.
      final sessionId = await groupRepository.createGroupWorkoutSession(newSession);
      return sessionId;
    } catch (error) {
      print("Error recording workout: $error");
      return null;
    }
  }

  /// Helper method to generate a random invite code.
  ///
  /// Takes the first 3 characters of [userId] and appends 2 random alphanumeric characters.
  String _generateInviteCode(String userId) {
    final prefix = userId.length >= 3 ? userId.substring(0, 3) : userId;
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    String suffix = '';
    for (int i = 0; i < 2; i++) {
      suffix += chars[rand.nextInt(chars.length)];
    }
    return prefix.toUpperCase() + suffix;
  }

  /// Reloads plans (for instance, after a pull-to-refresh on the plan list).
  Future<void> reloadPlans() async {
    await getAllPlans();
    notifyListeners();
  }

  void clearSessionByInvite() {
    _sessionByInvite = null;
    notifyListeners();
  }
}
