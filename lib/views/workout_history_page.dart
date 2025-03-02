import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../viewmodels/workout_history_viewmodel.dart';
import '../viewmodels/performance_viewmodel.dart';
import 'workout_details_page.dart';
import 'workout_recording_page.dart';

class WorkoutHistoryPage extends StatelessWidget {
  WorkoutHistoryPage({super.key});

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WorkoutHistoryViewModel>();
    final workouts = viewModel.workouts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout History'),
      ),
      body: workouts.isEmpty
          ? const Center(child: Text('No workouts recorded yet.'))
          : ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];
          final dateString = _dateFormat.format(workout.date);
          final successfulCount =
              workout.results.where((r) => r.isSuccessful).length;
          final totalCount = workout.results.length;
          return ListTile(
            title: Text('Workout on $dateString'),
            subtitle:
            Text('$successfulCount of $totalCount successful'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      WorkoutDetailsPage(workout: workout),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const WorkoutRecordingPage()),
          ).then((_) {
            context.read<WorkoutHistoryViewModel>().fetchWorkouts();
            context.read<PerformanceViewModel>().refreshPerformanceData();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
