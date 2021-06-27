import 'package:gym_tracker/src/data/model/SetModel.dart';
import 'package:gym_tracker/src/data/repository/BaseRepository.dart';

import '../SQLiteDbProvider.dart';

class SetRepository extends BaseRepository<SetModel> {
  SetRepository() : super(table: "sets", model: SetModel());

  Future<List<SetModel>> getAllByScoreId(int scoreId) async {
    var database = await SQLiteDbProvider.get.database;

    final results = await database
        .query("sets", where: 'score_id = ?', whereArgs: [scoreId]);
    List<SetModel> items = [];

    results.forEach((result) {
      SetModel itemFromMap = model.fromMap(result);
      items.add(itemFromMap);
    });

    return items;
  }
}
