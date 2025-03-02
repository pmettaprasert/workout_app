// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  WorkoutPlanDao? _workoutPlanDaoInstance;

  WorkoutDao? _workoutDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `workout_plan` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `exercise` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `workoutPlanId` INTEGER NOT NULL, `name` TEXT NOT NULL, `targetOutput` INTEGER NOT NULL, `unit` TEXT NOT NULL, FOREIGN KEY (`workoutPlanId`) REFERENCES `workout_plan` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `workout` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `date` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `exercise_result` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `workoutId` INTEGER NOT NULL, `exerciseName` TEXT NOT NULL, `exerciseTargetOutput` INTEGER NOT NULL, `exerciseUnit` TEXT NOT NULL, `actualOutput` INTEGER NOT NULL, `isSuccessful` INTEGER NOT NULL, FOREIGN KEY (`workoutId`) REFERENCES `workout` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  WorkoutPlanDao get workoutPlanDao {
    return _workoutPlanDaoInstance ??=
        _$WorkoutPlanDao(database, changeListener);
  }

  @override
  WorkoutDao get workoutDao {
    return _workoutDaoInstance ??= _$WorkoutDao(database, changeListener);
  }
}

class _$WorkoutPlanDao extends WorkoutPlanDao {
  _$WorkoutPlanDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _workoutPlanEntityInsertionAdapter = InsertionAdapter(
            database,
            'workout_plan',
            (WorkoutPlanEntity item) =>
                <String, Object?>{'id': item.id, 'name': item.name}),
        _exerciseEntityInsertionAdapter = InsertionAdapter(
            database,
            'exercise',
            (ExerciseEntity item) => <String, Object?>{
                  'id': item.id,
                  'workoutPlanId': item.workoutPlanId,
                  'name': item.name,
                  'targetOutput': item.targetOutput,
                  'unit': item.unit
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<WorkoutPlanEntity> _workoutPlanEntityInsertionAdapter;

  final InsertionAdapter<ExerciseEntity> _exerciseEntityInsertionAdapter;

  @override
  Future<List<WorkoutPlanEntity>> findAllWorkoutPlans() async {
    return _queryAdapter.queryList('SELECT * FROM workout_plan',
        mapper: (Map<String, Object?> row) => WorkoutPlanEntity(
            id: row['id'] as int?, name: row['name'] as String));
  }

  @override
  Future<WorkoutPlanEntity?> findWorkoutPlanByName(String name) async {
    return _queryAdapter.query('SELECT * FROM workout_plan WHERE name = ?1',
        mapper: (Map<String, Object?> row) => WorkoutPlanEntity(
            id: row['id'] as int?, name: row['name'] as String),
        arguments: [name]);
  }

  @override
  Future<List<ExerciseEntity>> findExercisesByWorkoutPlanId(
      int workoutPlanId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM exercise WHERE workoutPlanId = ?1',
        mapper: (Map<String, Object?> row) => ExerciseEntity(
            id: row['id'] as int?,
            workoutPlanId: row['workoutPlanId'] as int,
            name: row['name'] as String,
            targetOutput: row['targetOutput'] as int,
            unit: row['unit'] as String),
        arguments: [workoutPlanId]);
  }

  @override
  Future<void> deleteAllWorkoutPlans() async {
    await _queryAdapter.queryNoReturn('DELETE FROM workout_plan');
  }

  @override
  Future<void> deleteAllExercises() async {
    await _queryAdapter.queryNoReturn('DELETE FROM exercise');
  }

  @override
  Future<int> insertWorkoutPlan(WorkoutPlanEntity workoutPlan) {
    return _workoutPlanEntityInsertionAdapter.insertAndReturnId(
        workoutPlan, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertExercises(List<ExerciseEntity> exercises) {
    return _exerciseEntityInsertionAdapter.insertListAndReturnIds(
        exercises, OnConflictStrategy.abort);
  }

  @override
  Future<int> insertFullWorkoutPlan(
    WorkoutPlanEntity workoutPlan,
    List<ExerciseEntity> exercises,
  ) async {
    if (database is sqflite.Transaction) {
      return super.insertFullWorkoutPlan(workoutPlan, exercises);
    } else {
      return (database as sqflite.Database)
          .transaction<int>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        return transactionDatabase.workoutPlanDao
            .insertFullWorkoutPlan(workoutPlan, exercises);
      });
    }
  }
}

class _$WorkoutDao extends WorkoutDao {
  _$WorkoutDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _workoutEntityInsertionAdapter = InsertionAdapter(
            database,
            'workout',
            (WorkoutEntity item) =>
                <String, Object?>{'id': item.id, 'date': item.date}),
        _exerciseResultEntityInsertionAdapter = InsertionAdapter(
            database,
            'exercise_result',
            (ExerciseResultEntity item) => <String, Object?>{
                  'id': item.id,
                  'workoutId': item.workoutId,
                  'exerciseName': item.exerciseName,
                  'exerciseTargetOutput': item.exerciseTargetOutput,
                  'exerciseUnit': item.exerciseUnit,
                  'actualOutput': item.actualOutput,
                  'isSuccessful': item.isSuccessful ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<WorkoutEntity> _workoutEntityInsertionAdapter;

  final InsertionAdapter<ExerciseResultEntity>
      _exerciseResultEntityInsertionAdapter;

  @override
  Future<List<WorkoutEntity>> findAllWorkouts() async {
    return _queryAdapter.queryList('SELECT * FROM workout',
        mapper: (Map<String, Object?> row) =>
            WorkoutEntity(id: row['id'] as int?, date: row['date'] as String));
  }

  @override
  Future<List<ExerciseResultEntity>> findExerciseResultsByWorkoutId(
      int workoutId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM exercise_result WHERE workoutId = ?1',
        mapper: (Map<String, Object?> row) => ExerciseResultEntity(
            id: row['id'] as int?,
            workoutId: row['workoutId'] as int,
            exerciseName: row['exerciseName'] as String,
            exerciseTargetOutput: row['exerciseTargetOutput'] as int,
            exerciseUnit: row['exerciseUnit'] as String,
            actualOutput: row['actualOutput'] as int,
            isSuccessful: (row['isSuccessful'] as int) != 0),
        arguments: [workoutId]);
  }

  @override
  Future<int> insertWorkout(WorkoutEntity workout) {
    return _workoutEntityInsertionAdapter.insertAndReturnId(
        workout, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertExerciseResults(List<ExerciseResultEntity> results) {
    return _exerciseResultEntityInsertionAdapter.insertListAndReturnIds(
        results, OnConflictStrategy.abort);
  }

  @override
  Future<int> insertFullWorkout(
    WorkoutEntity workout,
    List<ExerciseResultEntity> exerciseResults,
  ) async {
    if (database is sqflite.Transaction) {
      return super.insertFullWorkout(workout, exerciseResults);
    } else {
      return (database as sqflite.Database)
          .transaction<int>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        return transactionDatabase.workoutDao
            .insertFullWorkout(workout, exerciseResults);
      });
    }
  }
}
