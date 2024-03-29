import 'package:gym_tracker/src/data/model/ExerciseModel.dart';

import '../SQLiteDbProvider.dart';
import 'BaseRepository.dart';

class ExercisesRepository extends BaseRepository<ExerciseModel> {
  ExercisesRepository() : super(table: "exercises", model: ExerciseModel());

  @override
  Future<List<ExerciseModel>> getAll() async {
    var database = await SQLiteDbProvider.get.database;
    final sqlQuery =
        "SELECT exercises.id as id, exercises.name as name, muscle_groups.id as muscle_group_id,muscle_groups.name as muscle_group_name FROM $table INNER JOIN muscle_groups on muscle_groups.id = exercises.muscle_group_id";

    final results = await database.rawQuery(sqlQuery);
    List<ExerciseModel> items = [];

    results.forEach((result) {
      ExerciseModel itemFromMap = model.fromMap(result);
      items.add(itemFromMap);
    });

    return items;
  }
}
