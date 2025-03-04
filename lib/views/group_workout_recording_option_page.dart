import 'package:flutter/material.dart';
import 'group_workout_recording_create_page.dart';
import 'group_workout_recording_join_page.dart';

class GroupWorkoutRecordingOptionPage extends StatelessWidget {
  final String workoutType; // Either "collaborative" or "competitive"

  const GroupWorkoutRecordingOptionPage({Key? key, required this.workoutType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format the heading based on the workoutType.
    final heading = workoutType.toLowerCase() == 'competitive'
        ? 'Competitive Workout'
        : 'Collaborative Workout';

    return Scaffold(
      appBar: AppBar(
        title: Text(heading),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateGroupWorkoutPage(workoutType: workoutType),
                  ),
                );
              },
              child: const Text("Create Workout"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const JoinGroupWorkoutPage(),
                  ),
                );
              },
              child: const Text("Join Workout"),
            ),
          ],
        ),
      ),
    );
  }
}
