import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/workout.dart';

class WorkoutDetailsPage extends StatelessWidget {
  final Workout workout;
  const WorkoutDetailsPage({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    final dateString = DateFormat('yyyy-MM-dd HH:mm:ss').format(workout.date);
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Details ($dateString)'),
      ),
      body: ListView.builder(
        itemCount: workout.results.length,
        itemBuilder: (context, index) {
          final result = workout.results[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(result.exercise.name),
              subtitle: Text(
                  'Actual: ${result.actualOutput} ${result.exercise.unit} '
                      '\nTarget: ${result.exercise.targetOutput} ${result.exercise.unit}'
              ),
              trailing: Icon(
                result.isSuccessful ? Icons.check_circle : Icons.error,
                color: result.isSuccessful ? Colors.green : Colors.red,
              ),
            )
          );
        }
      )
    );
  }
}