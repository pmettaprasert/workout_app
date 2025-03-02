import 'package:flutter/material.dart';
import 'package:hwk3/service/database/entity/exercise_entity.dart';
import 'package:hwk3/service/database/entity/workout_plan_entity.dart';
import 'package:hwk3/service/database/dao/workout_plan_dao.dart';
import 'package:hwk3/data/local_database/database_workout_plans_source.dart';
import 'package:hwk3/data/local_database/database_workout_data_source.dart';
import 'package:hwk3/service/database/app_database.dart';
import 'package:hwk3/service/api_calls/api_call_to_retrieve_workout_from_website.dart';
import 'package:hwk3/repository/recording_workout_plans_repository.dart';
import 'package:hwk3/repository/workout_history_repository.dart';
import 'package:hwk3/repository/recording_workout_repository.dart';
import 'package:hwk3/viewmodels/performance_viewmodel.dart';
import 'package:hwk3/viewmodels/workout_history_viewmodel.dart';
import 'package:hwk3/viewmodels/workout_recording_viewmodel.dart';
import 'package:hwk3/viewmodels/workout_plan_recording_viewmodel.dart';
import 'package:hwk3/views/performance_widget.dart';
import 'package:hwk3/views/workout_history_page.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  final workoutPlanDao = database.workoutPlanDao;
  final workoutDao = database.workoutDao;

  final existingPlans = await workoutPlanDao.findAllWorkoutPlans();
  if (existingPlans.isEmpty) {
    await _insertDefaultPlans(workoutPlanDao);
  }

  final workoutsDataSource = DatabaseWorkoutDataSource(workoutDao);
  final workoutPlansDataSource = DatabaseWorkoutPlansDataSource(workoutPlanDao);
  runApp(MyApp(
    workoutsDataSource: workoutsDataSource,
    workoutPlansDataSource: workoutPlansDataSource,
  ));
}

class MyApp extends StatelessWidget {

  final dynamic workoutsDataSource;
  final dynamic workoutPlansDataSource;

  const MyApp({
    super.key,
    required this.workoutsDataSource,
    required this.workoutPlansDataSource,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<RecordingWorkoutPlansRepository>(
          create: (_) => RecordingWorkoutPlansRepository
            (workoutPlansDataSource, ApiCallToRetrieveWorkoutFromWebsite()),
        ),

        Provider<WorkoutHistoryRepository>(
          create: (_) => WorkoutHistoryRepository(workoutsDataSource),
        ),
        Provider<RecordingWorkoutRepository>(
          create: (_) => RecordingWorkoutRepository(
            workoutPlansDataSource,
            workoutsDataSource,
          ),
        ),

        ChangeNotifierProvider(
          create: (context) =>
              WorkoutHistoryViewModel(context.read<WorkoutHistoryRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              WorkoutRecordingViewModel(context.read<RecordingWorkoutRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              PerformanceViewModel(context.read<WorkoutHistoryRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              WorkoutPlanRecordingViewmodel(context
        .read<RecordingWorkoutPlansRepository>()),

        ),

      ],
      child: MaterialApp(
        builder: (context, child) {
          return SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  const PerformanceWidget(),
                  Expanded(child: child ?? const SizedBox.shrink()),
                ],
              ),
            ),
          );
        },
        home: WorkoutHistoryPage(),
      ),
    );
  }
}


Future<void> _insertDefaultPlans(WorkoutPlanDao dao) async {
  // Create a default "Beginner Mixed Plan"
  final beginnerPlan = WorkoutPlanEntity(id: null, name: 'Beginner Mixed Plan');
  final beginnerExercises = [
    ExerciseEntity(
      id: null,
      workoutPlanId: 0,
      name: 'Push Ups',
      targetOutput: 20,
      unit: 'reps',
    ),
    ExerciseEntity(
      id: null,
      workoutPlanId: 0,
      name: 'Squats',
      targetOutput: 15,
      unit: 'reps',
    ),
    ExerciseEntity(
      id: null,
      workoutPlanId: 0,
      name: 'Plank',
      targetOutput: 60,
      unit: 'seconds',
    ),
  ];


  await dao.insertFullWorkoutPlan(beginnerPlan, beginnerExercises);

  final cardioPlan = WorkoutPlanEntity(id: null, name: 'Cardio Blast');
  final cardioExercises = [
    ExerciseEntity(
      id: null,
      workoutPlanId: 0,
      name: 'Jog',
      targetOutput: 300,
      unit: 'meters',
    ),
    ExerciseEntity(
      id: null,
      workoutPlanId: 0,
      name: 'Sprints',
      targetOutput: 5,
      unit: 'reps',
    ),
  ];

  await dao.insertFullWorkoutPlan(cardioPlan, cardioExercises);
}