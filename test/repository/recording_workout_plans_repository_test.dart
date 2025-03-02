import '../mocks/api_call_to_retrieve_workout_from_website_mock.mocks.dart';
import '../mocks/database_workout_plans_source_mock.mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:hwk3/repository/recording_workout_plans_repository.dart';
import 'package:hwk3/models/workout_plan.dart';
import 'package:hwk3/models/exercise.dart';


void main() {
  group('RecordingWorkoutPlansRepository', () {
    late MockDatabaseWorkoutPlansDataSource mockDataSource;
    late MockApiCallToRetrieveWorkoutFromWebsite mockApi;
    late RecordingWorkoutPlansRepository repository;

    setUp(() {
      mockDataSource = MockDatabaseWorkoutPlansDataSource();
      mockApi = MockApiCallToRetrieveWorkoutFromWebsite();
      repository = RecordingWorkoutPlansRepository(mockDataSource, mockApi);
    });

    test('getWorkout returns workout plan from API', () async {
      final url = 'http://example.com/workout';
      final workoutPlan = WorkoutPlan(
        name: 'Test Plan',
        exercises: [
          Exercise(name: 'Push Ups', targetOutput: 10, unit: 'reps'),
        ],
      );


      when(mockApi.getWorkout(url)).thenAnswer((_) async => workoutPlan);

      final result = await repository.getWorkout(url);

      expect(result, workoutPlan);
      verify(mockApi.getWorkout(url)).called(1);
    });

    test('addPlan calls data source addPlan', () async {
      final workoutPlan = WorkoutPlan(
        name: 'New Plan',
        exercises: [
          Exercise(name: 'Squats', targetOutput: 15, unit: 'reps'),
        ],
      );

      when(mockDataSource.addPlan(workoutPlan)).thenAnswer((_) async => Future.value());

      await repository.addPlan(workoutPlan);

      verify(mockDataSource.addPlan(workoutPlan)).called(1);
    });
  });
}