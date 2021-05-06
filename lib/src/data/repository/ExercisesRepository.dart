import 'package:gym_tracker/src/data/model/ExerciseModel.dart';

import '../SQLiteDbProvider.dart';
import 'BaseRepository.dart';

class ExercisesRepository extends BaseRepository<ExerciseModel> {
  ExercisesRepository()
      : super(table: "exercises", model: ExerciseModel());


  // @override
  // Future<List<ExerciseModel>> getAll() async {
  //   var database = await SQLiteDbProvider.get.database;
  //   final sqlQuery = "SELECT * FROM $table";
  //   final results = await database.rawQuery(sqlQuery);
  //   List<ExerciseModel> items = [];
  //
  //   results.forEach((result) {
  //     ExerciseModel itemFromMap = model.fromMap(result);
  //     items.add(itemFromMap);
  //   });
  //
  //   return items;
  // }


  Future<List<ExerciseModel>> getAllWithMuscleGroupName() async {
    var database = await SQLiteDbProvider.get.database;
    final sqlQuery = "SELECT exercises.id as id, exercises.name as name, muscle_groups.name as muscle_group_name FROM $table INNER JOIN muscle_groups on muscle_groups.id = exercises.muscle_group_id";

    final results = await database.rawQuery(sqlQuery);
    List<ExerciseModel> items = [];

    results.forEach((result) {
      ExerciseModel itemFromMap = model.fromMapJoined(result);
      items.add(itemFromMap);
    });

    return items;
  }


  // @override
  // insert(ExerciseModel item) async {
  //   var database = await SQLiteDbProvider.get.database;
  //   var id = await getNextId();
  //   final sqlQuery = "INSERT INTO $table (id, name, muscle_group_id) VALUES (?, ?, ?)";
  //   final result = await database.rawInsert(sqlQuery, [id, item.name, item.muscleGroupId]);
  //   return result;
  // }
}
