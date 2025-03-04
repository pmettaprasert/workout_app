import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/group_workout_session.dart';
import '../../models/participant_contribution.dart';

class GroupWorkoutSessionDataSource {
  static const String _collectionName = 'group_workout_sessions';

  final FirebaseFirestore _firestore;

  GroupWorkoutSessionDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// 1. CREATE a new group workout session in Firestore with auto-generated ID.
  /// Returns the auto-generated document ID.
  Future<String> createGroupWorkoutSession(GroupWorkoutSession session) async {
    try {
      // Create a new document reference without providing an ID; Firestore will generate one.
      final docRef = _firestore.collection(_collectionName).doc();
      // Update the session with the generated ID using the copyWith method.
      final sessionWithId = session.copyWith(workoutId: docRef.id);
      // Save the session to Firestore.
      await docRef.set(sessionWithId.toJson());
      // Return the generated ID.
      return docRef.id;
    } catch (e) {
      rethrow;
    }
  }

  /// 2. GET a single session by ID.
  Future<GroupWorkoutSession?> getGroupWorkoutSessionById(String workoutId) async {
    try {
      final docRef = _firestore.collection(_collectionName).doc(workoutId);
      final snapshot = await docRef.get();

      if (snapshot.exists && snapshot.data() != null) {
        return GroupWorkoutSession.fromJson(snapshot.data() as Map<String, dynamic>);
      } else {
        return null; // or throw an exception
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 3. GET all sessions where a user is a participant.
  ///    This example assumes you store participant userIds in a separate array
  ///    for easy querying. If not, you'll need a different approach.
  Future<List<GroupWorkoutSession>> getGroupWorkoutsForUser(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('participantsIds', arrayContains: userId)
          .get();

      return querySnapshot.docs.map((doc) {
        return GroupWorkoutSession.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// 4. UPDATE a participant's contributions.
  ///    This merges new/updated contributions into the existing document.
  Future<void> updateParticipantContributions({
    required String workoutId,
    required String userId,
    required Map<String, int> newContributions,
  }) async {
    final docRef = _firestore.collection(_collectionName).doc(workoutId);
    final snapshot = await docRef.get();
    if (!snapshot.exists) {
      throw Exception('Workout session not found');
    }

    final data = snapshot.data() as Map<String, dynamic>;
    final session = GroupWorkoutSession.fromJson(data);

    // Update or add the participant's contributions.
    final updatedParticipants = List<ParticipantContribution>.from(session.participants);
    final index = updatedParticipants.indexWhere((p) => p.userId == userId);

    if (index >= 0) {
      // Merge new contributions with existing ones.
      final oldMap = updatedParticipants[index].contributions;
      final mergedMap = {...oldMap, ...newContributions};
      updatedParticipants[index] = ParticipantContribution(
        userId: userId,
        contributions: mergedMap,
      );
    } else {
      // Add a new participant.
      updatedParticipants.add(
        ParticipantContribution(userId: userId, contributions: newContributions),
      );
    }

    // Update participantsIds array.
    List<String> updatedIds = List<String>.from(session.participantsIds);
    if (!updatedIds.contains(userId)) {
      updatedIds.add(userId);
    }

    final updatedSession = session.copyWith(
      participants: updatedParticipants,
      participantsIds: updatedIds,
    );

    await docRef.set(updatedSession.toJson(), SetOptions(merge: true));
  }

  /// 5. DELETE a workout session.
  Future<void> deleteGroupWorkoutSession(String workoutId) async {
    try {
      await _firestore.collection(_collectionName).doc(workoutId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// 6. GET a session by its invite code.
  Future<GroupWorkoutSession?> getGroupWorkoutSessionByInviteCode(String inviteCode) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('inviteCode', isEqualTo: inviteCode)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return GroupWorkoutSession.fromJson(
            querySnapshot.docs.first.data() as Map<String, dynamic>);
      } else {
        return null; // No session found with that invite code.
      }
    } catch (e) {
      rethrow;
    }
  }

}
