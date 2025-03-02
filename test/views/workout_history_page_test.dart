import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:intl/intl.dart';

import '../mocks/workout_history_viewmodel_mock.mocks.dart';
import 'package:hwk3/viewmodels/workout_history_viewmodel.dart';
import 'package:hwk3/views/workout_history_page.dart';
import 'package:hwk3/models/exercise.dart';
import 'package:hwk3/models/workout.dart';
import 'package:hwk3/models/exercise_result.dart';

void main() {
  group('WorkoutHistoryPage', () {
    late MockWorkoutHistoryViewModel mockViewModel;
    setUp(() {
      mockViewModel = MockWorkoutHistoryViewModel();
    });

    testWidgets(
      'shows multiple entries when there are multiple Workouts in the shared state',
          (WidgetTester tester) async {


        final pushUp = Exercise(name: 'Push Up', targetOutput: 10, unit: 'reps');
        final sitUp = Exercise(name: 'Sit Up', targetOutput: 15, unit: 'reps');


        final workout1 = Workout(
          date: DateTime(2025, 2, 18, 10, 0, 0),
          results: [
            ExerciseResult(exercise: pushUp, actualOutput: 12),
            ExerciseResult(exercise: sitUp, actualOutput: 14),
          ],
        );

        final workout2 = Workout(
          date: DateTime(2025, 2, 19, 11, 30, 0),
          results: [
            ExerciseResult(exercise: pushUp, actualOutput: 10),
            ExerciseResult(exercise: sitUp, actualOutput: 16),
          ],
        );


        when(mockViewModel.workouts).thenReturn([workout1, workout2]);


        await tester.pumpWidget(
          ChangeNotifierProvider<WorkoutHistoryViewModel>.value(
            value: mockViewModel,
            child: MaterialApp(
              home: WorkoutHistoryPage(),
            ),
          ),
        );


        await tester.pumpAndSettle();


        expect(find.byType(ListTile), findsNWidgets(2));

        final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
        final workout1Text = 'Workout on ${dateFormat.format(workout1.date)}';
        final workout2Text = 'Workout on ${dateFormat.format(workout2.date)}';

        expect(find.text(workout1Text), findsOneWidget);
        expect(find.text(workout2Text), findsOneWidget);
      },
    );
  });
}
