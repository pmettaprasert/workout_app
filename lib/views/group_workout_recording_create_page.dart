import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/group_workout_display_record_viewmodel.dart';
import 'workout_plan_http_get_page.dart';
import '../models/exercise.dart';
import '../models/workout_plan.dart';
import 'home_page.dart';

class CreateGroupWorkoutPage extends StatefulWidget {
  final String workoutType; // "collaborative" or "competitive"

  const CreateGroupWorkoutPage({Key? key, required this.workoutType}) : super(key: key);

  @override
  _CreateGroupWorkoutPageState createState() => _CreateGroupWorkoutPageState();
}

class _CreateGroupWorkoutPageState extends State<CreateGroupWorkoutPage> {
  late Future<List<WorkoutPlan>> _plansFuture;

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<WorkoutViewModel>();
    _plansFuture = viewModel.getAllPlans();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WorkoutViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Create ${widget.workoutType.toLowerCase()} Workout'),
      ),
      body: FutureBuilder<List<WorkoutPlan>>(
        future: _plansFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No plans available.'));
          } else {
            final plans = snapshot.data!;
            final selectedPlan = viewModel.selectedPlan;
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildPlanDropdown(viewModel, plans, selectedPlan),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const WorkoutPlanHttpGetPage()),
                        ).then((_) async {
                          await viewModel.reloadPlans();
                          setState(() {
                            _plansFuture = viewModel.getAllPlans();
                          });
                        });
                      },
                      child: const Text('Add Workout From Url'),
                    ),
                  ],
                ),
                if (selectedPlan != null)
                  Expanded(child: _buildExercisesList(viewModel, selectedPlan)),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Record the workout using the viewmodel.
          final sessionId = await viewModel.recordWorkout(widget.workoutType);
          if (sessionId != null) {
            // Clear the entire navigation stack and push the GroupWorkoutsView.
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage(initialSelectedIndex: 1)),
                  (Route<dynamic> route) => false,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to record workout.')),
            );
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  Widget _buildPlanDropdown(
      WorkoutViewModel viewModel,
      List<WorkoutPlan> plans,
      WorkoutPlan? selectedPlan,
      ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<WorkoutPlan>(
        isExpanded: true,
        value: selectedPlan,
        hint: const Text('Select a workout plan'),
        items: plans.map((plan) {
          return DropdownMenuItem<WorkoutPlan>(
            value: plan,
            child: Text(plan.name),
          );
        }).toList(),
        onChanged: (newValue) {
          if (newValue == null) return;
          final index = plans.indexOf(newValue);
          viewModel.selectPlanByIndex(index);
        },
      ),
    );
  }

  Widget _buildExercisesList(
      WorkoutViewModel viewModel,
      WorkoutPlan plan,
      ) {
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
            trailing: _buildInputWidget(
              exercise,
              currentValue,
                  (val) => viewModel.updateActualOutput(exercise, val),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputWidget(
      Exercise exercise,
      int currentValue,
      ValueChanged<int> onChanged,
      ) {
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
