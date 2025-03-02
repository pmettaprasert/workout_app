import 'exercise_result.dart';
import 'package:intl/intl.dart';

class Workout {
  final DateTime date;
  final String _formattedDate;
  final List<ExerciseResult> results;
  Workout({
    required this.date,
    required this.results,
  }) : _formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);


}