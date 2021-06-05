import 'package:gym_tracker/src/data/SQLiteDbProvider.dart';
import 'package:gym_tracker/src/data/model/ScoreModel.dart';
import 'package:gym_tracker/src/data/repository/BaseRepository.dart';

class ScoreRepository extends BaseRepository<ScoreModel> {
  ScoreRepository() : super(table: "scores", model: ScoreModel());

  Future<List<ScoreModel>> getAllWithUserNameAndExerciseName({userId = -1}) async {
    var database = await SQLiteDbProvider.get.database;
    var sqlQuery =
        "SELECT scores.id as id, users.id as user_id, users.name as user_name, exercises.id as exercise_id, exercises.name as exercise_name, muscle_groups.id as muscle_group_id, muscle_groups.name as muscle_group_name, scores.score as score, scores.repeats as repeats, scores.date as date "
        "FROM $table "
        "INNER JOIN users on users.id = scores.user_id "
        "INNER JOIN exercises on exercises.id = scores.exercise_id "
        "INNER JOIN muscle_groups on exercises.muscle_group_id = muscle_groups.id";

    if(userId != -1)
      sqlQuery += " WHERE users.id = $userId";

    var results = [];

    try {
      results = await database.rawQuery(sqlQuery);
    } catch (e) {
      print("Score Repository error");
      print(e);
    }

    List<ScoreModel> items = [];

    results.forEach((result) {
      ScoreModel itemFromMap = model.fromMap(result);
      items.add(itemFromMap);
    });

    return items;
  }
}
