import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/group_workout_display_record_viewmodel.dart';
import '../models/exercise.dart';
import '../models/workout_plan.dart';
import 'home_page.dart';

class JoinGroupWorkoutPage extends StatefulWidget {
  const JoinGroupWorkoutPage({Key? key}) : super(key: key);

  @override
  _JoinGroupWorkoutPageState createState() => _JoinGroupWorkoutPageState();
}

class _JoinGroupWorkoutPageState extends State<JoinGroupWorkoutPage> {
  final TextEditingController _inviteCodeController = TextEditingController();
  bool _sessionLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<WorkoutViewModel>();
      viewModel.clearSessionByInvite();
    });
  }

  @override
  void dispose() {
    _inviteCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WorkoutViewModel>();
    final session = viewModel.sessionByInvite;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Join a Group Workout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: session == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _inviteCodeController,
              decoration: const InputDecoration(
                labelText: 'Enter Invite Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final code = _inviteCodeController.text.trim();
                if (code.isNotEmpty) {
                  await viewModel.loadWorkoutSessionByInviteCode(code);
                  // After loading, trigger rebuild.
                  setState(() {
                    _sessionLoaded = viewModel.sessionByInvite != null;
                  });
                }
              },
              child: const Text('Get Workout'),
            ),
          ],
        )
            : Column(
          children: [
            // Display header information: createdBy and createdAt.
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Created By: ${session!.createdBy}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Date: ${session.createdAt.day}/${session.createdAt.month}/${session.createdAt.year}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Invite Code: ${session.inviteCode}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            // Display the list of exercises from the workout plan.
            Expanded(child: _buildExercisesList(viewModel, session.workoutPlan)),
          ],
        ),
      ),
      floatingActionButton: session != null
          ? FloatingActionButton(
        onPressed: () async {
          // Build contributions map from the actual outputs.
          final contributions = <String, int>{};
          session.workoutPlan.exercises.forEach((exercise) {
            contributions[exercise.name] = viewModel.actualOutputs[exercise] ?? 0;
          });
          // Call updateParticipantContribution.
          // (Assuming session.workoutId is set in the loaded session.)
          await viewModel.updateParticipantContributions(
            workoutId: session.workoutId,
            userId: viewModel.authRepository.currentUser!.uid,
            newContributions: contributions,
          );
          // After a successful update, clear navigation stack and go back to Group Workouts.
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage(initialSelectedIndex: 1)),
                (Route<dynamic> route) => false,
          );
        },
        child: const Icon(Icons.check),
      )
          : null,
    );
  }

  Widget _buildExercisesList(WorkoutViewModel viewModel, WorkoutPlan plan) {
    final exercises = plan.exercises;
    return ListView.builder(
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        final currentValue = viewModel.actualOutputs[exercise] ?? 0;
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text(exercise.name),
            subtitle: Text('Target: ${exercise.targetOutput} ${exercise.unit}'),
            trailing: _buildInputWidget(exercise, currentValue, (val) {
              viewModel.updateActualOutput(exercise, val);
            }),
          ),
        );
      },
    );
  }

  Widget _buildInputWidget(Exercise exercise, int currentValue, ValueChanged<int> onChanged) {
    if (exercise.unit == 'reps') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              int newValue = currentValue > 0 ? currentValue - 1 : 0;
              onChanged(newValue);
            },
          ),
          Text('$currentValue'),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              onChanged(currentValue + 1);
            },
          ),
        ],
      );
    } else if (exercise.unit == 'seconds') {
      return SizedBox(
        width: 160,
        child: Row(
          children: [
            Expanded(
              child: Slider(
                value: currentValue.toDouble(),
                min: 0,
                max: (exercise.targetOutput * 2).toDouble(),
                divisions: exercise.targetOutput * 2,
                label: '$currentValue s',
                onChanged: (value) {
                  onChanged(value.round());
                },
              ),
            ),
            Text('${currentValue}s'),
          ],
        ),
      );
    } else if (exercise.unit == 'meters') {
      return MetersInput(
        initialValue: currentValue,
        onChanged: onChanged,
      );
    } else {
      return Text('$currentValue');
    }
  }
}

class MetersInput extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onChanged;

  const MetersInput({
    required this.initialValue,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<MetersInput> createState() => _MetersInputState();
}

class _MetersInputState extends State<MetersInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '${widget.initialValue}');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'm',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          final parsed = int.tryParse(value) ?? 0;
          widget.onChanged(parsed);
        },
      ),
    );
  }
}