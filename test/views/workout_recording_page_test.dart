import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../mocks/workout_recording_viewmodel_mock.mocks.dart';
import 'package:hwk3/viewmodels/workout_recording_viewmodel.dart';
import 'package:hwk3/views/workout_recording_page.dart';
import 'package:hwk3/models/exercise.dart';
import 'package:hwk3/models/workout_plan.dart';


void main() {
  group('WorkoutRecordingPage', () {
    late MockWorkoutRecordingViewModel mockViewModel;

    setUp(() {
      mockViewModel = MockWorkoutRecordingViewModel();
    });

    testWidgets(
      'shows a separate input for each exercise in the workout plan it\'s given',
          (WidgetTester tester) async {

        // create the exercises
        final exerciseReps = Exercise(name: 'Push Ups', targetOutput: 10, unit: 'reps');
        final exerciseSeconds = Exercise(name: 'Plank', targetOutput: 30, unit: 'seconds');
        final exerciseMeters = Exercise(name: 'Running', targetOutput: 1000, unit: 'meters');

        // create the plan
        final plan = WorkoutPlan(
          name: 'Test Plan',
          exercises: [exerciseReps, exerciseSeconds, exerciseMeters],
        );

        // stub some behaviors
        when(mockViewModel.getAllPlans()).thenAnswer((_) async => [plan]);
        when(mockViewModel.selectedPlan).thenReturn(plan);
        when(mockViewModel.actualOutputs).thenReturn({
          exerciseReps: 0,
          exerciseSeconds: 0,
          exerciseMeters: 0,
        });

        // create the widget to test
        await tester.pumpWidget(
          ChangeNotifierProvider<WorkoutRecordingViewModel>.value(
            value: mockViewModel,
            child: const MaterialApp(
              home: WorkoutRecordingPage(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // dropdown is present
        expect(find.byType(DropdownButton<WorkoutPlan>), findsOneWidget);

        // find only one dropdown item
        expect(find.byType(DropdownMenuItem<WorkoutPlan>), findsOneWidget);

        // find the add and the minus button
        expect(find.widgetWithIcon(IconButton, Icons.remove), findsOneWidget);
        expect(find.widgetWithIcon(IconButton, Icons.add), findsOneWidget);

        // find a slider
        expect(find.byType(Slider), findsOneWidget);

        // find the meters input
        expect(find.byType(MetersInput), findsOneWidget);

        // find three cards for each of the exercise
        expect(find.byType(Card), findsNWidgets(3));
      },
    );

    testWidgets(
      'adds a Workout to the shared state when the user fills out and ends a workout',
          (WidgetTester tester) async {


        final exercise = Exercise(name: 'Push Ups', targetOutput: 10, unit: 'reps');
        final plan = WorkoutPlan(name: 'Plan A', exercises: [exercise]);

        when(mockViewModel.getAllPlans()).thenAnswer((_) async => [plan]);
        when(mockViewModel.selectedPlan).thenReturn(plan);
        when(mockViewModel.actualOutputs).thenReturn({exercise: 0});


        await tester.pumpWidget(
          ChangeNotifierProvider<WorkoutRecordingViewModel>.value(
            value: mockViewModel,
            child: const MaterialApp(
              home: WorkoutRecordingPage(),
            ),
          ),
        );

        await tester.pumpAndSettle();


        final fabFinder = find.byType(FloatingActionButton);
        expect(fabFinder, findsOneWidget);
        await tester.tap(fabFinder);
        await tester.pumpAndSettle();

        verify(mockViewModel.recordWorkout()).called(1);
      },
    );
  });
}