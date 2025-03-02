import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/performance_viewmodel.dart';

class PerformanceWidget extends StatelessWidget {
  const PerformanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PerformanceViewModel>();

    final score = viewModel.calculatePerformanceScore();
    final completedExercises = viewModel.calculateCompletedExercises();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Past 7 Days Performance",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Number of Workouts Completed: $score",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              "${completedExercises[0]} out of ${completedExercises[1]} exercises reached target goals.",
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}