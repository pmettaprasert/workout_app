import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'package:hwk3/models/exercise.dart';
import 'package:hwk3/models/exercise_result.dart';
import 'package:hwk3/models/workout.dart';
import 'package:hwk3/views/workout_details_page.dart';

void main() {

  group('WorkoutDetailsPage', () {

    testWidgets(
      'shows specifics of which exercises were done and actual outputs',
      (WidgetTester tester) async {


        final pushUp = Exercise(name: 'Push Up', targetOutput: 10, unit: 'reps');
        final sitUp = Exercise(name: 'Sit Up', targetOutput: 20, unit: 'reps');

        final pushUpResult = ExerciseResult(exercise: pushUp, actualOutput: 12);
        final sitUpResult = ExerciseResult(exercise: sitUp, actualOutput: 18);

        
        final workout = Workout(
          date: DateTime(2025, 2, 18, 10, 0, 0),
          results: [pushUpResult, sitUpResult],
        );


        final dateString = DateFormat(
          'yyyy-MM-dd HH:mm:ss',
        ).format(workout.date);


        await tester.pumpWidget(
          MaterialApp(home: WorkoutDetailsPage(workout: workout)),
        );
        await tester.pumpAndSettle();


        expect(find.text('Workout Details ($dateString)'), findsOneWidget);


        expect(find.text('Push Up'), findsOneWidget);
        expect(find.textContaining('Actual: 12 reps'), findsOneWidget);
        expect(find.textContaining('Target: 10 reps'), findsOneWidget);
        expect(find.byIcon(Icons.check_circle), findsOneWidget);


        expect(find.text('Sit Up'), findsOneWidget);
        expect(find.textContaining('Actual: 18 reps'), findsOneWidget);
        expect(find.textContaining('Target: 20 reps'), findsOneWidget);
        expect(find.byIcon(Icons.error), findsOneWidget);
      },
    );
  });
}
