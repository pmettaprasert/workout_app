import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/workout_plan_recording_viewmodel.dart';

class WorkoutPlanHttpGetPage extends StatefulWidget {
  const WorkoutPlanHttpGetPage({Key? key}) : super(key: key);

  @override
  State<WorkoutPlanHttpGetPage> createState() => _WorkoutPlanHttpGetPageState();
}

class _WorkoutPlanHttpGetPageState extends State<WorkoutPlanHttpGetPage> {
  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel =
      Provider.of<WorkoutPlanRecordingViewmodel>(context, listen: false);
      viewModel.clearWorkoutPlan();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WorkoutPlanRecordingViewmodel>();
    final currentPlan = viewModel.workoutPlan;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Workout Plan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Workout Plan URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),


            ElevatedButton(
              onPressed: () async {
                final url = _urlController.text.trim();
                if (url.isNotEmpty) {
                  await viewModel.loadWorkoutPlanFromUrl(url);
                }
              },
              child: const Text('Get Workout'),
            ),

            const SizedBox(height: 16),

            if (currentPlan != null) ...[
              Text(
                'Current Workout Plan: ${currentPlan.name}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: currentPlan.exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = currentPlan.exercises[index];
                    return ListTile(
                      title: Text(exercise.name),
                      subtitle: Text(
                          'Target: ${exercise.targetOutput} ${exercise.unit}'),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Add the current plan to the database.
                  await viewModel.addPlan(currentPlan);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Plan added to the database')),
                  );
                },
                child: const Text('Add to Database'),
              ),
            ] else
              const Text('No workout plan loaded yet.'),
          ],
        ),
      ),
    );
  }
}