import 'package:floor/floor.dart';


@Entity(tableName: 'workout')
class WorkoutEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String date;

  WorkoutEntity({this.id, required this.date});
}