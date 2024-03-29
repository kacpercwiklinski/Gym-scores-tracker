import 'package:gym_tracker/src/data/SQLiteDbProvider.dart';
import 'package:gym_tracker/src/data/model/ScoreModel.dart';
import 'package:gym_tracker/src/data/model/UserModel.dart';
import 'package:gym_tracker/src/data/repository/BaseRepository.dart';
import 'package:intl/intl.dart';

class ScoreRepository extends BaseRepository<ScoreModel> {
  String _getAllQuery;

  ScoreRepository() : super(table: "scores", model: ScoreModel()) {
    _getAllQuery =
        "SELECT scores.id as id, users.id as user_id, users.name as user_name, exercises.id as exercise_id, exercises.name as exercise_name, muscle_groups.id as muscle_group_id, muscle_groups.name as muscle_group_name, scores.date as date "
        "FROM $table "
        "INNER JOIN users on users.id = scores.user_id "
        "INNER JOIN exercises on exercises.id = scores.exercise_id "
        "INNER JOIN muscle_groups on exercises.muscle_group_id = muscle_groups.id";
  }

  Future<List<ScoreModel>> getAllWithUserAndExercise({userId = -1}) async {
    var database = await SQLiteDbProvider.get.database;
    var sqlQuery = _getAllQuery;

    if (userId != -1) sqlQuery += " WHERE users.id = $userId";

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

  Future<List<ScoreModel>> getAllWhereUserAndDateBetween(
      {UserModel user, DateTime startDate, DateTime endDate}) async {
    var database = await SQLiteDbProvider.get.database;
    var sqlQuery = _getAllQuery;
    var results = [];
    List<ScoreModel> items = [];

    sqlQuery += " WHERE users.id = ${user.id}";
    sqlQuery +=
        " AND scores.date BETWEEN '${DateFormat('y-MM-dd').format(startDate)} 00:00:00' AND '${DateFormat('y-MM-dd').format(endDate)} 23:59:59.999'";

    try {
      results = await database.rawQuery(sqlQuery);
    } catch (e) {
      print("Score Repository error");
      print(e);
    }

    results.forEach((result) {
      ScoreModel itemFromMap = model.fromMap(result);
      items.add(itemFromMap);
    });

    return items;
  }
}
