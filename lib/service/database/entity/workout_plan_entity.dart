import 'package:floor/floor.dart';

@Entity(tableName: 'workout_plan')
class WorkoutPlanEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;

  WorkoutPlanEntity({this.id, required this.name});
}