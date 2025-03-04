import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/group_workout_session.dart';
import '../viewmodels/group_workout_display_record_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';

class CollaborativeWorkoutDetailsView extends StatefulWidget {
  final GroupWorkoutSession session;

  const CollaborativeWorkoutDetailsView({Key? key, required this.session}) : super(key: key);

  @override
  _CollaborativeWorkoutDetailsViewState createState() => _CollaborativeWorkoutDetailsViewState();
}

class _CollaborativeWorkoutDetailsViewState extends State<CollaborativeWorkoutDetailsView> {
  @override
  void initState() {
    super.initState();
    // Automatically load the latest session data after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<WorkoutViewModel>();
      viewModel.loadWorkoutSessionByInviteCode(widget.session.inviteCode);
    });
  }

  Future<void> _refreshDetails(BuildContext context, WorkoutViewModel viewModel) async {
    await viewModel.loadWorkoutSessionByInviteCode(widget.session.inviteCode);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WorkoutViewModel>();
    final authViewModel = context.watch<AuthViewModel>();
    final currentUserId = authViewModel.user?.uid ?? "";

    // Use the updated session from the viewmodel if available; fall back to the constructor session otherwise.
    final currentSession = viewModel.sessionByInvite ?? widget.session;
    final formattedDate =
        "${currentSession.createdAt.day}/${currentSession.createdAt.month}/${currentSession.createdAt.year}";

    return Scaffold(
      appBar: AppBar(
        title: Text("Collaborative Workout - $formattedDate"),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshDetails(context, viewModel),
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            // Display the invite code.
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Invite Code: ${currentSession.inviteCode}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...currentSession.workoutPlan.exercises.map((exercise) {
              final combinedOutput = currentSession.participants.fold<int>(
                0,
                    (prev, participant) => prev + (participant.contributions[exercise.name] ?? 0),
              );
              final isSuccess = combinedOutput >= exercise.targetOutput;

              return ExpansionTile(
                title: Text(
                  exercise.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Target: ${exercise.targetOutput} ${exercise.unit} | Combined: $combinedOutput",
                ),
                trailing: Icon(
                  isSuccess ? Icons.check_circle : Icons.cancel,
                  color: isSuccess ? Colors.green : Colors.red,
                ),
                children: currentSession.participants.map((participant) {
                  final participantOutput = participant.contributions[exercise.name] ?? 0;
                  return ListTile(
                    title: Text(
                      participant.userId == currentUserId
                          ? "You"
                          : truncateUserId(participant.userId),
                    ),
                    trailing: Text("$participantOutput ${exercise.unit}"),
                  );
                }).toList(),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

String truncateUserId(String userId) {
  return userId.length > 6 ? '${userId.substring(0, 6)}...' : userId;
}
