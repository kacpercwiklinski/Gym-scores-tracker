import 'package:gym_tracker/src/data/model/MuscleGroupModel.dart';

import 'BaseRepository.dart';

class MuscleGroupRepository extends BaseRepository<MuscleGroupModel> {
  MuscleGroupRepository()
      : super(table: "muscle_group", model: MuscleGroupModel());

  @override
  insert(MuscleGroupModel item) async {
    var id = await getNextId();
    final sqlQuery = "INSERT INTO $table (id, name) VALUES (?, ?)";
    final result = await database.rawInsert(sqlQuery, [id, item.name]);
    return result;
  }
}
