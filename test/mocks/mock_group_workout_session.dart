import 'package:mockito/annotations.dart';
import 'package:hwk3/repository/group_workout_session_repository.dart';
import 'package:hwk3/repository/recording_workout_repository.dart';
import 'package:hwk3/repository/auth_repository.dart';

@GenerateMocks([
  GroupWorkoutSessionRepository,
  RecordingWorkoutRepository,
  AuthRepository,
])
void main() {}
