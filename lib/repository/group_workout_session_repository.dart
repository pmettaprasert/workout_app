import '../service/firebase/group_workout_session_data_source.dart';
import '../models/group_workout_session.dart';

class GroupWorkoutSessionRepository {
  final GroupWorkoutSessionDataSource dataSource;

  GroupWorkoutSessionRepository({GroupWorkoutSessionDataSource? dataSource})
      : dataSource = dataSource ?? GroupWorkoutSessionDataSource();

  /// Creates a new group workout session.
  Future<String> createGroupWorkoutSession(GroupWorkoutSession session) async {
    return await dataSource.createGroupWorkoutSession(session);
  }

  /// Retrieves a workout session by its ID.
  Future<GroupWorkoutSession?> getGroupWorkoutSessionById(String workoutId) async {
    return await dataSource.getGroupWorkoutSessionById(workoutId);
  }

  /// Retrieves all workout sessions where the specified user is a participant.
  Future<List<GroupWorkoutSession>> getGroupWorkoutsForUser(String userId) async {
    return await dataSource.getGroupWorkoutsForUser(userId);
  }

  /// Updates a participant's contributions within a group workout session.
  Future<void> updateParticipantContributions({
    required String workoutId,
    required String userId,
    required Map<String, int> newContributions,
  }) async {
    await dataSource.updateParticipantContributions(
      workoutId: workoutId,
      userId: userId,
      newContributions: newContributions,
    );
  }

  /// Deletes a group workout session.
  Future<void> deleteGroupWorkoutSession(String workoutId) async {
    await dataSource.deleteGroupWorkoutSession(workoutId);
  }

  /// Retrieves a workout session by its invite code.
  Future<GroupWorkoutSession?> getGroupWorkoutSessionByInviteCode(String inviteCode) async {
    return await dataSource.getGroupWorkoutSessionByInviteCode(inviteCode);
  }
}
