import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:hwk3/service/api_calls/api_call_to_retrieve_workout_from_website.dart';


void main() {
  group('ApiCallToRetrieveWorkoutFromWebsite', () {
    test('returns a WorkoutPlan on a successful API call', () async {

      // Arrange: Create a mock JSON response.
      final mockJsonResponse = json.encode({
        "name": "Test Workout",
        "exercises": [
          {"name": "Push Ups", "targetOutput": 20, "unit": "reps"},
          {"name": "Squats", "targetOutput": 15, "unit": "reps"}
        ]
      });

      // Create a MockClient that returns the mock JSON with a 200 status code.
      final client = MockClient((request) async {
        return http.Response(mockJsonResponse, 200);
      });

      final api = ApiCallToRetrieveWorkoutFromWebsite(client: client);

      // Act: Call the getWorkout method.
      final workoutPlan = await api.getWorkout('http://fakeurl.com');

      // Assert: Verify the returned WorkoutPlan matches our expectations.
      expect(workoutPlan.name, equals("Test Workout"));
      expect(workoutPlan.exercises.length, equals(2));
      expect(workoutPlan.exercises[0].name, equals("Push Ups"));
      expect(workoutPlan.exercises[0].targetOutput, equals(20));
      expect(workoutPlan.exercises[0].unit, equals("reps"));
      expect(workoutPlan.exercises[1].name, equals("Squats"));
      expect(workoutPlan.exercises[1].targetOutput, equals(15));
      expect(workoutPlan.exercises[1].unit, equals("reps"));
    });

    test('throws an exception on a non-200 response', () async {
      // Arrange: create a MockClient that returns an error status code.
      final client = MockClient((request) async {
        return http.Response("Not Found", 404);
      });

      // Instantiate your API call class with the mock client.
      final api = ApiCallToRetrieveWorkoutFromWebsite(client: client);

      // Assert: expect an exception when the API call fails.
      expect(api.getWorkout('http://fakeurl.com'), throwsException);
    });
  });
}