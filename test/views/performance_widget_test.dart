import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'package:hwk3/views/performance_widget.dart';
import 'package:hwk3/viewmodels/performance_viewmodel.dart';
import '../mocks/performance_viewmodel_mock.mocks.dart';




void main() {
  group('PerformanceWidget', () {
    late MockPerformanceViewModel mockPerformanceViewModel;

    setUp(() {
      mockPerformanceViewModel = MockPerformanceViewModel();
    });

    testWidgets(
        'displays performance metrics based on the shared state',
            (WidgetTester tester) async {

          when(mockPerformanceViewModel.calculatePerformanceScore())
              .thenReturn(3);

          when(mockPerformanceViewModel.calculateCompletedExercises())
              .thenReturn([5, 7]);

          await tester.pumpWidget(
            ChangeNotifierProvider<PerformanceViewModel>.value(
              value: mockPerformanceViewModel,
              child: const MaterialApp(
                home: Scaffold(
                  body: PerformanceWidget(),
                ),
              ),
            ),
          );


          await tester.pumpAndSettle();

          expect(find.text('Past 7 Days Performance'), findsOneWidget);
          expect(find.text('Number of Workouts Completed: 3'),
              findsOneWidget);
          expect(find.text('5 out of 7 exercises reached target goals.'), findsOneWidget);
        });

    testWidgets(
        'displays default message/metric when no workouts have been done in the past seven days',
            (WidgetTester tester) async {
          when(mockPerformanceViewModel.calculatePerformanceScore())
              .thenReturn(0);
          when(mockPerformanceViewModel.calculateCompletedExercises())
              .thenReturn([0, 0]);

          await tester.pumpWidget(
            ChangeNotifierProvider<PerformanceViewModel>.value(
              value: mockPerformanceViewModel,
              child: const MaterialApp(
                home: Scaffold(
                  body: PerformanceWidget(),
                ),
              ),
            ),
          );


          await tester.pumpAndSettle();
          expect(find.text('Past 7 Days Performance'), findsOneWidget);
          expect(find.text('Number of Workouts Completed: 0'),
              findsOneWidget);
          expect(find.text('0 out of 0 exercises reached target goals.'), findsOneWidget);
        });
  });
}