import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:hwk3/views/widget/fab_workout_menu.dart';

import '../viewmodels/workout_history_viewmodel.dart';
import '../viewmodels/performance_viewmodel.dart';
import 'workout_details_page.dart';
import 'workout_recording_page.dart';
import 'performance_widget.dart';

class WorkoutHistoryPage extends StatelessWidget {
  WorkoutHistoryPage({Key? key}) : super(key: key);

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
        itemCount: workouts.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: PerformanceWidget(),
            );
          }
          final workout = workouts[index - 1];
          final dateString = _dateFormat.format(workout.date);
          final successfulCount =
              workout.results.where((r) => r.isSuccessful).length;
          final totalCount = workout.results.length;
          return ListTile(
            title: Text('Workout on $dateString'),
            subtitle: Text('$successfulCount of $totalCount successful'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WorkoutDetailsPage(workout: workout),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FabWorkoutMenu(
        // 1) Solo workout
        onSoloTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WorkoutRecordingPage()),
          ).then((_) {
            // Refresh data
            context.read<WorkoutHistoryViewModel>().fetchWorkouts();
            context.read<PerformanceViewModel>().refreshPerformanceData();
          });
        },
        // 2) Collaborative workout
        onCollaborativeTap: () {
          // TODO: Navigate to your collaborative workflow
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Collaborative tapped')),
          );
        },
        // 3) Competitive workout
        onCompetitiveTap: () {
          // TODO: Navigate to your competitive workflow
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Competitive tapped')),
          );
        },
      ),
    );
  }
}
