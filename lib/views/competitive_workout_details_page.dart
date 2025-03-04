import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/group_workout_session.dart';
import '../viewmodels/group_workout_display_record_viewmodel.dart';

class CompetitiveWorkoutDetailsView extends StatefulWidget {
  final GroupWorkoutSession session;

  const CompetitiveWorkoutDetailsView({Key? key, required this.session})
      : super(key: key);

  @override
  _CompetitiveWorkoutDetailsViewState createState() =>
      _CompetitiveWorkoutDetailsViewState();
}

class _CompetitiveWorkoutDetailsViewState
    extends State<CompetitiveWorkoutDetailsView> {
  @override
  void initState() {
    super.initState();
    // Schedule the refresh to run after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<WorkoutViewModel>();
      viewModel.loadWorkoutSessionByInviteCode(widget.session.inviteCode);
    });
  }

  Future<void> _refreshDetails(
      BuildContext context, WorkoutViewModel viewModel) async {
    await viewModel.loadWorkoutSessionByInviteCode(widget.session.inviteCode);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WorkoutViewModel>();
    // Use the updated session from the viewmodel if available.
    final currentSession = viewModel.sessionByInvite ?? widget.session;
    String formattedDate =
        "${currentSession.createdAt.day}/${currentSession.createdAt.month}/${currentSession.createdAt.year}";

    return Scaffold(
      appBar: AppBar(
        title: Text("Competitive Workout - $formattedDate"),
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
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // For each exercise in the workout plan.
            ...currentSession.workoutPlan.exercises.map((exercise) {
              // Build a ranking list for this exercise.
              List<Map<String, dynamic>> ranking = currentSession.participants
                  .map((participant) {
                int output = participant.contributions[exercise.name] ?? 0;
                return {
                  'userId': participant.userId,
                  'output': output,
                };
              }).toList();

              // Sort participants by their output in descending order.
              ranking.sort(
                      (a, b) => (b['output'] as int).compareTo(a['output'] as int));

              return ExpansionTile(
                title: Text(
                  exercise.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Target: ${exercise.targetOutput} ${exercise.unit}"),
                children: ranking.map((entry) {
                  int output = entry['output'];
                  // Compute rank based on sorted order.
                  int rank = ranking.indexWhere(
                          (e) => e['userId'] == entry['userId']) +
                      1;
                  bool isSuccess = output >= exercise.targetOutput;
                  return ListTile(
                    title: Text("User: ${truncateUserId(entry['userId'])}"),
                    subtitle:
                    Text("Rank: $rank of ${ranking.length}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("$output ${exercise.unit}"),
                        const SizedBox(width: 8),
                        Icon(
                          isSuccess
                              ? Icons.check_circle
                              : Icons.cancel,
                          color:
                          isSuccess ? Colors.green : Colors.red,
                        ),
                      ],
                    ),
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