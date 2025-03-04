import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/group_workout_display_record_viewmodel.dart';
import 'collaborative_workout_details_page.dart';
import 'competitive_workout_details_page.dart';
import 'widget/fab_workout_menu.dart';
import 'group_workout_recording_option_page.dart';


class GroupWorkoutsView extends StatefulWidget {
  const GroupWorkoutsView({Key? key}) : super(key: key);

  @override
  _GroupWorkoutsViewState createState() => _GroupWorkoutsViewState();
}

class _GroupWorkoutsViewState extends State<GroupWorkoutsView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<WorkoutViewModel>();
      final user = viewModel.authRepository.currentUser;
      if (user != null) {
        viewModel.fetchSessionsForUser(user.uid);
      }
    });
  }

  Future<void> _refreshSessions(BuildContext context, WorkoutViewModel viewModel) async {
    final user = viewModel.authRepository.currentUser;
    if (user != null) {
      await viewModel.fetchSessionsForUser(user.uid);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<WorkoutViewModel>(context);
    print('Sessions length: ${viewModel.sessions.length}');

    // Filter and sort sessions into collaborative and competitive.
    final collaborativeSessions = viewModel.sessions
        .where((session) => session.workoutType.toLowerCase().contains('collaborative'))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final competitiveSessions = viewModel.sessions
        .where((session) => session.workoutType.toLowerCase().contains('competitive'))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Group Workouts',
          style: TextStyle(
            fontSize: 25,           // Increase size as desired
            fontWeight: FontWeight.bold,  // Make it bold
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshSessions(context, viewModel),
        child: ListView(
          children: [
            // Collaborative Workouts Section.
            if (collaborativeSessions.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Collaborative Workouts',
                  style: TextStyle(
                    fontSize: 20,           // Increase size as desired
                    fontWeight: FontWeight.bold,  // Make it bold
                  ),
                ),
              ),
              ...collaborativeSessions.map((session) {
                return ListTile(
                  title: Text(
                    'Collaborative Workout - ${_formatDate(session.createdAt)}',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CollaborativeWorkoutDetailsView(session: session),
                      ),
                    );
                  },
                );
              }).toList(),
            ],
            // Divider between sections.
            if (collaborativeSessions.isNotEmpty && competitiveSessions.isNotEmpty)
              const Divider(thickness: 2),
            // Competitive Workouts Section.
            if (competitiveSessions.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Competitive Workouts',
                  style: TextStyle(
                    fontSize: 20,           // Increase size as desired
                    fontWeight: FontWeight.bold,  // Make it bold
                  ),
                ),
              ),
              ...competitiveSessions.map((session) {
                return ListTile(
                  title: Text(
                    'Competitive Workout - ${_formatDate(session.createdAt)}',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CompetitiveWorkoutDetailsView(session: session),
                      ),
                    );
                  },
                );
              }).toList(),
            ],
          ],
        ),
      ),
      floatingActionButton: FabWorkoutMenu(
        onCollaborativeTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const GroupWorkoutRecordingOptionPage(workoutType: 'collaborative'),
            ),
          );
        },
        onCompetitiveTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const GroupWorkoutRecordingOptionPage(workoutType: 'competitive'),
            ),
          );
        },
      ),
    );
  }
}
