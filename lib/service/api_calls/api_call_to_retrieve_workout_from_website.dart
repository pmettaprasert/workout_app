import 'api_call_to_retrieve_workout.dart';
import 'package:http/http.dart' as http;
import '../../models/workout_plan.dart';

import 'dart:convert';


class ApiCallToRetrieveWorkoutFromWebsite implements ApiCallToRetrieveWorkout {
  final http.Client client;

  ApiCallToRetrieveWorkoutFromWebsite({http.Client? client})
      : client = client ?? http.Client();

  @override
  Future<WorkoutPlan> getWorkout(String url) async {
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return WorkoutPlan.fromJson(jsonData);
    } else {
      throw Exception('Failed to retrieve workout plan');
    }
  }
}


